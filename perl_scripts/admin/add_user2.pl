#!/usr/bin/perl
use User::pwent;
use Crypt::PasswdMD5;

my $username = $ARGV[0];
my $password = $ARGV[1];

if (!defined($username) || !defined($password)) {
print "Erorr: missing arguments\n";
return;
}

my $uid = 1001;
while (getpwnam($username)) {
    $uid++;
}

my $salt = '$1$'.substr(rand().rand().rand(),2,8);
my $crypt_password = unix_md5_crypt($password, $salt);



# Add user
my $pw = pwent->new();
$pw->set_name($username);
$pw->set_passwd($password);
$pw->set_uid($uid);
$pw->set_gid($uid);
$pw->set_gecos("New User");
$pw->set_dir("/home/$username");
$pw->set_shell("/bin/bash");


# Add the new user to the system's password file
setpwent();
addpwent($pw);
endpwent();
