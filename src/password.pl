#!/usr/bin/perl

=head

This script generates a random password for you.

=cut

my @alphanumeric = ('a'..'z', 'A'..'Z', 0..9);
my $randpassword = join '', map $alphanumeric[rand @alphanumeric], 0..8;
print "$randpassword\n"
