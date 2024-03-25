package MyUtils;

# uses

use Date::Manip;
use Config::IniFiles;
use DBI;
use File::HomeDir;

# functions

sub to_mysql($) {
	my($string)=@_;
	my($object)=Date::Manip::UnixDate($string,'%Y-%m-%d %T');
	if(!defined($object)) {
		die('bad convert for ['.$string.']');
	}
	return($object);
}

sub show_menu {
	my($stop)=0;
	my($result);
	while(!$stop) {
		for(my($i)=0;$i<@_;$i++) {
			my($entry)=$_[$i];
			print $entry."\n";
		}
		my($response);
		$response=<STDIN>;
		# handle EOF
		if(!defined($response)) {
			die('eof reached');
		}
		chomp($response);
		if(length($response)!=1) {
			next;
		}
		for(my($i)=0;$i<@_;$i++) {
			my($entry)=$_[$i];
			if($response eq substr($entry,0,1)) {
				$result=$response;
				$stop=1;
				next;
			}
		}
		if(!$stop) {
			print 'bad response'."\n";
		}
	}
	return $result;
}

sub show_yes_no_dialog($) {
	my($question)=$_[0];
	my($stop)=0;
	my($result);
	while(!$stop) {
		print STDOUT $question;
		flush STDOUT;
		my($response);
		$response=<STDIN>;
		chomp($response);
		if($response ne 'y' and $response ne 'n') {
			next;
		}
		$stop=1;
		if($response eq 'y') {
			$result=1;
		} else {
			$result=0;
		}
	}
	return $result;
}

sub get_from_user($) {
	my($message)=$_[0];
	print STDOUT $message;
	flush STDOUT;
	my($res);
	$res=<STDIN>;
	chomp($res);
	return $res;
}

sub delete_work($$) {
	my($dbh)=$_[0];
	my($f_id)=$_[1];
	$dbh->do('DELETE FROM TbWkWorkAuthorization WHERE workId=?',undef,$f_id);
	$dbh->do('DELETE FROM TbWkWorkChapter WHERE workId=?',undef,$f_id);
	$dbh->do('DELETE FROM TbWkWorkContrib WHERE workId=?',undef,$f_id);
	$dbh->do('DELETE FROM TbWkWorkExternal WHERE workId=?',undef,$f_id);
	$dbh->do('DELETE FROM TbWkWorkViewPerson WHERE viewId IN (SELECT id FROM TbWkWorkView WHERE workId=?)',undef,$f_id);
	$dbh->do('DELETE FROM TbWkWorkView WHERE workId=?',undef,$f_id);
	$dbh->do('DELETE FROM TbWkWorkReview WHERE workId=?',undef,$f_id);
	$dbh->do('DELETE FROM TbWkWorkAlias WHERE workId=?',undef,$f_id);
	$dbh->do('DELETE FROM TbWkWork WHERE id=?',undef,$f_id);
}

sub handle_error() {
	my($rc)=$dbh->err;
	my($str)=$dbh->errstr;
	my($rv)=$dbh->state;
	throw Error::Simple($str.','.$rv.','.$rv);
}

sub db_connect() {
	my($rcfile)=File::HomeDir->my_home.'/.perlmyworld.ini';
	my($cfg);
	$cfg=Config::IniFiles->new( -file => $rcfile ) || die('unable to access ini file '.$rcfile);
	my($param_user)=$cfg->val('myworld', 'username');
	my($param_pass)=$cfg->val('myworld', 'password');
	my($param_host)=$cfg->val('myworld', 'hostname');
	my($param_port)=$cfg->val('myworld', 'port');
	my($param_name)=$cfg->val('myworld', 'name');

	my($dsn)='dbi:mysql:'.$param_name;
	if(defined($param_host)) {
		$dsn.=';host='.$param_host;
	}
	if(defined($param_port)) {
		$dsn.=';=port'.$param_port;
	}
	my($dbh)=DBI->connect($dsn, $param_user, $param_pass, {
		RaiseError => 1,
		AutoCommit => 0,
		PrintWarn => 1,
		PrintError => 1,
		mysql_enable_utf8 => 1,
	}) or die 'Connection Error: '.$DBI::errstr;
	#$dbh->{HandleError} =\&handle_error;
	return $dbh;
}

return 1;
