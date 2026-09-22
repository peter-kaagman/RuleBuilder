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

my $data = {
	'department' => 'IT'
};

my $condition = RuleBuilder::Model::Condition->new(
	path => 'department',
	operator => 'NotEquals',
	check => 'IT',
	blaat => "zomaar wat"
);

say "Condition is:";
say Dumper $condition->to_hash();

say "Testen met data:";
say Dumper $data;
say "Verwacht 0";
my $result = $condition->test($data);
say $result;

$data = {
	'department' => 'Iets anders'
};


say "Testen met data:";
say Dumper $data;
say "Verwacht 1";
$result = $condition->test($data);
say $result;

$condition = RuleBuilder::Model::Condition->new(
	path => 'role',
	operator => 'NotEquals',
	check => 'IT',
	blaat => "zomaar wat",

);
say "MissingOk is true (default):";
say Dumper $data;
say "Verwacht 1";
$result = $condition->test($data);
say $result;

$condition = RuleBuilder::Model::Condition->new(
	path => 'role',
	operator => 'NotEquals',
	check => 'IT',
	missingok => 0,
	blaat => "zomaar wat",

);
say "MissingOk is false:";
say Dumper $data;
say "Verwacht 0";
$result = $condition->test($data);
say $result;





