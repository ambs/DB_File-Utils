
use warnings;
use strict;

use Test::More tests => 2 * 2;

use App::Cmd::Tester;

use DB_File::Utils;
use File::Temp qw/ tempfile /;

for my $type (qw.btree hash.) {

	my ($x, $filename) = tempfile(SUFFIX => '.db');
	close $x;

	my $result = test_app('DB_File::Utils' => [ "--$type",  new => $filename ]);

	print STDERR "ERROR>", $result->error, "\n\n" if $result->error;


	ok(-f "$filename", "new file [$type]");

	my ($fh, $name) = tempfile(SUFFIX => '.key');
	print $fh "value";
	close $fh;

	{
		open STDIN, "<", $name;

		$result = test_app('DB_File::Utils' => [ "--$type", put => $filename, 'key']);
		print STDERR "ERROR>", $result->error, "\n\n" if $result->error;
	}

	$result = test_app('DB_File::Utils' => [ "--$type", get => $filename, 'key']);

	print STDERR "ERROR>", $result->error, "\n\n" if $result->error;

	is ($result->stdout, "value\n", "value correctly obtained [$type]");

}
