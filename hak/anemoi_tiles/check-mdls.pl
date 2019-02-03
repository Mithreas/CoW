#!/usr/bin/perl
use strict;
use English;

my @mdls = `dir /b *.mdl`;

foreach my $mdl (@mdls)
{
  chomp($mdl);
  
  if ($mdl =~ m/door/) 
  {
    next;
  }
  
  # Check that this is an ASCII mdl.
  #if (system("grep -q \"NWmax MODEL ASCII\" $mdl") != 0)
  #{
    # Not an ASCII model. 
  #  print "o";
  #	next;
  #}
  
  print ".";
  
  # Check for "classification Tile"
  if (system("grep -qi \"classification Tile\" $mdl") != 0)
  {
    print "\n!Missing classification Tile: $mdl\n";
  }  
  
  # Check for "node aabb"
  if (system("grep -q \"node aabb\" $mdl") != 0)
  {
    print "\n!Missing node aabb: $mdl ";
	
	# Check for a .wok file.
	$mdl =~ s/(\.mdl)//;
	if (system("dir $mdl.wok > nul 2>&1") != 0)
	{
	  print "and missing wok file";
	}
	else
	{
	  print "but has wok file";
	}
  }
}