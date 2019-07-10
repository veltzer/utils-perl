#!/usr/bin/perl -w

=head

dump data for a particual id of a feature on imdb

=cut

use strict;
use diagnostics;
use XML::Simple qw();
use LWP::Simple qw();
use Data::Dumper qw();
use URI qw();
use YAML::Dumper qw();
use MyImdb qw();
use IMDB::Film qw();

if(!@ARGV) {
	die 'please provide imdbid'."\n";
}
my($imdbid)=shift;
print 'fetching from imdbapi...'."\n";
my($data)=MyImdb::get_movie_by_imdbid($imdbid);
if(defined($data)) {
	print 'data is ['.$data.']'."\n";
} else {
	print 'imdbid ['.$imdbid.'] not found'."\n";
}
print 'fetching from IMDB...'."\n";
my($imdbObj)=new IMDB::Film(crit => $imdbid);
if($imdbObj->status) {
	my($title)=$imdbObj->title();
	print(Data::Dumper::Dumper($imdbObj));
}
