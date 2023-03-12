#!/usr/bin/perl


my $filename = $ARGV[1];
my $mode = $ARGV[0]; # desired file permissions in octal notation

unless (-e $filename) { # check if file exists
    print "File does not exist: $filename";
    return;
}

unless (chmod oct($mode), $filename) { # change file permissions
    print "Cannot change file permissions: $!";
    return;
}
