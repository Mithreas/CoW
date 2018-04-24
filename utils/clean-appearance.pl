#!/usr/bin/perl
use strict;
use English;

open (IN, "<appearance.2da") or die ("failed to open appearance.2da");
open (OUT, ">app.2da.tmp") or die ("failed to write to app.2da.tmp");

my $row;

foreach my $line (<IN>)
{
  if ($line =~ m/(\d+).*/)
  {
    $row = $1;
    print "Processing row " . $row . "\n";
    if ($row > 870 && $row < 1000)
	{
	  $line = $row . "        ****                                          ****         USER                    ****               ****             ****        ****        ****          ****              ****             ****             ****       ****       ****      ****       ****          ****     ****      ****           ****           ****           ****         ****      ****      ****             ****           ****             ****           ****           ****        ****         ****         ****              ****       ****         \n";
	}
    if ($row > 999 && $row < 2000)
	{
	  $line = $row . "       ****                                          ****         crp_reserved            ****               ****             ****        ****        ****          ****              ****             ****             ****       ****       ****      ****       ****          ****     ****      ****           ****           ****           ****         ****      ****      ****             ****           ****             ****           ****           ****        ****         ****         ****              ****       ****         \n";
	}
  }
  
  print OUT $line;
}

close IN;
close OUT;

system("move appearance.2da appearance.2da.bak");
system("move app.2da.tmp appearance.2da");