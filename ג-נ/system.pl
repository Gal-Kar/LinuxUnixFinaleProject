#!/usr/bin/perl
use strict;
use warnings;
use POSIX;
use Proc::ProcessTable;
use Archive::Tar;

use strict;
use warnings;

sub process_monitoring {
  my $ps_info = {};
  my @fields = qw(pid ppid stime pgrp state tty_nr comm);
  my $current_time = time();
  opendir(my $proc, '/proc') or die $!;

  while (my $pid = readdir($proc)) {
    next unless $pid =~ /^\d+$/;

    open(my $status, "/proc/$pid/status") or next;
    while (<$status>) {
      if (/^Pid:\s+(\d+)/) {
        $ps_info->{$pid}{'pid'} = $1;
      }
      if (/^PPid:\s+(\d+)/) {
        $ps_info->{$pid}{'ppid'} = $1;
      }
      if (/^Pgrp:\s+(\d+)/) {
        $ps_info->{$pid}{'pgrp'} = $1;
      } else {
        $ps_info->{$pid}{'pgrp'} = 'N/A';
      }
      if (/^State:\s+(\w+)/) {
        $ps_info->{$pid}{'state'} = $1;
      }
      if (/^Tty:\s+(\d+)/) {
        $ps_info->{$pid}{'tty_nr'} = $1;
      } else {
        $ps_info->{$pid}{'tty_nr'} = 'N/A';
      }
      if (/^Name:\s+(\S+)/) {
        $ps_info->{$pid}{'comm'} = $1;
      }
      # if (/^Starttime:\s+(\d+)/) {
      #   my $start_time = $1;
      #   my $time_diff = $current_time - $start_time / 100;
      #   if ($time_diff >= 86400) { # more than 1 day
      #     my $days_ago = int($time_diff / 86400);
      #     $ps_info->{$pid}{'stime'} = "$days_ago-days";
      #   } else {
      #     # Use localtime to format the start time
      #     my @stime = localtime($start_time / 100);
      #     $ps_info->{$pid}{'stime'} = sprintf("%02d:%02d", $stime[2], $stime[1]);
      #   }
      #   # $ps_info->{$pid}{'stime'} = $1;
      # }
    }
    close($status);

    my $stat = "/proc/$pid/stat";
    open(my $stat_file, "<", $stat) or next;

    my $stat_content = <$stat_file>;
    close($stat_file);
  
    my @stat_array = split(/\s+/, $stat_content);
    my $start_time = $stat_array[21];
    $start_time /= sysconf(&POSIX::_SC_CLK_TCK);
    my $time_diff = time() - $start_time;
    if ($time_diff >= 86400) { # more than 1 day
      # my $days_ago = int($time_diff / 86400);
      my $date = strftime "%Y-%m-%d %H:%M:%S", localtime($time_diff);
      $ps_info->{$pid}{'stime'} = $date;
      $ps_info->{$pid}{'stime'} = $start_time;
    } else {
      # Use localtime to format the start time
      my @stime = localtime(time() - $start_time);
      $ps_info->{$pid}{'stime'} = sprintf("%02d:%02d", $stime[2], $stime[1]);
    }
    # $ps_info->{$pid}{'stime'} = $stat_array[21];

  }
  closedir($proc);

  print "PID\tPPID\tPGRP\tSTATE\tTTY\tCOMMAND\tSTIME\n";

  foreach my $pid (sort {$a <=> $b} keys %$ps_info) {
    print join("\t\t", @{$ps_info->{$pid}}{@fields}), "\n";
  }
}

# kill process
sub kill_process {
  my ($pid) = @_;

  if (!defined($pid)) {
    print "Usage: kill_process(pid)\n";
    return;
  }

  # Validate that the process exists
  if (!kill 0, $pid) {
    print "Process with PID $pid does not exist\n";
    return;
  }

  # Send the kill signal to the process
  my $signal = "SIGKILL";
  if (kill $signal, $pid) {
    print "Process with PID $pid was killed successfully\n";
  } else {
    print "Failed to kill process with PID $pid\n";
  }
}

sub backup {
  my ($source, $tarfile) = @_;

  # Check if the source directory exists
  unless (-d $source) {
    print "Error: $source is not a directory.\n";
    return 0;
  }

  # Create an Archive::Tar object
  my $tar = Archive::Tar->new;

  # Add the contents of the source directory to the tar file
  $tar->add_files($source);

  # Write the tar file
  $tar->write($tarfile, COMPRESS_GZIP);

  return 1;
}

# restore
sub restore {
  my ($tarfile, $destination) = @_;

  # Check if the tar file exists
  unless (-e $tarfile) {
    print "Error: $tarfile does not exist.\n";
    return 0;
  }

  # Check if the destination directory exists
  unless (-d $destination) {
    print "Error: $destination is not a directory.\n";
    return 0;
  }

  # Create an Archive::Tar object
  my $tar = Archive::Tar->new;

  # Read the contents of the tar file
  $tar->read($tarfile);

  # Extract the contents of the tar file to the specified destination
  $tar->extract_compressed($destination);

  return 1;
}

1;