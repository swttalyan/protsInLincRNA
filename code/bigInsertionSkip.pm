package main;
use warnings;
use strict;



sub bigInsertionSkip
{
	open (my $data , $_[0])|| die "could not open $ARGV[0]:\n$!";
	my @array=(<$data>);
	my @alignments=sort {(split(/\t/,$a))[0]<=>(split(/\t/,$b))[0]} @array;
	
	my @arrays=(); my $variable=$alignments[0];
	my @scorearray=(); my $score=0;
	if($variable=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
	{
	if($8=~m/(.*)\:(.*)/){$score=$1}
	}
	my $insertSize=10;
	for (my $i=1;$i<=$#alignments+1;$i++)
	{
		#print $i."\t".@alignments."\n";
		my $secondalignment=$alignments[$i];
		my $firstalignment=$alignments[$i-1];

		my $endS1=0;my $endC1=0; my $startS2=0;my $startC2=0;my $score1=0;

		if($firstalignment=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
		{
		$endS1=$2;$endC1=$4;
		}
		if($secondalignment=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
		{
		$startS2=$1;$startC2=$3;if($8=~m/(.*)\:(.*)/){$score1=$1}
		}

		#print $insertSize."\t".($startS2-$endS1)."\t".($startC2-$endC1)."\n";
		####### 10 and not last one
		if(((($startS2-$endS1-1) >$insertSize) || (($startC2-$endC1-1) >$insertSize))&&($i<@alignments))
		{
		#print "n1";
		push (@arrays,$variable);
		$variable=$secondalignment;
		push (@scorearray,$score);
		$score=$score1;	
		}
		### not 10 and not last one
		elsif( ((($startS2-$endS1-1) <=$insertSize) || (($startC2-$endC1-1) <=$insertSize))&&($i<@alignments))
		{
		#print "n2";
		$variable=$variable.$secondalignment;
		$score=$score+$score1;
		}
		###### 10 and last one
		elsif(((($startS2-$endS1-1) >$insertSize) || (($startC2-$endC1-1) >$insertSize))&&($i>$#alignments-1))
		{
		#print "y1";
		push (@arrays,$variable);
		push (@arrays,$secondalignment);
		push (@scorearray,$score);
		push (@scorearray,$score1);
		}
		####### not 10 and last one
		elsif(((($startS2-$endS1-1) <=$insertSize) || (($startC2-$endC1-1) <=$insertSize))&&($i>$#alignments-1))
		{
		#print "y2";
		push (@arrays,$variable);
		push (@scorearray,$score);
		}

	}
	#print $arrays[0]."\t".$scorearray[0]."\n";
	open (FILE,">alignment.txt");
	my $position = first {$scorearray[$_] eq max @scorearray} 0 .. $#scorearray;
	print FILE $arrays[$position];
	close FILE;
}
1;
