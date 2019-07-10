#!/usr/bin/perl -w

# This script touches a file with the latest time of any of the files
# that he finds...

# libraries
use strict;
use diagnostics;
use File::Find qw(); # for recursivly descending into folders

# parameters
my($debug)=0;
my($max)=0;
my($max_filename)=undef;

# functions
sub handler() {
	my($filename)=$File::Find::name;
	my($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
		$atime,$mtime,$ctime,$blksize,$blocks)
		=stat($filename);
	if($mtime>$max) {
		$max=$mtime;
		$max_filename=$filename;
	}
}


# code
my($length)=scalar(@ARGV);
if($debug) {
	print STDERR "ARGV is ".join('-',@ARGV)."\n";
	print STDERR "length is $length\n";
}

my($compare)=$ARGV[0];
my(@folders)=@ARGV[1,$length-1];

if($debug) {
	print STDERR "compare is $compare\n";
	print STDERR "folders is ".join(',',@folders)."\n";
}

for(my($i)=0;$i<@folders;$i++) {
	my($curr)=$folders[$i];
	File::Find::find({"no_chdir"=>1,"wanted"=>\&handler},$curr);
}
if(-f $compare) {
	my($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks)=
		stat($compare);
	if($mtime<$max) {
		utime($atime,$max,$compare);
	}
} else {
	# create the file with the $max attribute
	open(FILE,"> ".$compare) || die("unable to open file $compare");
	close(FILE) || die("unable to close file $compare");
	utime($max,$max,$compare);
}
if($debug) {
	print STDERR "max is $max\n";
	print STDERR "max_filename is $max_filename\n";
}
