#! /usr/bin/perl
use strict;
use English;

# Replace all instances of the first argument with the second argument in all nss files in the current folder.

my @files = `dir /b *.nss`;
my $arg1  = $ARGV[0];
my $arg2  = $ARGV[1];

print "Replacing all instances of $arg1 with $arg2 in *.nss\n";

foreach my $file (@files)
{
  chomp ($file);
  open (IN, "<$file") or die ("failed to open $file");
  open (OUT, ">$file.tmp") or die ("failed to open out/$file");
  
  foreach my $line (<IN>)
  {
    if ($line =~ s/$arg1/$arg2/g)
	{
	  print "Replacing instance in $file.\n";
	}
	
	print OUT $line;
  }
  
  close IN;
  close OUT;
  system ("move /Y $file.tmp $file >nul");
}