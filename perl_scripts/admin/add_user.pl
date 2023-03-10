#!/usr/bin/perl

use strict;
use warnings;

my $filename = "/etc/passwd";

open(my $fh, '<', $filename) or die "Cannot open file $filename: $!";

my $last_line;
while (my $line = <$fh>) {
    $last_line = $line if eof;
}

close($fh);

print "Last line of file: $last_line";



# open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
# print $fh "$line\n";
# close $fh;


# add /etc/group , /etc/