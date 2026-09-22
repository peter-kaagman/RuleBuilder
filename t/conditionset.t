#!/usr/bin/env perl

use v5.36;
use Test::More;

use FindBin;
use lib "$FindBin::Bin/../lib";

use RuleBuilder::Model::Condition;
use RuleBuilder::Model::ConditionSet;

my $conditionset = RuleBuilder::Model::ConditionSet->new(
	result => 'Blaat'
);

$conditionset->add_condition(
	RuleBuilder::Model::Condition->new(
		path => 'department',
		operator => 'Equals',
		check => 'IT'
	)
);
$conditionset->add_condition(
	RuleBuilder::Model::Condition->new(
		path => 'location',
		operator => 'Equals',
		check => 'Hoorn'
	)
);

is(
    $conditionset->test({
        department => 'IT',
        location   => 'Hoorn',
    }),
    'Blaat',
    'ConditionSet returns result on match'
);


my $result = $conditionset->test({
    department => 'IT',
    location   => 'Grootebroek',
});

ok(
    !defined $result,
    'ConditionSet returns undef on non-match'
);


is(
    $conditionset->test({
        department => 'IT',
        location   => 'Hoorn',
    }),
    'Blaat',
    'ConditionSet returns result on match'
);

is(
    $conditionset->test({
        department => 'IT',
        location   => 'Grootebroek',
    }),
    undef,
    'ConditionSet returns undef on non-match'
);

done_testing;
