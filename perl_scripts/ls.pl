#!/usr/bin/perl

my $path, @dirs;

$path = "\.";

opendir(DIR,"$path");

@dirs = readdir(DIR);

closedir(DIR);

foreach(@dirs)

{

print $_."\n";

}
