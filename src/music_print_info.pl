#!/usr/bin/perl -w

use strict;
use diagnostics;
use MP3::Tag;

# This script prints id3v2 info for a file...

for(my($i)=0;$i<@ARGV;$i++) {
	my($filename)=$ARGV[$i];
	print "info for file [$filename]...\n";
	# check that you can get all the mp3 info from the file...
	my($mp3)=MP3::Tag->new($filename);
	$mp3->get_tags();
	if(!exists($mp3->{"ID3v2"})) {
		die("do not have tag info on the file");
	}
	my($id3v2)=$mp3->{"ID3v2"};
	my($frameIDs_hash)=$id3v2->get_frame_ids('truename');
	my($frame);
	foreach $frame (keys %$frameIDs_hash) {
		print "$frame\n";
		my ($name, @info) = $id3v2->get_frames($frame);
		my($info);
		for $info (@info) {
			if (ref $info) {
				print "$name ($frame):\n";
				while(my ($key,$val)=each %$info) {
					print " * $key => $val\n";
				}
			} else {
				print "$name: $info\n";
			}
		}
	}
}
