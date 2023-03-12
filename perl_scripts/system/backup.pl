#!/usr/bin/perl

use Archive::Tar;

# get the path to backup
my $path = $ARGV[0];
# get the directory where the backup file should be saved
my $backup_directory = $ARGV[1];
if (!defined($backup_directory)){
backup_directory = '.';
}

if (!defined($path)){
die "Please provide a path to backup\n";
}
if (!-e $path){
die "No such path\n";
}

# get the base name of the path
my $basename = (split('/', $path))[-1];

# create a timestamp for the backup filename
my $timestamp = localtime();
$timestamp =~ s/[^0-9a-zA-Z]/_/g;

# set the backup filename
my $backup_filename = "${basename}_backup_$timestamp.tar";

# create a new Archive::Tar object
my $tar = Archive::Tar->new();

# add the files in the path to the tar archive
$tar->add_files($path);

# write the tar archive to a file
$tar->write("$backup_directory/$backup_filename");

print "Backup created successfully: $backup_filename\n";
