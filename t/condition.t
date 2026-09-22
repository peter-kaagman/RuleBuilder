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

ok(
    $condition->test({ role => 'Something' }),
    'Condition returns true checking negative test on non existing property'
);

$condition = RuleBuilder::Model::Condition->new(
    path     => 'department',
    operator => 'NotEquals',
    check    => 'IT',
    missingok => 0
);

is(
    $condition->test({ role => 'Something' }),
    0,
    'Condition returns false checking negative test on non existing property'
);

done_testing;
