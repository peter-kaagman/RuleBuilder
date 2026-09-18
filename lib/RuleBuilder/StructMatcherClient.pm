package RuleBuilder::StructMatcherClient;

use v5.11;
use strict;
use FindBin;
# use lib "$FindBin::Bin/../lib";
use IPC::Open3;
use Symbol qw(gensym);
use JSON::MaybeXS qw( encode_json decode_json );

use Exporter 'import';
our @EXPORT_OK = qw( evaluate );

sub evaluate {
	# Pass these as hash references
	my ($input, $data, $function, $parameter ) = @_;

	# # Validate
	die "Input must be a hashref or arrayref" 
		unless 
			ref $input eq 'HASH' || 
			ref $input eq 'ARRAY';
	die "Data must be a hashref" 
		unless ref $data eq 'HASH';
	
	# Payload contains the actual PowerShell parameters for the test
	my $payload = encode_json({
			input => $input,
			data => $data,
	});
	
	# Creating a here-doc variable to hold the PowerShell script
	#
	# The PowerShell module to do the test
	my $module = "$FindBin::Bin/../../structmatcher/StructMatcher.psm1";

	my $powershell =<<"POWERSHELL";
	\$ErrorActionPreference = 'Stop'

	try{
		Import-Module -Name $module -Force

		\$request = [System.Console]::In.ReadToEnd() | ConvertFrom-Json

		\$result = & $function `
		-$parameter \$request.input `
		-Data \$request.data

		ConvertTo-Json -InputObject \$result -Compress

		
	}
	catch{
		Write-Error (\$_ | Out-String)
		exit 1
	}
POWERSHELL
		# \@{
		# 	result = \$result 
		# } | ConvertTo-Json -Compress

	my $stderr = gensym;

	my $pid = open3(
		my $stdin,
		my $stdout,
		$stderr,
		'pwsh',
		'-NoProfile',
		'-NonInteractive',
		'-Command',
		$powershell,
	);

	print {$stdin} $payload;
	close $stdin;

	my $output = do {
		local $/;
		<$stdout> // '';
	};

	my $error = do {
		local $/;
		<$stderr> // '';
	};

	waitpid $pid, 0;

	my $exit_code = $? >> 8;

	die "Powershell failed with exit code $exit_code: \n$error" if $exit_code != 0;

	my $json = JSON::MaybeXS->new->allow_nonref;
	my $response = $json->decode($output);
	return $response;
}

42;
