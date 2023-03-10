#!/usr/bin/perl
use strict;
use warnings;
use File::Path qw(rmtree);
use User::pwent;
use File::Basename;
use POSIX;
use File::Copy;
 
# requires
require './commands/shell.pl';
require './commands/admin.pl';
require './commands/system.pl';
 
# kill_process(@ARGV);
# restore(@ARGV);
# backup(@ARGV);
# add_user(shift, shift);
# remove_user(shift);
# change_permission(@ARGV);
# ls(@ARGV);
# cp(@ARGV);
# mv(@ARGV);
# ln(@ARGV);
# process_monitoring();
 
# my $command = shift @ARGV;
# if ($command eq 'ls') {
#     ls(@ARGV);
# } elsif ($command eq 'cp') {
#     cp(@ARGV);
# } elsif ($command eq 'mv') {
#     mv(@ARGV);
# } elsif ($command eq 'ln') {
#     ln(@ARGV);
# } else {
#     print "Unknown command\n";
# }
 
$SIG{INT} = sub {
  print "\nExiting...\n";
  exit;
};
 
print "My Perl SUKA\n";
while (1) {
    print "\$ ";
    my $input = <STDIN>;
    chomp($input);

    if ($input eq 'exit') {
        last;
    }

    eval "$input";
    if ($input eq 'ls') {
        ls(@ARGV);
    } elsif ($input eq 'cp') {
        cp(@ARGV);
    } elsif ($input eq 'mv') {
        mv(@ARGV);
    } elsif ($input eq 'ln') {
        ln(@ARGV);
    } elsif ($input eq 'ps') {
        process_monitoring();
    } elsif ($input eq 'kill') {
        kill_process();
    } elsif ($input eq 'backup') {
        process_monitoring();
    } else {
        print "Unknown command\n";
    }
  # Call the process_monitoring function
  sleep 5;
}