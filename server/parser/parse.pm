#!/bin/perl
package parse;
use strict;
use warnings;
use 5.03.0;

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

	if (not defined $open) {$open = '(';}
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
sub stripOuter
{	
	my $str = shift;
	while (inP($str))
	{	
		$str = substr($str,1,(length($str)-2));
	}
	return $str;
}
sub parseS
{
	#set up the variables for the sub routine

	#the array is probably not getting passed how we would want it to
	my ($state,$oppsRef,$funcsRef,$open,$close) = @_;

	#strip the given statement of any outside parenthasis
	$state = stripOuter $state;
	
	#dereference the oppsRef to get acces to the varaibles stored within it	
	my @oppsArr = @$oppsRef;
	my @funcsArr = @$funcsRef;
	
	#default the parenthasis if it is not given
	if (not defined $open) {$open = '(';}
	if (not defined $close) {$close = ')';}	

	#set up the state varaible as somthing we can iterate over
	my @stateArr = split '', $state;
	
	my $parenthLvl = 0;
	
	for (my $i = 0; $i < length $state;$i++)
	{
	
	#set the parenthasis level
		if  ($stateArr[$i] eq $open)
		{	
			$parenthLvl += 1;
			next;
		}
		elsif ($stateArr[$i] eq $close)
		{	
			$parenthLvl -= 1;
			next;
		}
	#check the parenthasis lvl
		
		if ($parenthLvl == 0 and $stateArr[$i] ne $open and $stateArr[$i] ne $close)
		{
			#only check the letter if we know its not in parenthasis and is 
			#not a parenthasy	
			for (my $j = 0; $j < scalar @oppsArr;$j++)
			{	
				if ($oppsArr[$j][1] eq $stateArr[$i])
				{	
					#split the string up into two strings and return the function of 
					#those two string + 1s
					my $stringB = substr $state , $i + 1;
					my $stringA = substr $state, 0, $i;		
						
					my $ret_val = &{$oppsArr[$j][0]}(parseS($stringA,$oppsRef,$funcsRef,$open,$close), parseS($stringB,$oppsRef,$funcsRef,$open,$close));							
					return $ret_val;
				}
			}
		}	
		
		
	}	
	#we have been unable to find any valid operations to check, this is where we store the functions that we want to parse
	for (my $j = 0; $j < scalar(@funcsArr);$j++)
	{
		print "checking $funcsArr[$j][1] against ",substr($state,0,length($funcsArr[$j][1])),"\n";	
		if (substr($state,0,length($funcsArr[$j][1])) eq $funcsArr[$j][1])
		{
			#its currently finding the function successfully the next step is to parse out the arguments
			#for that function and return the parsed function args
			print "we found a function match!\n";
		}
	}
	return int($state);
}



my $addRef = sub 
{	
	my $ret_val = 0;
	foreach (@_)
	{
		$ret_val += $_
	}
	return $ret_val;
	
};

my $subRef = sub
{
	my ($x,$y) = @_;
	return $x - $y; 
};

my $multRef = sub
{
	my $ret_val = 1;
	foreach (@_)
	{
		$ret_val *= $_;
	}
	return $ret_val;
};
my $divRef = sub
{
	my ($x,$y) = @_;
	return $x/$y;
};

sub fact 
{
	my $num = shift;
	if ($num < 0)
	{return -1;}
	elsif ($num == 1)
	{
		return 1;
	}
	else
	{
		return $num*fact($num-1);
	}	
};
sub test 
{
	print inP "test";
	print inP "test2";
	print inP "(test3)(test3)";
	print inP "(test4)";
	print inP "[test5]", '[',']';
	print "\n", stripOuter "(test)","\n";
	while (42)
	{
		print "(expr)> ";
		my $inp = <STDIN>;
		$inp = substr $inp,0,length($inp) - 1;
		print "evaluating $inp\n";
		my $result = parseS($inp,[[$addRef,"+"],[$subRef,"-"],[$multRef,'*'],[$divRef,'/']],[[\&fact,'fact']],"(",")");
		print "final result: $result\n";
	}
}
test();
1;
