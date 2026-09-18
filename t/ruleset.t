#!/usr/bin/env perl

use v5.36;
use Test::More;

use FindBin;
use lib "$FindBin::Bin/../lib";

use RuleBuilder::Model::RuleSet;
use RuleBuilder::Model::ConditionSet;
use RuleBuilder::Model::Condition;

my $ruleset = RuleBuilder::Model::RuleSet->new();

$ruleset->add_conditionset(
	RuleBuilder::Model::ConditionSet->new(
		result => 'IT Hoorn',
		conditions => [
			RuleBuilder::Model::Condition->new(
				path => 'department',
				operator => 'Equals',
				check => 'IT'
			),
			RuleBuilder::Model::Condition->new(
				path => 'location',
				operator => 'Equals',
				check => 'Hoorn'
			)
		]
	)
);

$ruleset->add_conditionset(
	RuleBuilder::Model::ConditionSet->new(
		result => 'IT Grootebroek',
		conditions => [
			RuleBuilder::Model::Condition->new(
				path => 'department',
				operator => 'Equals',
				check => 'IT'
			),
			RuleBuilder::Model::Condition->new(
				path => 'location',
				operator => 'Equals',
				check => 'Grootebroek'
			)
		]
	)
);

$ruleset->add_conditionset(
	RuleBuilder::Model::ConditionSet->new(
		result => 'IT',
		conditions => [
			RuleBuilder::Model::Condition->new(
				path => 'department',
				operator => 'Equals',
				check => 'IT'
			)
		]
	)
);

$ruleset->add_conditionset(
	RuleBuilder::Model::ConditionSet->new(
		result => 'PZ',
		conditions => [
			RuleBuilder::Model::Condition->new(
				path => 'department',
				operator => 'Equals',
				check => 'P&O'
			)
		]
	)
);


my $result = $ruleset->test({
    department => 'IT',
    location   => 'Hoorn',
});

is_deeply(
    $result,
    [ 'IT Hoorn', 'IT' ],
    'RuleSet returns multiple matches'
);

$result = $ruleset->test({
    department => 'P&O',
});

is(
    ref($result),
    'ARRAY',
    'RuleSet always returns ARRAY ref'
);

is_deeply(
    $result,
    ['PZ'],
    'RuleSet returns single match as arrayref'
);

$result = $ruleset->test({
    department => 'GeenMatch',
});

is(
    ref($result),
    'ARRAY',
    'RuleSet returns ARRAY ref on no match'
);

is_deeply(
    $result,
    [],
    'RuleSet returns empty array on no match'
);

done_testing;
