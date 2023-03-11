#!/usr/bin/perl

# Function to set permissions for a user's home directory
sub set_user_permissions {
    # Prompt the user for a username
    print "Enter the username: ";
    my $user = <STDIN>;
    chomp($user);

    # Construct the path to the user's home directory
    my $home_directory = "/home/$user";

    # Check if the home directory exists
    if(-d $home_directory) {
        # Prompt the user for the new permissions
        print "Enter the new permissions (in octal format): ";
        my $permissions = <STDIN>;
        chomp($permissions);

        # Set the new permissions on the home directory
        chmod(oct($permissions), $home_directory) or die "Cannot set permissions on $home_directory: $!";
        print "Permissions set successfully.\n";
    } else {
        print "Home directory for user $user does not exist.\n";
    }
}

# Test the function
set_user_permissions();
