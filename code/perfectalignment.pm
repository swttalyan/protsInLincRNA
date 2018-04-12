package main;
#use warnings;
use strict;
use String::LCSS_XS qw(lcss lcss_all);
use List::Util qw( min max );
use List::Util::XS;


sub perfect_alignment
{
	
	my $SWPSequence=$_[0];
	my $Frame1Sequence=$_[1];
	my $Frame2Sequence=$_[2];
	my $Frame3Sequence=$_[3];
	my $minKmer=$_[4];
	my $unalSt=$_[5];
	my $unalStSWP= $_[6];
	
	if ((defined $SWPSequence) &&(defined $Frame1Sequence) && (defined $Frame2Sequence) && (defined $Frame3Sequence) && (defined $minKmer) && (defined $unalSt) && (defined $unalStSWP))
	{
		#print "$SWPSequence\t$Frame1Sequence\t$Frame2Sequence\t$Frame3Sequence\t$minKmer\t$unalSt\t$unalStSWP\n";
		
		my @Allstring=(); my @Allmatch=();

		my @longest1 = &String::LCSS_XS::lcss_all ( $SWPSequence,$Frame1Sequence,$minKmer );
		if (@longest1)
		{
			for my $longest1 (@longest1)
			{
			#print $longest1->[0]."\n";
	    		push (@Allstring,length ($longest1->[0]));
			push (@Allmatch,length ($longest1->[0])."\t".$longest1->[1]."\t".$longest1->[2]."\tF1");
			}
		

		}
		my @longest2 = &String::LCSS_XS::lcss_all ( $SWPSequence,$Frame2Sequence,$minKmer );
		if (@longest2)
		{
			for my $longest2 (@longest2)
			{
			#print $longest2->[0]."\n";
	    		push (@Allstring,length ($longest2->[0]));
			push (@Allmatch,length ($longest2->[0])."\t".$longest2->[1]."\t".$longest2->[2]."\tF2");
			}
			

		}
		my @longest3 = &String::LCSS_XS::lcss_all ( $SWPSequence,$Frame3Sequence,$minKmer );
		if (@longest3)
		{
			for my $longest3 (@longest3)
			{
			#print $longest3->[0]."\n";
	    		push (@Allstring,length ($longest3->[0]));
			push (@Allmatch,length ($longest3->[0])."\t".$longest3->[1]."\t".$longest3->[2]."\tF3");
			}

		}

		#foreach my $line (@Allstring){print $line."\n";}
		#foreach my $line (@Allmatch){print $line."\n";}
		
		
		my $maxlength=max @Allstring;
		my @longestmatch=();
		foreach my $line (@Allmatch)
		{
			if ($line=~m/$maxlength\t(.*)\t(.*)\t(.*)/)
			{
				push (@longestmatch,$line);
			}	
		}
		my $S_SWP=0; my $E_SWP=0; my $S_CC=0; my $E_CC=0;my $frame=0;
		if (@longestmatch)
		{
			if ($#longestmatch >= 1)
			{
				my @score=();my @bestscore=();my @length=();
				foreach my $result (@longestmatch) 
				{
					if ($result=~m/(.*)\t(.*)\t(.*)\t(.*)/)
					{
					my $kmer=$1; my $startSWP=$2+1;
					my $endSWP=$startSWP+$kmer-1;my $startCC=$3+1;
					my $endCC=$startCC+$kmer-1;my $frame=$4; my $FrameSeq="";my $SWPSeq=$SWPSequence;
					if ($frame eq 'F1'){$FrameSeq=$Frame1Sequence;}if ($frame eq 'F2'){$FrameSeq=$Frame2Sequence;}if ($frame eq 'F3'){$FrameSeq=$Frame3Sequence;}
					my ($length1,$score1,$startSWP1,$endSWP1,$startCC1,$endCC1,$frame1)=conservedScore($SWPSeq,$FrameSeq,$startSWP,$endSWP,$startCC,$endCC,$frame);
					#print "Before1\t".$startSWP."\t".$endSWP."\t".$startCC."\t".$endCC."\n";
					#print "After1\t".$startSWP1."\t".$endSWP1."\t".$startCC1."\t".$endCC1."\n";
					#print $score."\tScore\n";
					push (@length,$length1); #push (@score,$score1);
					push (@bestscore,$length1."\t".$score1."\t".$startSWP1."\t".$endSWP1."\t".$startCC1."\t".$endCC1."\t".$frame1);
					}
				}
				my $maxlength=max @length; my $maxScore=max @score; #print $maxlength."\t".$maxScore."\n";
				my @longestlength=();
				if ($#bestscore >= 1)
				{	
					my @bestlength=();
					foreach my $line (@bestscore)
					{
						if ($line =~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
						{
							if($1>=$maxlength)
							{
							push (@bestlength,$line);
							push (@score,$2);
							}
						}
					}
					if($#bestlength >=1)
					{
						foreach my $line (@bestlength)
						{
							if ($line =~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
							{
								if($2 >= $maxScore)
								{
								$S_SWP=$3;$E_SWP=$4;
								$S_CC=$5;$E_CC=$6;
								$frame=$7;
								
								}
							}
						}
					}
					else
					{
						foreach my $bestlength (@bestlength)
						{
							if($bestlength=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
							{
							$S_SWP=$3;$E_SWP=$4;
							$S_CC=$5;$E_CC=$6;
							$frame=$7;
							}
						}
					}

				}
				else
				{
					foreach my $bestscore (@bestscore)
					{
						if($bestscore=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
						{
						$S_SWP=$3;$E_SWP=$4;
						$S_CC=$5;$E_CC=$6;
						$frame=$7;
						}
					}
				}
			}
			else
			{
				foreach my $longestmatch (@longestmatch)
				{
					if($longestmatch=~m/(.*)\t(.*)\t(.*)\t(.*)/)
					{
					my $kmer=$1; my $startSWP=$2+1;
					my $endSWP=$startSWP+$kmer-1;my $startCC=$3+1;
					my $endCC=$startCC+$kmer-1;my $frame1=$4; my $FrameSeq="";my $SWPSeq=$SWPSequence;
					if ($frame1 eq 'F1'){$FrameSeq=$Frame1Sequence;}if ($frame1 eq 'F2'){$FrameSeq=$Frame2Sequence;}if ($frame1 eq 'F3'){$FrameSeq=$Frame3Sequence;}
					(my $length,my $score,$S_SWP,$E_SWP,$S_CC,$E_CC,$frame)=conservedScore($SWPSeq,$FrameSeq,$startSWP,$endSWP,$startCC,$endCC,$frame1);
					#print $score."\tScore\n";
					#print "Before\t".$startSWP."\t".$endSWP."\t".$startCC."\t".$endCC."\n";
					#print "After\t".$S_SWP."\t".$E_SWP."\t".$S_CC."\t".$E_CC."\n";
					}
				}

			}
		
		}
		
		my $start=$S_SWP+$unalStSWP;my $end=$E_SWP+$unalStSWP;
		#print "TO be added\t".$S_SWP."\t".$E_SWP."\t".$S_CC."\t".$E_CC."\t".$frame."\n";
		my $seq=substr($SWPSequence,$S_SWP-1,$E_SWP-$S_SWP+1);
		my $seq1="";
		if($frame eq 'F1'){$seq1=substr($Frame1Sequence,$S_CC-1,$E_CC-$S_CC+1);}
		if($frame eq 'F2'){$seq1=substr($Frame2Sequence,$S_CC-1,$E_CC-$S_CC+1);}
		if($frame eq 'F3'){$seq1=substr($Frame3Sequence,$S_CC-1,$E_CC-$S_CC+1);}
		my ($score)=seqScore($seq,$seq1);
		my $START=$S_CC+$unalSt;my $END=$E_CC+$unalSt; my $len1=length($seq);
		#print "Aligning\t".$start."\t".$end."\t".$START."\t".$END."\t".$frame."\t".$seq."\t".$seq1."\t".$score.":".$len1."\n";

		if($len1>1)
		{
		print ALN $start."\t".$end."\t".$START."\t".$END."\t".$frame."\t".$seq."\t".$seq1."\t".$score.":".$len1."\n";
		}
	
		if (defined $S_SWP)
		{	
		alignment_extension($SWPSequence,$Frame1Sequence,$Frame2Sequence,$Frame3Sequence,$S_SWP,$E_SWP,$S_CC,$E_CC,$unalSt,$unalStSWP,$minKmer);
		}


	}


	
	
}
1;
