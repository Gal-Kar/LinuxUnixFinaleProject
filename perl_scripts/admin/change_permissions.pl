#!/usr/bin/perl

use strict;
use warnings;

my $username = $ARGV[0];
my $groupname = $ARGV[1];

if (!defined($username) || !defined($groupname)) {
    print "Erorr: missing arguments\n";
    return;
}


# Open the /etc/group file for reading and writing
open my $group_file, "+<", "/etc/group" or do{
    print "Cannot open /etc/group: $!";
    return;
};

# Read each line of the file and look for the group we want to modify
while (my $line = <$group_file>) {
    chomp $line;
    my ($name, $password, $gid, $users) = split /:/, $line;
    
    # If we found the group we want to modify, add the user to the list of users
    if ($name eq $groupname) {
        my @user_list = split /,/, $users;
        push @user_list, $username;
        my $new_users = join(',', @user_list);
        
        # Seek back to the beginning of the line and write the modified line to the file
        seek $group_file, -length($line), 1;
        print $group_file join(':', $name, $password, $gid, $new_users), "\n";
        
        last;  # Exit the loop once we've modified the group
    }
}

# Close the /etc/group file
close $group_file;

print "Permission edited successfully";