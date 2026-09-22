package RuleBuilder::Model::ConditionSet;

use v5.11;
use Moo;
use JSON::MaybeXS qw(encode_json decode_json);
use POSIX qw( strftime );
use FindBin;
use lib "$FindBin::Bin/../lib";
use RuleBuilder::StructMatcherClient qw( evaluate );

has result =>	(
    is => 'rw',
    required => 1,
);
has conditions => (
    is => 'rw', 
    default => sub { [] }
);
has metadata =>(
    is => 'rw',
    default => sub {
        {
            created => strftime('%Y-%m-%d', localtime),
            version => 1,
        };
    },
);

sub add_condition {
	my ($self, $condition) = @_;
	push @{ $self->conditions}, $condition;
}

sub to_hash {
	my $self = shift;

	return {
		result => $self->result,
		conditions => [
			map { $_->to_hash} @{ $self->conditions}
		],
        metadata => $self->metadata,
	};
}

# Here to enable RuleBuilder to check a specific ruleset
sub test {
    my ($self, $data) = @_;
    die "Data must be a hashref" unless ref $data eq 'HASH';

    my $result = evaluate( 
        $self->to_hash,		# The condition
        $data,			# The data to test against
        'Test-ConditionSet',	# The PS function to call
        'Rule'			# The parameter name for the function
    );
    return $result;
}

42;
