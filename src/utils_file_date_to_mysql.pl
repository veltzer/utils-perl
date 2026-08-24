#!/usr/bin/perl -w

=head1 DESCRIPTION

this script converts file dates to mysql date format.

=cut

use strict;
use diagnostics;
use Date::Manip qw();

sub unixdate_to_mysql {
	my($string)=@_;
	my($object)=Date::Manip::UnixDate($string,'%Y-%m-%d %T');
	return($object);
}

my($num_lines)=7;
my($delim)="\t";
my($fname)="file.xml";

open(my $fh,'<',$fname) || die("unable to open file $fname");

my(@arr);
my($line);
while($line=<$fh>) {
	$arr[0]=$line;
	chomp($arr[0]);
	for(my($i)=1;$i<$num_lines;$i++) {
		$arr[$i]=<$fh>;
		chomp($arr[$i]);
		#if($i==3) {
		#	$arr[$i]=unixdate_to_mysql($arr[$i]);
		#}
	}
	print join($delim,@arr)."\n";
}
close($fh) || die("unable to close file $fname");
