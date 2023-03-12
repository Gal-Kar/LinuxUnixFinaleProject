#!/usr/bin/perl

use Archive::Tar;

# get the path to backup
my $path = $ARGV[0];

if (!defined($path)){
die "Please provide a path to backup\n";
}
if (!-e $path){
die "No such path\n";
}

# create a timestamp for the backup filename
my $timestamp = localtime();
$timestamp =~ s/[^0-9a-zA-Z]/_/g;

# set the backup filename
my $backup_filename = "$path_backup_$timestamp.tar";

# create a new Archive::Tar object
my $tar = Archive::Tar->new();

# add the files in the path to the tar archive
$tar->add_files($path);

# write the tar archive to a file
$tar->write($backup_filename);

print "Backup created successfully: $backup_filename\n";
