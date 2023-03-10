#!/usr/bin/perl


my $filename = $ARGV[1];
my $mode = $ARGV[0]; # desired file permissions in octal notation

unless (-e $filename) { # check if file exists
    die "File does not exist: $filename";
}

unless (chmod oct($mode), $filename) { # change file permissions
    die "Cannot change file permissions: $!";
}
