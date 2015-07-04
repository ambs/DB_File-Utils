package DB_File::Utils::Command::keys;

use v5.20;
use DB_File::Utils -command;
use strict;
use warnings;

use DB_File;
use Fcntl;

sub abstract { "Lists DB_File keys, one per line." }

sub description { "Given a DB_File with strings as keys, prints all keys, one per line." }

sub usage_desc { $_[0]->SUPER::usage_desc . ' <dbfile> <...>' }

sub opt_spec {
	return ();
}

sub validate_args {
	my ($self, $opt, $args) = @_;

	foreach my $file (@$args) {
		$self->usage_error("$file not found") unless -f $file;
	}
}

sub execute {
	my ($self, $opt, $args) = @_;

	foreach my $file (@$args) {
		_dump($file);
	}
}

sub _dump {
	my $filename = shift;
	my %hash;
	tie %hash,  'DB_File', $filename, O_RDWR, '0666', $DB_BTREE;
	say while (($_) = each %hash);
	untie %hash;
}

1;