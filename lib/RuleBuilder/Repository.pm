package RuleBuilder::Repository;

use Moo;

has backend => (
    is       => 'ro',
    required => 1,
);

sub list {
    my $self = shift;
    return $self->backend->list(@_);
}

sub load {
    my $self = shift;
    return $self->backend->load(@_);
}

sub save {
    my $self = shift;
    return $self->backend->save(@_);
}

sub delete {
    my $self = shift;
    return $self->backend->delete(@_);
}

1;
