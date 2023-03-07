#!/usr/bin/perl


use Proc::Killfam;

my $pid_to_kill = $ARGV[0];
my $signal = 'TERM';

# Kill the process with the specified PID and all its descendants
killfam $signal, $pid_to_kill;

# Check if the process was successfully killed
if (kill 0, $pid_to_kill) {
    print "Process $pid_to_kill still running\n";
} else {
    print "Process $pid_to_kill terminated\n";
}
