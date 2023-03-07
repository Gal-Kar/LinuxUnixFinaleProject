#!/usr/bin/perl

my $dir = "/path/to/new/directory";

unless (-d $dir) { # check if directory already exists
    if(mkdir $dir) {
        print "Directory created successfully.\n";
    }
    else {
        print "Error: Directory creation failed.\n";
    }
}
else {
    print "Error: Directory already exists.\n";
}