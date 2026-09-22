package RuleBuilder::Repository::LocalFilesystem;

use Moo;

has path => (
	is 		=> 'rw',
	required	=> 1,
)


sub list{}
sub load{}
sub save{}
sub delete{}


42;
