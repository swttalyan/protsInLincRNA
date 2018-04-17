#!/usr/local/bin/perl 
use strict;
use warnings;





my $num_args=$#ARGV+1;
if($num_args !=1)
{
print "Usage of Program: perl AlignmentsAboveRostCurve.pl NameoftheAlignmentFiles )\n";
exit;
}

## command for running the code
# perl AlignmentAboveRostCurve.pl alignments.txt >alignmentAboveRostCurve.txt
my $file=$ARGV[0];

open(FH,$file) or die "couldnt open the file $!\n";
my @files=<FH>;
foreach my $line (@files)
{
	chomp $line;
	if($line=~m(^Target))
	{
	print $line."\n";
	}
	else
	{
		if ($line=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
		{
		my $Target=$1;
		my $Query=$2;
		my $len=$3;
		my $pid=$4;
		#print $Target."\t".$Query."\t".$len."\t".$pid."\n";

		my $pid1=480*$len**((-0.32)*(1+exp((-$len)/1000)));
		

			if($len<=300)
			{

				if($pid >= $pid1)
				{
				print $line."\n";
				}
				else
				{
				#print $Target."\t"."Length:".$len." pid:".$pid." Below the Curve\n";
				}
			
			}

			else
			{
				
				my $PID_E=480*$len**((-0.32)*(1+exp((-300)/1000)));
				if($pid>=$PID_E)
				{
				print $line."\n";
				}
				else
				{
				#print $Target."\t"."Length:".$len." pid:".$pid." Below the Curve\n";
				}
			}
		}


		
	}

}


