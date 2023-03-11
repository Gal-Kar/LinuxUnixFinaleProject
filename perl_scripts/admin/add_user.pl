#!/usr/bin/perl
use User::pwent;
use Crypt::PasswdMD5;
use strict;
use warnings;
use POSIX qw(:errno_h);



my $name = $ARGV[0];
my $password = $ARGV[1];

if (!defined($name) || !defined($password)) {
print "Erorr: missing arguments\n";
return;
}

my $uid = 1001;
# Open /etc/passwd file for reading
open(my $passwd_file, "<", "/etc/passwd")
    or die "Couldn't open /etc/passwd file: $!";

# Read each line of the file and find the next free UID
my %hash_map;
while(my $line = <$passwd_file>) {
    my $cur_id = (split /:/,$line)[2];
    $hash_map{$cur_id} = 1;
}

while(exists $hash_map{$uid}){
    $uid++;
}

my $salt = '$1$'.substr(rand().rand().rand(),2,8);
my $crypt_password = unix_md5_crypt($password, $salt);

# my @user_info = [$name, $crypt_password, $uid , $uid, '',"/home/$name","/bin/bash"];

my $gid = $uid;
my $gecos = "";
my $home = "/home/$name";
my $shell = "/bin/bash";


# Check if the user already exists
if (getpwnam($name)) {
    die "Error: User '$name' already exists\n";
}

# Create the user
# my $user_add = getgrgid($gid) ":" $gid; # construct group name for -g option

my $user_info = "$name:x:$uid:$gid:$gecos:$home:$shell"; # construct user information


my $encrypted_password = unix_md5_crypt($password, $salt); # encrypt the password with a random salt

# Create the user entry in /etc/passwd
if (!open(PASSWD, ">>", "/etc/passwd")) {
    die "Error: Failed to open /etc/passwd: $!\n";
}
print PASSWD "$user_info\n";
close(PASSWD);

# Create the user entry in /etc/shadow
if (!open(SHADOW, ">>", "/etc/shadow")) {
    die "Error: Failed to open /etc/shadow: $!\n";
}
print SHADOW "$name:$encrypted_password:18748::::::\n"; # empty fields are filled with colons
close(SHADOW);

# Create the user's home directory
if (!mkdir($home, 0755)) {
    my $error = $!;
    if ($error == EEXIST) {
        die "Error: Failed to create home directory '$home': Directory already exists\n";
    }
    else {
        die "Error: Failed to create home directory '$home': $!\n";
    }
}

# Set the ownership of the home directory to the new user
if (!chown($uid, $gid, $home)) {
    die "Error: Failed to set ownership of home directory '$home': $!\n";
}

# Set the default shell for the user
if (!open(PASSWD, "<", "/etc/passwd")) {
    die "Error: Failed to open /etc/passwd: $!\n";
}
my @passwd_entries = <PASSWD>;
close(PASSWD);
my $passwd_entry = (grep /^$name:/, @passwd_entries)[0];
my @fields = split(/:/, $passwd_entry);
$fields[6] = $shell;
my $new_passwd_entry = join(":", @fields);
if (!open(PASSWD, ">", "/etc/passwd")) {
    die "Error: Failed to open /etc/passwd: $!\n";
}
print PASSWD @passwd_entries;
close(PASSWD);

