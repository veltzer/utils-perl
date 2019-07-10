#!/usr/bin/perl -w

=head

this script reorders a table and fixes references to it

TODO:
- auto deduce the field list
- auto deduce which other tables need to be changed
- do not require the $reorder_sql var

=cut

# uses

use strict;
use diagnostics;
use DBI;
use MyUtils;

# parameters

my($reorder_sql)='SELECT * FROM TbWkWorkType ORDER BY name';
my($reorder_clause)='ORDER BY name';
my($db_table_name)='TbWkWorkType';
my($id_field)='id';
my($field_list)='name,remark,isVideo,isAudio,isLive,isText';
my($start)=1;
my($debug)=1;
my(@tablecheck)=('TbWkWork');
my(@fieldcheck)=('typeId');

# code

my($db_table_temp)=$db_table_name.'_temp';
my($dbh)=MyUtils::db_connect();
my($sth)=$dbh->prepare($reorder_sql);
$sth->execute() or die 'SQL Error: '.$DBI::errstr;
my($rowhashref);
my($counter)=$start;
my(%hash);
while($rowhashref=$sth->fetchrow_hashref()) {
	my($row_id)=$rowhashref->{$id_field};
	$hash{$row_id}=$counter;
	if($debug) {
		print 'setting '.$row_id.' to '.$counter."\n";
	}
	$counter++;
}
my($max)=$counter;
$dbh->do('SET FOREIGN_KEY_CHECKS = 0');
$dbh->do('RENAME TABLE '.$db_table_name.' TO '.$db_table_temp);
$dbh->do('CREATE TABLE '.$db_table_name.' LIKE '.$db_table_temp);
$dbh->do('INSERT INTO '.$db_table_name.' ('.$field_list.') select '.$field_list.' from '.$db_table_temp.' '.$reorder_clause);
$dbh->do('DROP TABLE '.$db_table_temp);

# TODO: do this for EVERY fk found...
my($table_fkfix)='TbWkWork';
my($field_fkfix)='typeId';
$dbh->do('UPDATE '.$table_fkfix.' SET '.$field_fkfix.'='.$field_fkfix.'+'.$max,undef);
for(my($i)=$start;$i<$counter;$i++) {
	my($newval)=$hash{$i};
	$dbh->do('UPDATE '.$table_fkfix.' SET '.$field_fkfix.'=? WHERE '.$field_fkfix.'=?',undef,
		$newval,
		$i+$max,
	);
}
$dbh->do('SET FOREIGN_KEY_CHECKS = 1');

$dbh->commit();
$dbh->disconnect();
