#!/usr/bin/perl
use strict;
use English;
use File::Copy;

# Search all tec01* models for dummy nodes with position lines set.
my @files = glob('tec01*');

my $dummy = 0;
my $good  = 0;
my $bad   = 0;

foreach my $file (@files)
{
  open (IN, "<$file") or die ("Could not open $file");
  $dummy = 0;
  $bad = 0;
  
  foreach my $line (<IN>)
  {
    if ($line =~ m/node dummy/)
	{
	  $dummy = 1;
	}
	
	if ($dummy)
	{
	  if ($line =~ m/endnode/)
	  {
	    $dummy = 0;
		last;
	  }
	  elsif ($line =~ m/position 0 0 1/)
	  {
	    print "$file has dummy node at z=1\n";
		$bad = 1;
	  }
	}
  }
  
  if ($bad == 0)
  {
    $good ++;
  }
  else
  {
    copy($file, "tec_fixed_tiles/$file");
  }
  
  close IN;
}

print "There were $good OK files.\n";