#!/usr/bin/perl

my $path, @dirs;

if (@ARGV)
{
    $path = ARGV[0]
}
else
{
   $path = "\."; 
}

opendir(DIR,"$path");

@dirs = readdir(DIR);

closedir(DIR);

foreach(@dirs)

{

print $_."\n";

}
