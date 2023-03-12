#!/usr/bin/perl

print "Enter the process ID to kill: ";
my $pid = <STDIN>;
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