#!/usr/bin/perl -w

use strict;
use warnings;
use MyVideo qw();
use Video::Info qw();

# example
my $filename = $ARGV[0];
my %videoInfo = MyVideo::info($filename);
print "duration: " . $videoInfo{'duration'} . "\n";
print "durationsecs: " . $videoInfo{'durationsecs'} . "\n";
print "bitrate: " . $videoInfo{'bitrate'} . "\n";
print "vcodec: " . $videoInfo{'vcodec'} . "\n";
print "vformat: " . $videoInfo{'vformat'} . "\n";
print "acodec: " . $videoInfo{'acodec'} . "\n";
print "asamplerate: " . $videoInfo{'asamplerate'} . "\n";
print "achannels: " . $videoInfo{'achannels'} . "\n";
print "size: " . $videoInfo{'size'} . "\n";

# now with Video::Info
my($info)=Video::Info->new(-file=>$filename);
my($curr_secs)=$info->duration();
my($curr_size)=$info->filesize();
print 'curr secs is ['.$curr_secs.']'."\n";
print 'curr size is ['.$curr_size.']'."\n";
