#!/usr/bin/perl -w

=head

A script that prints the names of the columns in a table

=cut

# uses

use strict;
use diagnostics;
use DBI;
use Data::Dumper;
use Getopt::Long;
use Config::IniFiles;
use MyUtils;

# parameters

my($debug)=1;

# code

sub get_fields($$) {
	my($dbh, $table)=@_;
	if($debug) {
		print 'table is '.$table."\n";
	}
	my($sql)='SELECT column_name FROM information_schema.columns WHERE table_name=? AND table_schema=DATABASE()';
	my($sth)=$dbh->prepare($sql);
	$sth->execute($table) or die 'SQL Error: '.$DBI::errstr;
	my($rowhashref);
	my(%hash);
	while($rowhashref=$sth->fetchrow_hashref()) {
		my($column_name)=$rowhashref->{'column_name'};
		$hash{$column_name}=defined;
	}
	if($debug) {
		print(Dumper(\%hash));
	}
	return \%hash;
}

my($param_table)=undef;
GetOptions(
	'rcfile=s' => \$param_rcfile,
	'table=s' => \$param_table,
) or die 'error in command line parsing';

if (!defined($param_table)) {
	die 'must set table using --table';
}

my($dbh)=MyUtils::db_connect();
my($hash)=get_fields($dbh, $param_table);
$dbh->disconnect();
