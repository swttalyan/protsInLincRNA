#!/usr/bin/perl
use strict;
use warnings;


use Math::Complex;
use List::Util qw( min max );
use List::MoreUtils qw(uniq);

my $num_args=$#ARGV+1;
if($num_args !=1)
{
print "Usage of Program: perl RankingByEuclideanDistance.pl TableFormatFile\n";
exit;
}

######### command to run the script
### perl RankingbyEuclideanDistance.pl alignmentAboveRostCurve.txt >alignmentAboveRostCurvewithEuclDistance.txt

my @distanceArray=();
my @TargetIds=();

my $inputFile=$ARGV[0];


open (FH,$inputFile);
my @list=<FH>;
close FH;
foreach my $line (@list)
{
	chomp $line;
	if($line=~m/^Target/)
	{
	#print $line."\n";
	}		
	else
	{
	my @distances=();
		if($line=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
		{
		push(@TargetIds,$1);
		my $x1=$3;my $y1=$4;
		
			for (my $j=0;$j<=$x1;$j=$j+0.05)
			{
			my $x2=$j;
			my $y2=480*$x2**((-0.32)*(1+exp((-$x2)/1000)));
			my $distance=sprintf "%.2f",sqrt((($x2-$x1)*($x2-$x1))+(($y2-$y1)*($y2-$y1)));
			push (@distances,$distance);		
			}
		}
	my $min=min @distances;
	push(@distanceArray, $min."\t".$line);
	}

}
my @TargetIds_unique = uniq @TargetIds;
my @sorted_distancealignment = sort @distanceArray;
print "Target\tQuery\tRank\tEuclDistance\tAlignmentLength\tPercentIdentity\tMatch:Conserved:Semiconserved\tTargetStart\tTargetEnd\tQueryStart\tQueryEnd\n";
foreach my $l (@TargetIds_unique)
{
chomp $l;
my @rank=();
	foreach my $ll (@sorted_distancealignment)
	{
		if($ll=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
		{
			if($2 eq $l)
			{
			push(@rank, $ll);
			}
		}
	}

	my @Ranking = reverse @rank;
	
	foreach my $line (@Ranking)
	{
		my $i=1;
		if($line=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
		{
		print $2,"\t".$3,"\t".$i."\t".$1."\t".$4."\t".$5."\t".$6."\t".$7."\t".$8."\t".$9."\t".$10."\n";
		$i=$i+1;
		}
	}
	

}
