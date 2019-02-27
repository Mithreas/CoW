#!/usr/bin/perl
use strict;
use English;
use Compress::Zlib;

my @mdls = `dir /b *.mdl`;

foreach my $mdl (@mdls)
{
  chomp($mdl);
  
  if ($mdl =~ m/door/) 
  {
    next;
  }  
  
  print ".";
  
  # Open the file and check the contents.
  open (IN, "<$mdl") or die ("Failed to open $mdl");
  open (OUT, ">out/$mdl") or die ("Failed to open out/$mdl");
  my $node;
  my $nodetype;
  
  while (my $line = <IN>)
  {
    if ($line =~ m/(.*newmodel\s+)(\w+)/)
	{
	  $nodetype = $1;
	  $node = $2;
	  
	  chomp($node);
	  $mdl =~ s/.mdl//;
	  
	  if (!($node eq $mdl))
	  {
	    print "\n!Newmodel doesn't match filename!: $node vs $mdl\n";	
        $line =  $nodetype . $mdl . "\n";
	  }	 	 
	}
	
	print OUT $line;
  }
  
  close IN;
}