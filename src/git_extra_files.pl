#!/usr/bin/perl -w

=head1 DESCRIPTION

this script lists all extra files not known to git.

How does it do it?

=over

=item * list all files in the folder recursivly (File::Find), disregarding the .git subfolder.

=item * list all files which git knows about (git ls-files).

=item * subtract the second from the first.

=back

=cut

# this script lists all extra files not known to git
# how does it do it?
# - list all files in the folder recursivly (File::Find).
# 	disregard the .git subfolder.
# - list all files which git knows about (git ls-files).
# - subtract the second from the first.

use strict;
use diagnostics;
use File::Find qw();

# do you want to debug the script ?!?
my($debug)=0;
my(%hash)=();

sub handler {
	my($file)=$File::Find::name;
	if(!(-f $file)) {
		return;
	}
	if($file=~/^\.\/\.git\//) {
		return;
	}
	if($debug) {
		print 'saw file ['.$file.']'."\n";
	}
	$hash{$file}=defined;
}

# find all files in the folder...
File::Find::find({"no_chdir"=>1,"wanted"=>\&handler},".");

open(my $fh,"-|","git","ls-files") || die("unable to run git");
my($line);
while($line=<$fh>) {
	chop($line);
	if($debug) {
		print 'saw line ['.$line.']'."\n";
	}
	delete($hash{'./'.$line});
}
close($fh) || die("unable to close git");

while(my($file,$val)=each %hash) {
	print 'extra file ['.$file.']'."\n";
}
