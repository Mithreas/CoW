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
  my $nodename;
  
  while (my $line = <IN>)
  {
    if ($line =~ m/(.*node\s+)(\w+\s+)(.*)/)
	{
	  $node = $1;
	  $nodetype = $2;
	  $nodename = $3;
	  
	  chomp($nodename);
	  
	  if (length($nodename) > 31)
	  {
	    print "\n!Node name too long: $nodename in $mdl\n";
		
		my $newname = $mdl;
		$newname =~ s/.mdl//;
		my $crc;
		$crc = adler32($nodename, $crc);
		$line = $node . $nodetype . $newname . $crc . "\n";
	  }	 	 
	}
	
	if ($line =~ m/(.*parent\s+)(.*)/)
	{
	  $node = $1;
	  $nodename = $2;
	  chomp ($nodename);
	  
	  if (length($nodename) > 31)
	  {
	    print "\n!!Parent node name too long: $nodename in $mdl\n";		
		
		my $newname = $mdl;
		$newname =~ s/.mdl//;
		my $crc;
		$crc = adler32($nodename, $crc);
		$line = $node . $newname . $crc . "\n";
	  }
	}
	
	print OUT $line;
  }
  
  close IN;
  close OUT;
}