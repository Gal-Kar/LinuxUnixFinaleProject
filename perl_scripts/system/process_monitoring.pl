#!/usr/bin/perl

opendir(DIR, "/proc") or die "Cannot open /proc: $!";
my @pids = grep /^\d+$/, readdir(DIR);
closedir(DIR);

foreach my $pid (@pids) {
  open(FILE, "/proc/$pid/stat") or next;
  my $line = <FILE>;
  close(FILE);

  my @fields = split(/\s+/, $line);
  my $cmdline = "";
  if (-e "/proc/$pid/cmdline") {
    open(FILE, "/proc/$pid/cmdline") or next;
    $cmdline = <FILE>;
    close(FILE);
    $cmdline =~ s/\0/ /g;
  }
  print "$fields[0] $fields[1] $fields[2] $fields[3] $fields[4] $fields[5] $fields[6] $fields[7] $fields[8] $fields[9] $fields[10] $cmdline\n";
}