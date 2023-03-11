#!/usr/bin/perl

use strict;
use warnings;
use POSIX qw(:errno_h);

my $name = $ARGV[0];

# Check if the user exists
my ($uid, $gid, $home, $shell) = (getpwnam($name))[2, 3, 7, 8];
if (!$uid) {
    die "Error: User '$name' does not exist\n";
}

# Delete the user entry in /etc/passwd
if (!open(PASSWD, "<", "/etc/passwd")) {
    die "Error: Failed to open /etc/passwd: $!\n";
}
my @passwd_entries = <PASSWD>;
close(PASSWD);
@passwd_entries = grep { !/^$name:/ } @passwd_entries;
if (!open(PASSWD, ">", "/etc/passwd")) {
    die "Error: Failed to open /etc/passwd: $!\n";
}
print PASSWD @passwd_entries;
close(PASSWD);

# Delete the user entry in /etc/shadow
if (!open(SHADOW, "<", "/etc/shadow")) {
    die "Error: Failed to open /etc/shadow: $!\n";
}
my @shadow_entries = <SHADOW>;
close(SHADOW);
@shadow_entries = grep { !/^$name:/ } @shadow_entries;
if (!open(SHADOW, ">", "/etc/shadow")) {
    die "Error: Failed to open /etc/shadow: $!\n";
}
print SHADOW @shadow_entries;
close(SHADOW);


# Function to remove a user directory from the home directory
sub remove_user_directory {
    my $user = shift;
    my $home_directory = "/home/$user";
    my $user_directory = "$home_directory/$user";

    # Check if the user directory exists
    if(-d $user_directory) {
        # Remove the user directory and all of its contents
        opendir(my $dh, $user_directory) or die "Cannot open directory $user_directory: $!";
        my @contents = readdir($dh);
        closedir($dh);
        foreach my $content (@contents) {
            next if($content eq '.' or $content eq '..');
            my $path = "$user_directory/$content";
            if(-d $path) {
                remove_user_directory($path);
            } else {
                unlink($path) or die "Cannot remove file $path: $!";
            }
        }
        rmdir($user_directory) or die "Cannot remove directory $user_directory: $!";
    } else {
        print "User directory $user_directory does not exist.\n";
    }
}

remove_user_directory($name);


# Delete the user's group entry in /etc/group if it has no other members
my $group_name = getgrgid($gid);
my $group_entry = (getgrnam($group_name))[3];
my @group_members = split(/,/, $group_entry);
if (@group_members == 1 && $group_members[0] eq $name) {
    if (!open(GROUP, "<", "/etc/group")) {
        die "Error: Failed to open /etc/group: $!\n";
    }
    my @group_entries = <GROUP>;
    close(GROUP);
    @group_entries = grep { !/^$group_name:/ } @group_entries;
    if (!open(GROUP, ">", "/etc/group")) {
        die "Error: Failed to open /etc/group: $!\n";
    }
    print GROUP @group_entries;
    close(GROUP);
}