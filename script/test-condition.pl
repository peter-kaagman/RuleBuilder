#!/bin/env perl
#
use v5.36;
use utf8;
use strict;
use JSON::MaybeXS qw( encode_json decode_json);
use Data::Dumper;
use IPC::Open3;
use Symbol qw(gensym);

use FindBin;
use lib "$FindBin::Bin/../lib";
use RuleBuilder::Model::Condition;

my %data = (
	'department' => 'IT'
);

my $condition = RuleBuilder::Model::Condition->new(
	path => 'department',
	operator => 'Equals',
	check => 'IT'
);


my $condition_json = $condition->to_json;
my $data_json = encode_json(\%data);


my $module = "$FindBin::Bin/../../structmatcher/StructMatcher.psm1";

(my $ps_module = $module) =~ s/'/''/g;

my $payload = encode_json({
	condition => decode_json($condition->to_json),
	data => \%data,
});

local $ENV{STRUCTMATCHER_MODULE} = $ps_module;
my $powershell =<<'POWERSHELL';
$ErrorActionPreference = 'Stop'

try{
	Import-Module $env:STRUCTMATCHER_MODULE -Force

	$request = [System.Console]::In.ReadToEnd() | ConvertFrom-Json

	$result = Test-Condition `
		-Condition $request.condition `
		-Data $request.data
	
	@{
		matched = [bool]$result
	}  | ConvertTo-Json -Compress
}
catch{
	Write-Error ($_ | Out-String)
	exit 1
}
POWERSHELL

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

my $result = decode_json($output);

say $result ? "Match" : "No match";
