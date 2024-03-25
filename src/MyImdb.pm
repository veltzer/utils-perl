package MyImdb;

use strict;
use XML::Simple qw();
use LWP::Simple qw();
use Data::Dumper qw();
use URI qw();
use YAML::Dumper qw();

sub escapeSingleQuote {
	my $str = shift;
	$str =~ s/\'/\\'/g;
	return $str;
}

sub get_movie_by_imdbid($) {
	my($imdbid)=$_[0];
	my($url)=URI->new('http://www.imdbapi.com');
	$url->query_form(
		#'r'=>'JSON', # or 'XML'
		'r'=>'XML',
		'i'=>$imdbid,
	);
	my($movieData)=LWP::Simple::get($url);
	return $movieData;
}

sub get_movie_by_title($) {
	my($title)=$_[0];
	#my($sr_title)=$title;
	#$sr_title =~ s/\s/+/g;
	#my $cmd = "curl http://www.imdbapi.com/?r=XML\\&t=\"$sr_title\" 2>\\&1";
	#my $movieData = `$cmd`;
	my($url)=URI->new('http://www.imdbapi.com');
	$url->query_form(
		'r'=>'XML',
		't'=>$title,
	);
	my($movieData)=LWP::Simple::get($url);
	#print "movieData is $movieData\n";
	my $xml=new XML::Simple;
	my $data=$xml->XMLin($movieData);
	if($data->{response} eq "True") {
		#my $f_director=$data->{movie}->{director};
		my $f_title=$data->{movie}->{title};
		#my $f_released = escapeSingleQuote($data->{movie}->{released});
		#my $f_genre = escapeSingleQuote($data->{movie}->{genre});
		#my $f_writer = escapeSingleQuote($data->{movie}->{writer});
		#my $f_runtime = escapeSingleQuote($data->{movie}->{runtime});
		#my $f_plot = escapeSingleQuote($data->{movie}->{plot});
		#my $f_imdb = escapeSingleQuote($data->{movie}->{imdbID});
		#my $f_votes = escapeSingleQuote($data->{movie}->{imdbVotes});
		#my $f_poster = escapeSingleQuote($data->{movie}->{poster});
		#my $f_year = escapeSingleQuote($data->{movie}->{year});
		#my $f_rated = escapeSingleQuote($data->{movie}->{imdbRating});
		#my $f_actors = escapeSingleQuote($data->{movie}->{actors});

		#print "INSERT INTO movie_collection VALUES (NULL , '$title', '$year', ";
		#print "'$rated', '$released', '$genre', '$director', '$writer', '$actors', '$plot', ";
		#print "'$poster', '$runtime', '$rating', '$votes', '$imdb', '$tstamp');\n";
		if($f_title eq $title) {
			return $data->{movie};
		} else {
			return undef;
		}
	} else {
		return undef;
	}
}

return 1;
