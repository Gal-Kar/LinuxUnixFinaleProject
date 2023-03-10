#!/usr/bin/perl,.
use strict;
use warnings;
use Cwd 'abs_path';
use File::stat;

sub ls {
    # my ($dir) = @_;
    my ($dir) = '.';
    $dir = abs_path($dir) if defined $dir;
    opendir(my $dh, $dir) or die "Couldn't open dir '$dir': $!";
    my @files = readdir $dh;
    closedir $dh;

    for my $file (@files) {
        my $file_path = "$dir/$file";
        my $st = stat($file_path);
        my $mode = sprintf "%04o", $st->mode & 07777;
        printf "%s %d %s\n", $mode, $st->size, $file;
    }
}

sub cp {
    my ($src, $dst) = @_;
    if (-d $dst) {
        $dst = "$dst/" . (split '/', $src)[-1];
    }
    copy($src, $dst) or die "Couldn't copy '$src' to '$dst': $!";
}


sub mv {
    my ($src, $dst) = @_;

    $src = abs_path($src);
    $dst = abs_path($dst);

    if (-d $dst) {
        $dst = "$dst/" . (split '/', $src)[-1];
    }
    
    rename($src, $dst) or die "Couldn't move '$src' to '$dst': $!";
}

sub ln {
    my ($src, $dst) = @_;

    $src = abs_path($src);
    $dst = abs_path($dst);

    if (-d $dst) {
        $dst = "$dst/" . (split '/', $src)[-1];
    }

    symlink($src, $dst) or die "Cannot create symbolic link: $!";
}

1;