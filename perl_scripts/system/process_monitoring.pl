#!/usr/bin/perl

use Proc::ProcessTable;

# Create a new process table object
my $process_table = Proc::ProcessTable->new();

# Loop through all the processes and print their details
foreach my $process (@{$process_table->table}) {
    printf "PID: %d, Name: %s, User: %s, Memory: %d KB\n",
        $process->pid, $process->cmndline, $process->user, $process->size;
}
