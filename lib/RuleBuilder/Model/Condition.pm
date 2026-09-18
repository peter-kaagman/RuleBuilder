package RuleBuilder::Model::Condition;

use v5.11;
use Moo;
use JSON::MaybeXS qw(encode_json decode_json);
use Data::Dumper;
use FindBin;
use lib "$FindBin::Bin/../lib";
use RuleBuilder::StructMatcherClient qw( evaluate );

has metadata => ( is => 'rw' );
has path     => ( is => 'rw' );
has operator => ( is => 'rw' );
has check    => ( is => 'rw' );
has missingok => ( is => 'rw');

sub to_hash {
    my $self = shift;

    # return {
    #     path     => $self->path,
    #     operator => $self->operator,
    #     check    => $self->check,
    # };
    say Dumper $self;
    return $self;
}

sub to_json {
    my $self = shift;
    return encode_json( $self->to_hash );
}

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
