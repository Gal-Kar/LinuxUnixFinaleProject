#!/usr/bin/perl
use strict;
use warnings;
use User::pwent;
use User::grent;
use Crypt::PasswdMD5 qw(unix_md5_crypt);
use File::Path qw(rmtree);
use File::Basename;

sub add_user {
  my ($username, $password) = @_;

  if (!defined($username) || !defined($password)) {
    print "Usage: add_user(username, password)\n";
    return;
  }

  my $crypt_pw = unix_md5_crypt($password, '$1$'.substr(rand().rand().rand(),2,8).'$');

  # Add user
  my $pwent = [
      $username, # login name
      '*', # encrypted password
      getpwnam($<)->gid, # user id
      0, # default initial group id
      '', # gecos field
      '/home/' . $username, # home directory
      '/bin/bash' # shellּ
  ];

  # Encrypted password is the second field of the password file entry
  $pwent->[1] = $crypt_pw;

  # Update password file
  updatepw(0, $pwent);

  # Check if user was added successfully
  my $pw_ent = getpwnam($username);
  if (defined $pw_ent) {
    print "User $username added successfully with UID ", $pw_ent->uid, "\n";
  } else {
    print "Failed to add user $username\n";
  }
}

sub remove_user {
  my $username = shift;

  if (!defined($username)) {
    print "Usage: remove_user(username)\n";
    return;
  }

  # Remove user
  my $pw_ent = getpwnam($username);
  if (defined $pw_ent) {
    my $home_dir = $pw_ent->dir;
    rmtree($home_dir);
  }

  # Remove user from password file
  my $pw_file = "/etc/passwd";
  my @lines = ();
  open my $fh, "<", $pw_file or die "Cannot open $pw_file: $!";
  while (<$fh>) {
    push @lines, $_ unless /^$username:/;
  }
  close $fh;
  open $fh, ">", $pw_file or die "Cannot open $pw_file: $!";
  print $fh @lines;
  close $fh;

  # Check if user was removed successfully
  my $user_ent = getpwnam($username);
  if (!defined $user_ent) {
    print "User $username removed successfully\n";
  } else {
    print "Failed to remove user $username\n";
  }
}

# change permission
sub change_permission {
  my ($path, $username, $permission) = @_;

  if (!defined($path) || !defined($username) || !defined($permission)) {
    print "Usage: change_permission(path, username, permission)\n";
    return;
  }

  # Validate path
  if (!-e $path) {
    print "$path does not exist\n";
    return;
  }

  # Validate username
  my $pw_ent = getpwnam($username);
  if (!defined $pw_ent) {
    print "User $username does not exist\n";
    return;
  }

  # Validate permission
  if ($permission !~ /^[rwx-]+$/) {
    print "Invalid permission: $permission\n";
    return;
  }

  # Change ownership of the file
  my $uid = $pw_ent->uid;
  my $gid = $pw_ent->gid;
  chown $uid, $gid, $path;

  # Change permission of the file
  my $mode = (stat $path)[2];
  $mode &= 07777;
  my @perms = split //, $permission;
  my @modes = (0, 0, 0, 0);
  my @rwx = qw(--- --x -w- -wx r-- r-xrw- rwx);
  for my $i (0..7) {
    $modes[$i / 3] |= 1 << $i % 3 if $perms[$i] ne '-';
  }
  $mode &= ~0700;
  $mode |= $modes[0] << 6;
  $mode &= ~0070;
  $mode |= $modes[1] << 3;
  $mode &= ~0007;
  $mode |= $modes[2];
  chmod $mode, $path;

  # Check if permission was changed successfully
  my ($dev, $ino, $new_mode, $nlink, $u_id, $g_id, $rdev, $size, $atime, $mtime, $ctime, $blksize, $blocks) = stat $path;
  my $new_permission = sprintf "%04o", $new_mode & 07777;
  if ($new_permission eq sprintf "%04o", oct($permission)) {
    print "Permission of $path was changed successfully to $permission\n";
  } else {
    print "Failed to change permission of $path\n";
  }
}

1;