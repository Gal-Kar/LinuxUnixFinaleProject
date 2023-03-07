#!/usr/bin/perl

my $source_file = "/path/to/source_file.txt";
my $destination_file = "/path/to/destination_file.txt";

unless (open SOURCE, "<", $source_file) { # open source file for reading
    die "Cannot open source file: $!";
}

unless (open DESTINATION, ">", $destination_file) { # open destination file for writing
    die "Cannot create destination file: $!";
}

# copy the contents of the source file to the destination file
while (my $buffer = <SOURCE>) {
    print DESTINATION $buffer;
}

close SOURCE;
close DESTINATION;
