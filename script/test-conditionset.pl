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

my $set = RuleBuilder::Model::ConditionSet->new(
	result => 'Blaat'
);

$set->add_condition(
	RuleBuilder::Model::Condition->new(
		path => 'department',
		operator => 'Equals',
		check => 'IT'
	)
);

$set->add_condition(
	RuleBuilder::Model::Condition->new(
		path => 'location',
		operator => 'Equals',
		check => 'Hoorn'
	)
);

say Dumper $set->to_hash;


my $data = {
	'department' => 'IT',
	'location' => 'Hoorn'
};
my $result = $set->test($data);
say "Testen met data:";
say Dumper $data;
say "Verwacht blaat";
say $result;

$data = {
	'department' => 'IT',
	'location' => 'Grootebroek'
};
$result = $set->test($data);
say "Testen met data:";
say Dumper $data;
say "ConditionSet:";
say Dumper $set->to_hash();
say "Verwacht undef";
say "undef" unless defined $result;

