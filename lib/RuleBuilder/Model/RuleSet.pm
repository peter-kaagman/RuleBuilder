package RuleBuilder::Model::RuleSet;

use v5.11;
use Moo;
use JSON::MaybeXS qw(encode_json decode_json);
use POSIX qw(strftime);
use FindBin;
use lib "$FindBin::Bin/../lib";
use RuleBuilder::StructMatcherClient qw( evaluate );

has conditionsets => (is => 'rw', default => sub { [] });
has created =>(
    is => 'rw',
    default => sub {
        strftime('%Y-%m-%d', localtime);
    },
);

sub add_conditionset {
	my ($self, $conditionset) = @_;
	push @{ $self->conditionsets}, $conditionset;
}

sub to_hash {
	my $self = shift;

	return [
		map { $_->to_hash} @{ $self->conditionsets}
	];
}

sub test {
    my ($self, $data) = @_;
    die "Data must be a hashref" unless ref $data eq 'HASH';

    my $result = evaluate( 
        $self->to_hash, 		# The condtion
        $data,      			# The data to test against
        'Invoke-StructMatcher',	# The PS function to call
        'rules'			        # The parameter name for the function
    );

    $result = [] unless defined $result;

    return $result if ref($result) eq 'ARRAY';
    return [ $result ];
}

42;
