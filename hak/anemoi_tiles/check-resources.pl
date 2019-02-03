#!/usr/bin/perl
use strict;
use English;

my $filename = @ARGV[0];
my $resref;

open (IN, "<$filename") or die "failed to open $filename";

foreach my $line (<IN>)
{
  if ($line =~ m/(Model|ImageMap2d)=(.*)/)
  {
    $resref = $2;
	chomp($resref);
	
	if (system("dir $resref.mdl > out 2>&1") != 0)
	{
	  print "\n!failed to find $resref.mdl\n";
	}
	else 
	{
	  print ".";
	}

	if (system("dir $resref.wok > out 2>&1") != 0)
	{
	  print "\n!failed to find $resref.wok\n";
	}
	else 
	{
	  print ".";
	}	
  }
}