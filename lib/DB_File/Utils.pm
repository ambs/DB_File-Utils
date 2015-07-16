# ABSTRACT: Creates db_util command line for DB_File management
package DB_File::Utils;

use DB_File;
use Fcntl;

use App::Cmd::Setup -app;

sub global_opt_spec {
  return (
     ['u|utf8' => "Force UTF8 encoding/decoding on values."],
     ['btree' => "Use BTree indexing method (default)"],
     ['hash'  => "Use Hash indexing method"],
     ['recno' => "Use RecNo indexing method"],
  );
}

sub do_tie {
	my ($self, $file, $ops) = @_;

	my %hash;
	my $method = $ops->{recno} ? $DB_RECNO : ($ops->{hash} ? $DB_HASH : $DB_BTREE);
	tie %hash, 'DB_File', $file, O_RDWR, '0666', $method;

	return \%hash;
}


1;

=encoding UTF-8

=head1 NAME

DB_File::Utils - main module for db_util command line tool

=head1 DESCRIPTION

Please refer to C<perldoc db_util> for detail on module usage.

=head1 SEE ALSO

db_util (3)

=head1 AUTHOR

Alberto Simões C<< <ambs@cpan.org> >>
