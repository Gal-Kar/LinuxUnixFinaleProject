#!/usr/bin/perl

my $source_file = "$ARGV[0]";
my $destination_file = "$ARGV[1]";

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
