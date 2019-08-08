#!/bin/perl
package parse;
use strict;
use warnings;
use 5.03.0;

print "works\n";
sub inP
{
#this is a subroutine to test wether or not a given string is surrounded
#completly by a parenthasis pair of the callers choosing
#the sub routine defaults to using '()'
	my ($str,$open,$close) = @_;
	if (not defined $str)
	{
		print "[inP] ERROR: string argument required!\n";
		die;
	}
	if (not defined $open)
	{ $open = '(';}
	if (not defined $close) {$close = ')'}


	my @arrStr = split '', $str;
	my $parenthLevel = 0;
	for (my $i = 0; $i < scalar(@arrStr)-2;$i++)
	{	
		#incriment and decriment the parenthlevel based on when we see open and closed curllys
		if ($arrStr[$i] eq $open) {$parenthLevel += 1;}
		if ($arrStr[$i] eq $close) {$parenthLevel -= 1;}
		
		#if we find that the parenth level ever hits zero it means that we are outside of parenthasis, so return false
		if (($parenthLevel == 0)) {return 0;}
	}
	if ($arrStr[scalar(@arrStr) - 1] eq $close) {return 1;}
	else {return 0;}
}
sub parseS
{
	my ($state,@opps,@funcs) = @_;
	
	print "$state\n";
	my @stateArr = split '', $state;

	for (my $i = 0; $i < scalar @stateArr;$i++)
	{
		for (my $j = 0; $j < scalar @opps;$j++)
		{
			if ($opps[$j][1] eq $stateArr[$i])
			{
				print "matched a $stateArr[$i]\n";
			}
		}
		$stateArr[$i];
	}
	print "\n";
}
parseS("1+1",(["test\n","+"]));
inP "fake string\n";

my $ui = 'blah';
while (not ($ui eq 'q'))
{
	print "(string)> ";
	$ui = <STDIN>;
	if (inP(substr($ui,0,length $ui)) == 1)
	{
		print "you are inside of parenthasis\n";
	}
	else
	{
		print "you are not inside of parenthasis\n";
	}
}
1;
