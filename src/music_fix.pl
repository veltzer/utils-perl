#!/usr/bin/perl -w

use strict;
use diagnostics;
use MP3::Info qw();
use MP3::Tag;

# this script fixes id3 tag info in files...

my($print)=1;
my($debug)=1;
my($fix)=0;

for(my($i)=0;$i<@ARGV;$i++) {
	my($filename)=$ARGV[$i];
	if($print) {
		print "analyzing [$filename]...\n";
	}
	# check that you can get all the mp3 info from the file...
	my($res)=MP3::Info::get_mp3info($filename);
	my($mp3)=MP3::Tag->new($filename);
	$mp3->get_tags();
	if(!exists($mp3->{"ID3v2"})) {
		die("ID3v2 tags do not exist");
	}
	my($tg)=$mp3->{ID3v2};
	my($nm1,$artist)=$tg->get_frames("TPE1");
	my($nm2,$year)=$tg->get_frames("TDRC");
	my($nm3,$album)=$tg->get_frames("TALB");
	my($nm4,$genre)=$tg->get_frames("TCON");
	my($a_title,$a_track,$a_artist,$a_album,$a_comment,$a_year,$a_genre)=
		$mp3->autoinfo();
	if($debug) {
		print "====\n";
		while(my($key,$value)=each(%$res)) {
			print "$key -> $value\n";
		}
		print "====\n";
		while(my($key,$value)=each(%$tg)) {
			print "$key -> $value\n";
		}
		my(@tags)=$mp3->get_tags();
		print join("-",@tags)."\n";
		print "a_title is $a_title\n";
		print "a_track is $a_track\n";
		print "a_artist is $a_artist\n";
		print "a_album is $a_album\n";
		print "a_comment is $a_comment\n";
		print "a_year is $a_year\n";
		print "a_genre is $a_genre\n";
		#print "title is $title\n";
		#print "track is $track\n";
		print "artist is $artist\n";
		print "album is $album\n";
		#print "comment is $comment\n";
		print "year is $year\n";
		print "genre is $genre\n";
	}
	# now actually fix the file...
	if($fix) {
		$mp3->title_set($a_title);
		$mp3->artist_set($a_artist);
		$mp3->album_set($a_album);
		$mp3->year_set($a_year);
		$mp3->comment_set($a_comment);
		$mp3->track_set($a_track);
		$mp3->genre_set($a_genre);
		$mp3->update_tags();
	}
}
