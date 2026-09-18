#!/usr/bin/env perl

use v5.36;
use Test::More;

use FindBin;
use lib "$FindBin::Bin/../lib";

use RuleBuilder::Model::Condition;

my $condition = RuleBuilder::Model::Condition->new(
    path     => 'department',
    operator => 'NotEquals',
    check    => 'IT',
);

ok(
    !$condition->test({ department => 'IT' }),
    'Condition returns false when department equals IT'
);

ok(
    $condition->test({ department => 'Finance' }),
    'Condition returns true when department differs from IT'
);

done_testing;
