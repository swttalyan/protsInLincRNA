package main;
use List::Util qw( min max );
use Term::ANSIColor;
use warnings;
use strict;


######################################## subroutine for extending the alignment in both directions #######################################


sub alignment_extension
{
	my $SWPSeq=$_[0];
	my $Frame1Seq=$_[1];
	my $Frame2Seq=$_[2];
	my $Frame3Seq=$_[3];
	my $SWP_start=$_[4];
	my $SWP_end=$_[5];
	my $CC_start=$_[6];
	my $CC_end=$_[7];
	my $unalSt=$_[8];
	my $unalStSWP=$_[9];
	my $minKmer=$_[10];
	#print $SWP_start."\t".$SWP_end."\t".$CC_start."\t".$CC_end."\n";
	
	if ((defined $SWPSeq) && (defined $Frame1Seq) && (defined $Frame2Seq) && (defined $Frame3Seq) && (defined $SWP_start) && (defined $SWP_end) && (defined $CC_start) && (defined $CC_end) &&
	 (defined $unalSt) && (defined $unalStSWP))
	{
		#### for SwissProt unaligned coordinates
		my @unalSWP_S; my @unalSWP_E;
		if (($SWP_start <= 1) && ($CC_start <= 1))
		{			
			push (@unalSWP_S, $SWP_end);
			push (@unalSWP_E, length ($SWPSeq));	
		}
		else
		{
			push (@unalSWP_S,0);
			push (@unalSWP_E,$SWP_start-1);
			push (@unalSWP_S,$SWP_end);
			push (@unalSWP_E,length ($SWPSeq));						
		}
	
		#for Frames unaligned coordinates	
		my @unalCC_S; my @unalCC_E;
		if (($CC_start <= 1) && ($SWP_start <= 1))
		{			
			push (@unalCC_S, $CC_end);
			push (@unalCC_E, length ($Frame1Seq));	
		}
		else
		{
			push (@unalCC_S,0);
			push (@unalCC_E,$CC_start-1);
			push (@unalCC_S,$CC_end);
			push (@unalCC_E,length ($Frame1Seq));						
		}
		
		#foreach  my $line (@unalSWP_S){print $line."\n";}
		#foreach  my $line (@unalSWP_E){print $line."\n";}
		#foreach  my $line (@unalCC_S){print $line."\n";}
		#foreach  my $line (@unalCC_E){print $line."\n";}
		
		my $SWP1=""; my $Fr1=""; my $Fr2="";my $Fr3="";
	
		for (my $index=0;$index<=$#unalSWP_S;$index++)
		{
			if ((defined $unalCC_E[$index]) && (defined $unalCC_S[$index]) && (defined $unalSWP_E[$index]) && (defined $unalSWP_S[$index]))
			{
				if ($unalCC_E[$index]-$unalCC_S[$index]>=3)
				{
					my $SWP1=substr $SWPSeq,$unalSWP_S[$index],($unalSWP_E[$index]-$unalSWP_S[$index]);
					my $Fr1=substr $Frame1Seq,$unalCC_S[$index],($unalCC_E[$index]-$unalCC_S[$index]);
					my $Fr2=substr $Frame2Seq,$unalCC_S[$index],($unalCC_E[$index]-$unalCC_S[$index]);
					my $Fr3=substr $Frame3Seq,$unalCC_S[$index],($unalCC_E[$index]-$unalCC_S[$index]);
					my $fl2_new= $unalSt + $unalCC_S[$index]; 
					my $fl2_newSWP= $unalStSWP + $unalSWP_S[$index];
					if((defined $SWP1) && (defined $Fr1) && (defined $Fr2) && (defined $Fr3))
					{
						#print $SWP1."\t".$Fr1."\t".$Fr2."\t".$Fr3."\n";
						if ( (length ($SWP1)  >= 2) & ( $SWP1 ne $SWPSeq))
						{
						perfect_alignment($SWP1,$Fr1,$Fr2,$Fr3,$minKmer,$fl2_new,$fl2_newSWP);
						}
					}
					
				}
			}
			
		
		
		my $SWP1=""; my $Fr1=""; my $Fr2="";my $Fr3="";
		}
		
	}
}
1;


