#!/usr/bin/perl -w

=head

this script creates a slug in the database.
give it a table, a field and a field to put the slug in and it will do the rest.

=cut

# uses

use strict;
use diagnostics;
use DBI;
use Error qw(:try);
use File::Find qw();
use File::Basename qw();
use Perl6::Slurp qw();
use MyUtils;

# parameters
my($param_table)='TbBsCompanies';
my($param_field_from)='name';
my($param_field_to)='slug';

# functions

sub to_slug($) {
	my($val)=$_[0];
	return join('-',map(lc,split(' ',$val)));
}

# code

my($dbh)=MyUtils::db_connect();
my($sql)='SELECT $param_field_from FROM $param_table';
my($sth)=$dbh->prepare($sql);
$sth->execute();
my($rowhashref);
while($rowhashref=$sth->fetchrow_hashref()) {
	my($field_val)=$rowhashref->{$param_field_from};
	my($new_slug)=to_slug($field_val);
	$dbh->do('UPDATE $param_table SET $param_field_to=? WHERE $param_field_from=?',
		undef,$new_slug,$field_val);
}
# now commit all the changes
$dbh->commit();
# disconnect from the database
$dbh->disconnect();
