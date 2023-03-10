#!/usr/bin/perl
use User::pwent;
use Crypt::PasswdMD5;

my $username = $ARGV[0]
my $password = $ARGV[1];

if (!defined($username) || !defined($password)) {
print "Erorr: missing arguments\n";
return;
}

my salt = '$1$'.substr(rand().rand().rand(),2,8);
my $crypt_pw = unix_md5_crypt($password, $salt);

# Add user
my $pwent = [
    $username, # login name
    $crypt_pw, # encrypted password
    getpwnam($<)->gid, # user id
    0, # default initial group id
    '', # gecos field
    '/home/' . $username, # home directory
    '/bin/bash' # shellּ
];

# Update password file
updatepw(0, $pwent);

# Check if user was added successfully
if (defined getpwnam($username)) {
print "User added with ID - ", $pw_ent->uid;
} else {
print "Failed to add user\n";
}
