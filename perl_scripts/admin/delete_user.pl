#!/usr/bin/perl

use strict;
use warnings;
use POSIX qw(:errno_h);

my $name = $ARGV[0];

# Check if the user exists
my ($uid, $gid, $home, $shell) = (getpwnam($name))[2, 3, 7, 8];
if (!$uid) {
    print "Error: User '$name' does not exist\n";
    return
}

# Delete the user entry in /etc/passwd
if (!open(PASSWD, "<", "/etc/passwd")) {
    print "Error: Failed to open /etc/passwd: $!\n";
    return;
}
my @passwd_entries = <PASSWD>;
close(PASSWD);
@passwd_entries = grep { !/^$name:/ } @passwd_entries;
if (!open(PASSWD, ">", "/etc/passwd")) {
    print "Error: Failed to open /etc/passwd: $!\n";
    return;
}
print PASSWD @passwd_entries;
close(PASSWD);

# Delete the user entry in /etc/shadow
if (!open(SHADOW, "<", "/etc/shadow")) {
    print "Error: Failed to open /etc/shadow: $!\n";
    return;
}
my @shadow_entries = <SHADOW>;
close(SHADOW);
@shadow_entries = grep { !/^$name:/ } @shadow_entries;
if (!open(SHADOW, ">", "/etc/shadow")) {
    print "Error: Failed to open /etc/shadow: $!\n";
    return;
}
print SHADOW @shadow_entries;
close(SHADOW);


# Function to remove a user directory from the home directory
sub remove_user_directory {
    my $user = shift;
    my $home_directory = "/home";
    my $user_directory = "$home_directory/$user";

    # Check if the user directory exists
    if(-d $user_directory) {
        # Remove the user directory and all of its contents
        opendir(my $dh, $user_directory) or do{
            print "Cannot open directory $user_directory: $!";
            return;
        };
        my @contents = readdir($dh);
        closedir($dh);
        foreach my $content (@contents) {
            next if($content eq '.' or $content eq '..');
            my $path = "$user_directory/$content";
            if(-d $path) {
                remove_user_directory($path);
            } else {
                unlink($path) or do{ 
                    print"Cannot remove file $path: $!";
                    return;
                };
            }
        }
        rmdir($user_directory) or do{
            print "Cannot remove directory $user_directory: $!";
            return;
        };
    } else {
        print "User directory $user_directory does not exist.\n";
    }
}

remove_user_directory($name);


# Delete the user's group entry in /etc/group if it has no other members

my $group_file = "/etc/group"; # Path to group file
my $group_to_remove_from = "groupname"; # Replace with the name of the group to remove the user from

# Open the group file for reading and writing
open my $group_fh, "<", $group_file or do{ 
    print "Unable to open group file: $!";
    return;
    };
my @group_lines = <$group_fh>; # Read in all lines of the group file
close $group_fh;

# Loop through each line of the group file
foreach my $line (@group_lines) {
    chomp($line); # Remove newline character from end of line
    my @fields = split(/:/, $line); # Split line into fields separated by colons

    my $groupname = $fields[0];
    my $group_members = $fields[3];

    if(defined($group_members)){
        # Split the list of members into an array
        my @members = split(/,/, $group_members);

        # Remove the user we want to remove from the array
        @members = grep { $_ ne $name } @members;

        # Join the remaining members back into a comma-separated list
        my $new_members = join(",", @members);

        # Replace the old list of members with the new one in the current line
        $fields[3] = $new_members;
        $line = join(":", @fields);
    }
}

# Open the group file for writing and write out the modified lines
open $group_fh, ">", $group_file or die "Unable to open group file: $!";
print $group_fh join("\n", @group_lines);
close $group_fh;

print "User deleted successfully";