#!/usr/bin/perl -w

# uses

use strict;
use diagnostics;
use Net::GitHub; # for new
use Config::IniFiles; # for new
use File::HomeDir; # for my_home

# code

my $details=File::HomeDir->my_home.'/.github.ini';
my $cfg=Config::IniFiles->new( -file=> $details); # or die('unable to access ini file');
my $param_login=$cfg->val('github', 'username') or die("unable to find username");
my $param_pass=$cfg->val('github', 'password') or die("unable to find password");
my $personal_token=$cfg->val('github', 'personal_token') or die("unable to find personal_token");

my $gh = Net::GitHub->new(
	access_token => $personal_token
);
$gh->set_default_user_repo('veltzer', 'perl-net-github');
my $repositories=$gh->repos->list;
for(my($i)=0;$i<$#$repositories;$i++) {
	my($curr)=$repositories->[$i];
	my($name)=$curr->{name};
	print($name."\n");
}
