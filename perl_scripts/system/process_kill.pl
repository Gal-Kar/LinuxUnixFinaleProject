#!/usr/bin/perl

my $pid = $ARGV[0];
chomp $pid;

if ($pid =~ /^\d+$/) {
    # PID is a number
    if (kill('TERM', $pid)) {
        print "Process $pid killed\n";
    } else {
        print "Failed to kill process $pid: $!\n";
    }
} else {
    print "Invalid process ID\n";
}