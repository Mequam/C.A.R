#!/bin/perl
package parse;
use strict;
use warnings;
use 5.03.0;

print "works\n";

sub parseS
{
	my ($state,@opps,@funcs) = @_;
	
	print "$state\n";
	my @stateArr = split '', $state;
	for (my $i = 0; $i < scalar @stateArr;$i++)
	{
		print uc $stateArr[$i];
	}
	print "\n";
}

parseS("potato");
1;
