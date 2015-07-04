package DB_File::Utils::Command::get;

use v5.20;
use DB_File::Utils -command;
use strict;
use warnings;

use DB_File;
use Fcntl;

sub abstract { "Dumps value for a specific key" }

sub description { "Given a DB_File with strings as keys, prints\nto standard output the value associated\nwith a specific key. Dies if key is not found." }

sub usage_desc { $_[0]->SUPER::usage_desc . ' <dbfile> <key>' }

sub opt_spec {
	return ();
}

sub validate_args {
	my ($self, $opt, $args) = @_;

	$self->usage_error("Two arguments are mandatory") unless scalar(@$args)==2;

	$self->usage_error("$args->[0] not found") unless -f $args->[0];

}

sub execute {
	my ($self, $opt, $args) = @_;

	my $file = $args->[0];
	my $key  = $args->[1];

	_retrieve($file, $key);
}

sub _retrieve {
	my ($file, $key) = @_;
	my %hash;
	tie %hash,  'DB_File', $file, O_RDWR, '0666', $DB_BTREE;
	if (exists($hash{$key})) {
		say $hash{$key};
	} else {
		die "Key $key not found!"
	}
	untie %hash;
}

1;