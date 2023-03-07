#!/usr/bin/perl

my $filename = "$ARGV[0]";

unless (open FILE, "<", $filename) { # check if file can be opened
    die "Cannot open file: $!";
}

while (<FILE>) {
    print $_; # print each line to console
}

close FILE;