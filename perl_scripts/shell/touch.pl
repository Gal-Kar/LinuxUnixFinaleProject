#!/usr/bin/perl

my $filename = $ARGV[0];

if (-e $filename) { # check if file exists
    # update the timestamp of an existing file
    unless (open FILE, ">", $filename) { # open file for writing
        print "Cannot open file: $!";
        return;
    }
    close FILE;
} else {
    # create a new empty file
    unless (open FILE, ">", $filename) { # open file for writing
        print "Cannot create file: $!";
        return;
    }
    close FILE;
}