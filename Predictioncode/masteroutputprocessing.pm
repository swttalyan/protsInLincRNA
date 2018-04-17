#!/usr/bin/perl
use warnings;
use strict;
no warnings 'uninitialized';
no warnings 'numeric';

sub masteroutputprocessing
{

	my $Query=$_[0];my $Target=$_[1];my $QuerySeq=$_[2];my $TargetSeq=$_[3];my $fileIN=$_[4];
	##################### Substitution Matrix #########################
	my %substitution_matrix= ('AV' => 0.22,'AT' => 0.22,'AS' => 0.06,'AP' => 0.06,'AG' => 0.06,'AD' => 0.03,'AE' => 0.03,'RG' => 0.11,'RH' => 0.07,'RK' => 0.07,'RQ' => 0.07,'RC' => 0.07,
	'RS' => 0.06,'RW' => 0.05,'R*' => 0.05,'RP' => 0.04,'RL' => 0.04,'RT' => 0.02,'RI' => 0.01,'RM' => 0.01,'ND' => 0.22,'NS' => 0.22,'NK' => 0.11,'NH' => 0.06,'NT' => 0.06,
	'NI' => 0.06,'NY' => 0.06,'DG' => 0.22,'DN' => 0.22,'DE' => 0.11,'DH' => 0.06,'DY' => 0.06,'DA' => 0.06,'DV' => 0.06,'CY' => 0.22,'CR' => 0.22,'CS' => 0.11,'CG' => 0.06,
	'C*' => 0.06,'CW' => 0.06,'CF' => 0.06,'QR' => 0.22,'Q*' => 0.22,'QH' => 0.11,'QL' => 0.06,'QK' => 0.06,'QP' => 0.06,'QE' => 0.06,'EK' => 0.22,'EG' => 0.22,'ED' => 0.11,
	'EV' => 0.06,'EA' => 0.06,'EQ' => 0.06,'E*' => 0.06,'GR' => 0.17,'GS' => 0.11,'GE' => 0.11,'GD' => 0.11,'GA' => 0.06,'GV' => 0.06,'GC' => 0.03,'G*' => 0.01,'GW' => 0.01,
	'HR' => 0.22,'HY' => 0.22,'HQ' => 0.11,'HN' => 0.06,'HP' => 0.06,'HD' => 0.06,'HL' => 0.06,'IV' => 0.22,'IT' => 0.22,'IM' => 0.11,'IL' => 0.07,'IF' => 0.04,'IN' => 0.04,
	'IS' => 0.04,'IK' => 0.02,'IR' => 0.02,'LP' => 0.15,'LF' => 0.11,'LS' => 0.07,'LV' => 0.06,'LI' => 0.04,'LR' => 0.04,'L*' => 0.03,'LM' => 0.02,'LH' => 0.02,'LQ' => 0.02,
	'LW' => 0.01,'KE' => 0.22,'KR' => 0.22,'KN' => 0.11,'K*' => 0.06,'KQ' => 0.06,'KT' => 0.06,'KI' => 0.03,'KM' => 0.03,'MI' => 0.33,'MV' => 0.22,'MT' => 0.22,'ML' => 0.11,
	'MR' => 0.06,'MK' => 0.06,'FL' => 0.33,'FS' => 0.22,'FC' => 0.06,'FY' => 0.06,'FI' => 0.06,'FV' => 0.06,'PL' => 0.22,'PS' => 0.22,'PA' => 0.06,'PR' => 0.06,'PT' => 0.06,
	'PQ' => 0.03,'PH' => 0.03,'SP' => 0.15,'SG' => 0.07,'SF' => 0.07,'SL' => 0.07,'SN' => 0.07,'SR' => 0.06,'ST' => 0.06,'SC' => 0.04,'SA' => 0.04,'S*' => 0.03,'SY' => 0.02,
	'SI' => 0.02,'SW' => 0.01,'TA' => 0.22,'TI' => 0.17,'TS' => 0.08,'TM' => 0.06,'TP' => 0.06,'TK' => 0.03,'TN' => 0.03,'TR' => 0.03,'W*' => 0.44,'WR' => 0.28,'WC' => 0.11,
	'WS' => 0.06,'WG' => 0.06,'WL' => 0.06,'YC' => 0.22,'YH' => 0.22,'Y*' => 0.11,'YN' => 0.06,'YF' => 0.06,'YS' => 0.06,'YD' => 0.06,'VA' => 0.22,'VI' => 0.17,'VL' => 0.08,
	'VM' => 0.06,'VG' => 0.06,'VE' => 0.03,'VD' => 0.03,'VF' => 0.03,'AA' => 0.33,'RR' => 0.33,'NN' => 0.22,'DD' => 0.22,'CC' => 0.22,'QQ' => 0.22,'EE' => 0.22,'GG' => 0.33,'HH' => 0.22,'II' => 0.22,
	'LL' => 0.44,'KK' => 0.22,'MM' => 0.00,'FF' => 0.22,'PP' => 0.33,'SS' => 0.30,'TT' => 0.33,'WW' => 0.00,'YY' => 0.22,'VV' => 0.33
	);
	##################### Substitution Matrix #########################	

	
	#open (FHH,">>Test_StepB.txt");
	#print FHH "Pseudogene\tSwissProtPg\tLengthofAlignment\tNumberofPerfectMatch\tTimetoExecutetheProgram\n";
	#print $Query."\t".$Target."\t".."\t";
	open (my $data , $fileIN)|| die "could not open $ARGV[0]:\n$!";
	my @array=(<$data>);
	my @alignments=sort {(split(/\t/,$a))[0]<=>(split(/\t/,$b))[0]} @array;
	
	if(@alignments>0)
	{
			
		#my $start=0;my $end=0;
		my $match=0; my $cons=0;my $semicons=0;my $mismatch=0;my $gaps=0;my $score=0;
		############## for aligned part
		foreach my $aln (@alignments)
		{
			chomp $aln;
			if($aln=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
			{
				my @aln1=split("",$6);my @aln2=split("",$7);
				for(my $i=0;$i<=$#aln1;$i++)
				{
					my $char=$aln1[$i].$aln2[$i];
					if ($aln1[$i] eq $aln2[$i])
					{
					$match=$match+1;
					$score=$score+$substitution_matrix{$char}+1;
					}
					else
					{
					
					if(exists $substitution_matrix{$char})
					{
						if($substitution_matrix{$char}>=0.10)
						{
						$cons=$cons+1;
						}
						else
						{
						$semicons=$semicons+1;
						} 
					$score=$score+$substitution_matrix{$char};
					}
					else
					{
					$mismatch=$mismatch+1;
					$score=$score-4;
					}
				}
			}
		}
	}		
	############## for unaligned part
	for(my $k=0;$k<=$#alignments;$k++)
	{
		my $SWP_end=0; my $CC_end=0;
		############ this is for the begining of the alignment #################
		if ($alignments[$k]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
		{
		$SWP_end=$2;$CC_end=$4;	
		}

		############ this is what happening inbetween the alignment #################
		if ($alignments[$k+1]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
		{
			#### conditions for the first situations ###############3		
			if((($SWP_end+1) ==$1) && (($CC_end+1)==$3))
			{
			}
			if((($SWP_end+1) < $1) && (($CC_end+1) == $3))
			{
			my $startS=$SWP_end+1;my $endS=$1-1;my $lenS=$endS-$startS+1;
			$gaps=$gaps+$lenS;
			$score=$score+(-10*$lenS);
			}
			if((($SWP_end+1) == $1) && (($CC_end+1)<$3))
			{
			my $startC=$CC_end+1;my $endC=$3-1;my $lenC=$endC-$startC+1;
			$mismatch=$mismatch+$lenC;
			$score=$score+(-4*$lenC);
			}
			#### from here the second situation starts ############
			if((($SWP_end+1) < $1) && (($CC_end+1) < $3))
			{
				if(($1-($SWP_end+1)) == ($3-($CC_end+1)))
				{
				my $startS=$SWP_end+1;my $endS=$1-1;my $startC=$CC_end+1;my $endC=$3-1;
				my $lenC=$endC-$startC+1;
				$mismatch=$mismatch+$lenC;
				$score=$score+(-4*$lenC);
				}			
				if(($1-($SWP_end+1)) > ($3-($CC_end+1)))
				{
				my $startS=$SWP_end+1;my $endS=$1-1;my $startC=$CC_end+1;my $endC=$3-1;
				my $lenC=$endC-$startC+1; my $lenS=$endS-$startS+1;my $diff=$lenS-$lenC;
				$gaps=$gaps+$diff;
				$score=$score+(-10*$diff);
				$mismatch=$mismatch+$lenC;
				$score=$score+(-4*$lenC);
				}
				if(($1-($SWP_end+1)) < ($3-($CC_end+1)))
				{
				my $startS=$SWP_end+1;my $endS=$1-1;my $startC=$CC_end+1;my $endC=$3-1;
				my $lenC=$endC-$startC+1; my $lenS=$endS-$startS+1;my $diff=$lenC-$lenS;
				$mismatch=$mismatch+$lenC;
				$score=$score+(-4*$lenC);
				}
			}
		}
	}
	my $swpSTART=0; my $ccSTART=0;
	if ($alignments[0]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
	{
	$swpSTART=$1;
		if($5 eq 'F1'){$ccSTART=(($3)*3)-2;}
		if($5 eq 'F2'){$ccSTART=(($3)*3)-1;}
		if($5 eq 'F3'){$ccSTART=(($3)*3);}
	}
	my $swpEND=0; my $ccEND=0;
	if ($alignments[-1]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
	{
	$swpEND=$2;
	
		if($5 eq 'F1'){$ccEND=(($4)*3);}
		if($5 eq 'F2'){$ccEND=(($4)*3)+1;}
		if($5 eq 'F3'){$ccEND=(($4)*3)+2;}
	
	}
	my $Length=$match+$gaps+$cons+$semicons+$mismatch;$score=sprintf "%.2f",$score;my $PID=sprintf "%.2f",$match/$Length*100;
	$Query=~s/>//; $Target=~s/>//;
	print $Query."\t".$Target."\t".$Length."\t".$PID."\t".$match.":".$cons.":".$semicons."\t".$ccSTART."\t".$ccEND."\t".$swpSTART."\t".$swpEND."\n";
	#print FHH $Length."\t".$match."\t".$cons."\t".$semicons."\t".$mismatch."\t".$gaps."\t".$score."\t";
	}

}
1;
