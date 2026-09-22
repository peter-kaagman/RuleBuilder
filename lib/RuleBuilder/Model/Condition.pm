package RuleBuilder::Model::Condition;

use v5.11;
use Moo;
use Types::Standard qw (Bool);
use FindBin;
use lib "$FindBin::Bin/../lib";
use RuleBuilder::StructMatcherClient qw( evaluate );

has path     => ( 
    is => 'rw', 
    required => 1,
);
has operator => ( 
    is => 'rw', 
    default =>  sub { 'Equals' } 
);
has check    => ( 
    is => 'rw',
    required => 1
);
has missingok => ( 
    is => 'rw',
    default => sub { 1 },
);

sub to_hash {
    my $self = shift;

    # Do not add default to the hash
    my $hash = {
        path     => $self->path,
        check    => $self->check,
    };
    # Add them if they differ from the default
    $hash->{'operator'} = $self->operator unless ($self->operator eq 'Equals');
    $hash->{'missingok'} = 0 unless $self->missingok;
    return $hash;
}

# sub to_json {
#     my $self = shift;
#     return encode_json( $self->to_hash );
# }

# This is here to individualy test a condtion against
# StructMatcher and validate it.
sub test {
    my ($self, $data) = @_;
    die "Data must be a hashref" unless ref $data eq 'HASH';

    my $result = evaluate( 
        $self->to_hash,     # The condtion
        $data,              # The data to test against
        'Test-Condition',   # The PS function to call
        'Condition'         # The parameter name for the function
    );
    return $result;
}


1;
