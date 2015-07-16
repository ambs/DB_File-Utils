package DB_File::Utils::Command::put;

use v5.20;
use DB_File::Utils -command;
use strict;
use warnings;

use DB_File;
use Fcntl;

sub abstract { "Sets the value for a specific key" }

sub description { "Given a DB_File with strings as keys, sets or ressets the value for a specific key." }

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

	$opt = { %{$self->app->global_options}, %$opt};

	my $file = $args->[0];
	my $key  = $args->[1];

	my $contents;
	{
		local $/ = undef;
		binmode STDIN, ':utf8' if $opt->{utf8};
		$contents = <STDIN>;
	}

	_store($self, $file, $key, $contents, $opt);
}

sub _store {
	my ($self, $filename, $key, $value, $opt) = @_;
	my $hash = $self->app->do_tie( $filename, $opt);

	$hash->{$key} = $opt->{utf8} ? encode('utf-8', $value) : $value;
	untie $hash;
}

1;