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
use RuleBuilder::Model::ConditionSet;
use RuleBuilder::Model::RuleSet;

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

say Dumper $ruleset->to_hash;

my $data = {
	'department' => 'IT',
	'location' => 'Hoorn'
};
my $result = $ruleset->test($data);
say "Testing";
say Dumper $data;
say "Verwacht een array met IT Hoorn en IT";
say "Result:";
say Dumper $result;

$data = {
	'department' => 'IT',
	'location' => 'Grootebroek'
};
$result = $ruleset->test($data);
say "Testing";
say Dumper $data;
say "Verwacht een array met IT Grootebroek en IT";
say "Result:";
say Dumper $result;

$data = {
	'department' => 'Finance',
	'location' => 'Grootebroek'
};
$result = $ruleset->test($data);
say "Testing";
say Dumper $data;
say "Verwacht een lege array";
say "Result:";
say Dumper $result;


$data = {
	'department' => 'P&O',
};
$result = $ruleset->test($data);
say "Testing";
say Dumper $data;
say "Verwacht een array met PZ";
say "Result:";
say Dumper $result;
