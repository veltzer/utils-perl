#!/usr/bin/perl

=head1 DESCRIPTION

This script generates a random password for you.

=cut

use strict;
use warnings;

my @alphanumeric = ('a'..'z', 'A'..'Z', 0..9);
my $randpassword = join '', map $alphanumeric[rand @alphanumeric], 0..8;
print "$randpassword\n"
