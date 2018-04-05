#!/usr/bin/perl
use strict;
use warnings;







			################
                        # MAIN PROGRAM #
                        ################

# ########################################################################         #
# Function:   Alignment of protein-coding gene against non-coding gene             #
#		DNA sequences is translated into amino acid sequences              #
#                                                                                  #
# IN:  LincRNA Ensembl ID and Swiss-Prot ID                                        #
# OUT: Alignment representation on console                                         #
#                                                                                  #
# COMMENT: Alignment representation FRAME1-RED,FRAME2-GREEN, FRAME3-BLUE           #
#	   Match are represented in uppercase and BOLD                    	   #  
#	   Mismatch are represnted in lowercase and Black color                    #
#	   Conserved and semiconserved residue in lowercase  with Frame Color	   #
# ################################################################################ #




no warnings 'uninitialized';
no warnings 'substr';
use Getopt::Long;
use List::MoreUtils qw(uniq);
use List::Util qw(first);

package main;
use code::DNAtoAAtranslation;
use code::fetsequence;
use code::perfectalignment;
use code::extendalignment;
use code::boundaryImprovement;
use code::visualizationscript;

my $num_args=$#ARGV+1;
if($num_args !=2)
{
print "Usage of Program: perl mainprogram.pl LincRNAID ProteinID\n";
exit;
}

#perl mainprogram.pl ../../../../DataFetchingCallingBstep/32ExampleslongFiles_New/P02792_ENST00000402635.fa 4 1 1 1 1 1 ../../../../DataFetchingCallingBstep/32ExampleslongFiles_New/P02792_ENST00000402635_DNAseq.fa 1 1


### command line inputs ###############

my $QueryID =$ARGV[0];
my $TargetID=$ARGV[1];


my $minReadlen=4;
my $printSeq=1;
my $printScore=1;
my $DNAPosition=1;
my $SWPPosition=1;
my $printDNASeq=1;

my $AAtoDNA=1;





my $QueryFile="data/LincRNASequences.fa";
my $TargetFile="data/ProteinSequences.fa";
my $SWP=fetsequence ($TargetID,$TargetFile);
my $QuerySeq=fetsequence ($QueryID,$QueryFile);

my ($FRAME1,$FRAME2,$FRAME3)=translation ($QuerySeq);

open (FF,">file.txt");
print FF $QueryID."\n";
print FF $QuerySeq."\n";
close FF;
my $DNAfile="file.txt";

open (ALN,">alignment.txt");


my $unalSt_CC=0;
my $unalSt_SWP=0;
perfect_alignment ($SWP,$FRAME1,$FRAME2,$FRAME3,$minReadlen,$unalSt_CC,$unalSt_SWP);
close (ALN);
bigInsertionSkip("alignment.txt");
ntdindex();
boundary_improvement($SWP,$FRAME1,$FRAME2,$FRAME3);
printSequence ($SWP,$FRAME1,$FRAME2,$FRAME3,"alignment.txt",$printSeq,$printScore,$DNAPosition,$SWPPosition,$printDNASeq,$DNAfile,$AAtoDNA);




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

sub conservedScore
{

	###################Scoring Matrix#############
	our %score_matrix=(
	'AA'=>1.33,'AR'=>-4,'AN'=>-4,'AD'=>0.03,'AC'=>-4,'AQ'=>-4,'AE'=>0.03,'AG'=>0.06,'AH'=>-4,'AI'=>-4,'AL'=>-4,'AK'=>-4,'AM'=>-4,'AF'=>-4,'AP'=>0.06,'AS'=>0.06,'AT'=>0.22,'AW'=>-4,'AY'=>-4,
	'AV'=>0.22,'A*'=>-4,'RA'=>-4,'RR'=>1.33,'RN'=>-4,'RD'=>-4,'RC'=>0.07,'RQ'=>0.07,'RE'=>-4,'RG'=>0.11,'RH'=>0.07,'RI'=>0.01,'RL'=>0.04,'RK'=>0.07,'RM'=>0.01,'RF'=>-4,'RP'=>0.04,'RS'=>0.06,'RT'=>0.02,
	'RW'=>0.05,'RY'=>-4,'RV'=>-4,'R*'=>0.05,'NA'=>-4,'NR'=>-4,'NN'=>1.22,'ND'=>0.22,'NC'=>-4,'NQ'=>-4,'NE'=>-4,'NG'=>-4,'NH'=>0.06,'NI'=>0.06,'NL'=>-4,'NK'=>0.11,'NM'=>-4,'NF'=>-4,'NP'=>-4,'NS'=>0.22,
	'NT'=>0.06,'NW'=>-4,'NY'=>0.06,'NV'=>-4,'N*'=>-4,'DA'=>0.06,'DR'=>-4,'DN'=>0.22,'DD'=>1.22,'DC'=>-4,'DQ'=>-4,'DE'=>0.11,'DG'=>0.22,'DH'=>0.06,'DI'=>-4,'DL'=>-4,'DK'=>-4,'DM'=>-4,'DF'=>-4,'DP'=>-4,
	'DS'=>-4,'DT'=>-4,'DW'=>-4,'DY'=>0.06,'DV'=>0.06,'D*'=>-4,'CA'=>-4,'CR'=>0.22,'CN'=>-4,'CD'=>-4,'CC'=>1.22,'CQ'=>-4,'CE'=>-4,'CG'=>0.06,'CH'=>-4,'CI'=>-4,'CL'=>-4,'CK'=>-4,'CM'=>-4,'CF'=>0.06,
	'CP'=>-4,'CS'=>0.11,'CT'=>-4,'CW'=>0.06,'CY'=>0.22,'CV'=>-4,'C*'=>0.06,'QA'=>-4,'QR'=>0.22,'QN'=>-4,'QD'=>-4,'QC'=>-4,'QQ'=>1.22,'QE'=>0.06,'QG'=>-4,'QH'=>0.11,'QI'=>-4,'QL'=>0.06,'QK'=>0.06,'QM'=>-4,
	'QF'=>-4,'QP'=>0.06,'QS'=>-4,'QT'=>-4,'QW'=>-4,'QY'=>-4,'QV'=>-4,'Q*'=>0.22,'EA'=>0.06,'ER'=>-4,'EN'=>-4,'ED'=>0.11,'EC'=>-4,'EQ'=>0.06,'EE'=>1.22,'EG'=>0.22,'EH'=>-4,'EI'=>-4,'EL'=>-4,'EK'=>0.22,
	'EM'=>-4,'EF'=>-4,'EP'=>-4,'ES'=>-4,'ET'=>-4,'EW'=>-4,'EY'=>-4,'EV'=>0.06,'E*'=>0.06,'GA'=>0.06,'GR'=>0.17,'GN'=>-4,'GD'=>0.11,'GC'=>0.03,'GQ'=>-4,'GE'=>0.11,'GG'=>1.33,'GH'=>-4,'GI'=>-4,'GL'=>-4,
	'GK'=>-4,'GM'=>-4,'GF'=>-4,'GP'=>-4,'GS'=>0.11,'GT'=>-4,'GW'=>0.01,'GY'=>-4,'GV'=>0.06,'G*'=>0.01,'HA'=>-4,'HR'=>0.22,'HN'=>0.06,'HD'=>0.06,'HC'=>-4,'HQ'=>0.11,'HE'=>-4,'HG'=>-4,'HH'=>1.22,'HI'=>-4,
	'HL'=>0.06,'HK'=>-4,'HM'=>-4,'HF'=>-4,'HP'=>0.06,'HS'=>-4,'HT'=>-4,'HW'=>-4,'HY'=>0.22,'HV'=>-4,'H*'=>-4,'IA'=>-4,'IR'=>0.02,'IN'=>0.04,'ID'=>-4,'IC'=>-4,'IQ'=>-4,'IE'=>-4,'IG'=>-4,'IH'=>-4,'II'=>1.22,
	'IL'=>0.07,'IK'=>0.02,'IM'=>0.11,'IF'=>0.04,'IP'=>-4,'IS'=>0.04,'IT'=>0.22,'IW'=>-4,'IY'=>-4,'IV'=>0.22,'I*'=>-4,'LA'=>-4,'LR'=>0.04,'LN'=>-4,'LD'=>-4,'LC'=>-4,'LQ'=>0.02,'LE'=>-4,'LG'=>-4,'LH'=>0.02,
	'LI'=>0.04,'LL'=>1.44,'LK'=>-4,'LM'=>0.02,'LF'=>0.11,'LP'=>0.15,'LS'=>0.07,'LT'=>-4,'LW'=>0.01,'LY'=>-4,'LV'=>0.06,'L*'=>0.03,'KA'=>-4,'KR'=>0.22,'KN'=>0.11,'KD'=>-4,'KC'=>-4,'KQ'=>0.06,'KE'=>0.22,
	'KG'=>-4,'KH'=>-4,'KI'=>0.03,'KL'=>-4,'KK'=>1.22,'KM'=>0.03,'KF'=>-4,'KP'=>-4,'KS'=>-4,'KT'=>0.06,'KW'=>-4,'KY'=>-4,'KV'=>-4,'K*'=>0.06,'MA'=>-4,'MR'=>0.06,'MN'=>-4,'MD'=>-4,'MC'=>-4,'MQ'=>-4,'ME'=>-4,
	'MG'=>-4,'MH'=>-4,'MI'=>0.33,'ML'=>0.11,'MK'=>0.06,'MM'=>1,'MF'=>-4,'MP'=>-4,'MS'=>-4,'MT'=>0.22,'MW'=>-4,'MY'=>-4,'MV'=>0.22,'M*'=>-4,'FA'=>-4,'FR'=>-4,'FN'=>-4,'FD'=>-4,'FC'=>0.06,'FQ'=>-4,'FE'=>-4,
	'FG'=>-4,'FH'=>-4,'FI'=>0.06,'FL'=>0.33,'FK'=>-4,'FM'=>-4,'FF'=>1.22,'FP'=>-4,'FS'=>0.22,'FT'=>-4,'FW'=>-4,'FY'=>0.06,'FV'=>0.06,'F*'=>-4,'PA'=>0.06,'PR'=>0.06,'PN'=>-4,'PD'=>-4,'PC'=>-4,'PQ'=>0.03,
	'PE'=>-4,'PG'=>-4,'PH'=>0.03,'PI'=>-4,'PL'=>0.22,'PK'=>-4,'PM'=>-4,'PF'=>-4,'PP'=>1.33,'PS'=>0.22,'PT'=>0.06,'PW'=>-4,'PY'=>-4,'PV'=>-4,'P*'=>-4,'SA'=>0.04,'SR'=>0.06,'SN'=>0.07,'SD'=>-4,'SC'=>0.04,
	'SQ'=>-4,'SE'=>-4,'SG'=>0.07,'SH'=>-4,'SI'=>0.02,'SL'=>0.07,'SK'=>-4,'SM'=>-4,'SF'=>0.07,'SP'=>0.15,'SS'=>1.3,'ST'=>0.06,'SW'=>0.01,'SY'=>0.02,'SV'=>-4,'S*'=>0.03,'TA'=>0.22,'TR'=>0.03,'TN'=>0.03,
	'TD'=>-4,'TC'=>-4,'TQ'=>-4,'TE'=>-4,'TG'=>-4,'TH'=>-4,'TI'=>0.17,'TL'=>-4,'TK'=>0.03,'TM'=>0.06,'TF'=>-4,'TP'=>0.06,'TS'=>0.08,'TT'=>1.33,'TW'=>-4,'TY'=>-4,'TV'=>-4,'T*'=>-4,'WA'=>-4,'WR'=>0.28,
	'WN'=>-4,'WD'=>-4,'WC'=>0.11,'WQ'=>-4,'WE'=>-4,'WG'=>0.06,'WH'=>-4,'WI'=>-4,'WL'=>0.06,'WK'=>-4,'WM'=>-4,'WF'=>-4,'WP'=>-4,'WS'=>0.06,'WT'=>-4,'WW'=>1,'WY'=>-4,'WV'=>-4,'W*'=>0.44,'YA'=>-4,'YR'=>-4,
	'YN'=>0.06,'YD'=>0.06,'YC'=>0.22,'YQ'=>-4,'YE'=>-4,'YG'=>-4,'YH'=>0.22,'YI'=>-4,'YL'=>-4,'YK'=>-4,'YM'=>-4,'YF'=>0.06,'YP'=>-4,'YS'=>0.06,'YT'=>-4,'YW'=>-4,'YY'=>1.22,'YV'=>-4,'Y*'=>0.11,'VA'=>0.22,
	'VR'=>-4,'VN'=>-4,'VD'=>0.03,'VC'=>-4,'VQ'=>-4,'VE'=>0.03,'VG'=>0.06,'VH'=>-4,'VI'=>0.17,'VL'=>0.08,'VK'=>-4,'VM'=>0.06,'VF'=>0.03,'VP'=>-4,'VS'=>-4,'VT'=>-4,'VW'=>-4,'VY'=>-4,'VV'=>1.33,'V*'=>-4,
	'*A'=>-4,'*R'=>-4,'*N'=>-4,'*D'=>-4,'*C'=>-4,'*Q'=>-4,'*E'=>-4,'*G'=>-4,'*H'=>-4,'*I'=>-4,'*L'=>-4,'*K'=>-4,'*M'=>-4,'*F'=>-4,'*P'=>-4,'*S'=>-4,'*T'=>-4,'*W'=>-4,'*Y'=>-4,'*V'=>-4,'**'=>-4
	);
	my $SWP1=$_[0];my $FrameSeq=$_[1];my $startSWP=$_[2]; my $endSWP=$_[3]; my $startCC=$_[4];my $endCC=$_[5]; my $frame=$_[6];
	my @SWP=split("",$SWP1); my @FRAME1=split("",$FrameSeq);
	
	##############################################
	my $score=0;		
	my $count = $startCC-2;
	####### upstream extension#########
	for (my $k=$startSWP-2; $k>=0; $k--)
	{
		my $SWP_aa = $SWP[$k];
		my $Frame_aa= $FRAME1[$count];
		my $char=$SWP_aa.$Frame_aa;
		#print $char."\t".$count."\t".$k."\n";
		if((length ($char)==2)&&($k>=0)&&($count>=0))
		{
			if ($score_matrix{$char}>=0)
			{	
				$score=$score+$score_matrix{$char};
				$startSWP=$startSWP-1;
				$startCC=$startCC-1;
			}
			else
			{
			last;
			}
		}
		else
		{
		last;
		}
		$count--;
	}

	#######downstream extension#########
	my $count2=$endCC;
	for (my $k=$endSWP; $k<=$#SWP; $k++)
	{
				
		my $SWP_aa = $SWP[$k];
		my $Frame_aa= $FRAME1[$count2];
		my $char=$SWP_aa.$Frame_aa;
		if(length($char)==2)
		{
			if ($score_matrix{$char}>=0)
			{
			$score=$score+$score_matrix{$char};
			$endCC=$endCC+1;
			$endSWP=$endSWP+1;
			}
			else
			{
			last;
			}
		}
		else
		{
		last;
		}
		$count2++;
	}
	my $length=$endSWP-$startSWP+1;
	#print "Score\t".$length."\t".$score,"\t".$startSWP."\t".$endSWP."\t".$startCC."\t".$endCC."\n";
	return ($length,$score,$startSWP,$endSWP,$startCC,$endCC,$frame);
	
}


sub seqScore
{
	###################Scoring Matrix#############
	our %score_matrix=('AV' => 0.22,'AT' => 0.22,'AS' => 0.06,'AP' => 0.06,'AG' => 0.06,'AD' => 0.03,'AE' => 0.03,'RG' => 0.11,'RH' => 0.07,'RK' => 0.07,'RQ' => 0.07,'RC' => 0.07,
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
	'VM' => 0.06,'VG' => 0.06,'VE' => 0.03,'VD' => 0.03,'VF' => 0.03
	);
	my $seq=$_[0];my $seq2=$_[1];
	my @s1=split("",$seq);my @s2=split("",$seq2);
	my $score=0;
	for (my $i=0;$i<=$#s1;$i++)
	{
		if($s1[$i] eq $s2[$i])
		{
		$score=$score+1;
		}
		else
		{
			my $char=$s1[$i].$s2[$i];
			if (exists $score_matrix{$char})
			{
				$score=$score+$score_matrix{$char};
			}
			else
			{
			last;
			}
		}
	}
	return $score;

}

sub ntdindex
{

	open (my $data , '<', "alignment.txt")|| die "could not open $ARGV[0]:\n$!";
	my @array=(<$data>);
	my @alignments=sort {(split(/\t/,$a))[0]<=>(split(/\t/,$b))[0]} @array;
	
	
	for (my $i=0;$i<$#alignments;$i++)
	{	
		my $E1=0;my $frame1="";my $score1=0;
		if ($alignments[$i]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
		{
		$E1=$4;$frame1=$5;
		if($8 =~m/(.*)\:(.*)/){$score1=$1;}
		}

		open (my $data , '<', "alignment.txt")|| die "could not open $ARGV[0]:\n$!";
		my @array=(<$data>);
		my @file=sort {(split(/\t/,$a))[1]<=>(split(/\t/,$b))[1]} @array;
		
		if ($alignments[$i+1]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
		{
			#print $alignments[$i]."\n";
			my $frame2=$5;my $score2=0; my $S1=$3;
			if($8 =~m/(.*)\:(.*)/){$score2=$1;}
			if(($frame1 ne $frame2) && ($E1 == ($S1-1)))
			{
				if(($frame1 eq 'F1') && ($frame2 eq 'F2'))
				{
					#print $score1."\t".$score2."\n";
					if($score1 >= $score2)
					{
					######### F1 --> F2 is downstream of F1 (No change)
					#print $file[$i+1]."\n";
					}
					else
					{
					######### F2 -->F1 is upstream of F2 (No change)
					#print $file[$i]."\n";
					}
				}
				elsif(($frame1 eq 'F1') && ($frame2 eq 'F3'))
				{
					#print $score1."\t".$score2."\n";
					if($score1 >= $score2)
					{
					#########  F1 --> F3 is downstream of F1 (No change)
					#print $file[$i+1]."\n";
					}
					else
					{
					#########  F3 --> F1 is upstream of F3 (No change)
					#print $file[$i]."\n";
					}
				}
				elsif(($frame1 eq 'F2') && ($frame2 eq 'F1'))
				{
					#print $score1."\t".$score2."\n";
					if($score1 >= $score2)
					{
					#########  F2 ---> F1 is downstream of F2  
					#print $file[$i+1]."\n";#(start + 1);
						if ($file[$i+1]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
						{
						my $seq1=substr($6,1,length($7));
						my $seq2=substr($7,1,length($7));
						my $Replace=($1+1)."\t".$2."\t".($3+1)."\t".$4."\t".$5."\t".$seq1."\t".$seq2."\t".length($seq1).":".length($seq1);
						my $AL=$1."\t".$2."\t".$3."\t".$4."\t(.*)\t(.*)\t(.*)\t(.*)";
						editfile($AL,$Replace,"alignment.txt");
						}
					}
					else
					{
					######### F1 ---> F2 is upstream of F1
					#print $file[$i]."\n"; #(End -1);
						if ($file[$i]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
						{
						my $seq1=substr($6,0,length($7)-1);
						my $seq2=substr($7,0,length($7)-1);
						my $Replace=$1."\t".($2-1)."\t".$3."\t".($4-1)."\t".$5."\t".$seq1."\t".$seq2."\t".length($seq1).":".length($seq1);
						my $AL=$1."\t".$2."\t".$3."\t".$4."\t(.*)\t(.*)\t(.*)\t(.*)";
						editfile($AL,$Replace,"alignment.txt");
						}
					}

				}
				elsif(($frame1 eq 'F2') && ($frame2 eq 'F3'))
				{
					if($score1 >= $score2)
					{
					######### F2  ----> F3 is downstream of F2 (No change)
					#print $file[$i+1]."\n";
					}
					else
					{
					######### F3 ---> F2 is upstream of F3 (No change)
					#print file[$i]."\n";
					}
				}
				elsif(($frame1 eq 'F3') && ($frame2 eq 'F1'))
				{
					if($score1 >= $score2)
					{
					######### F3 ---> F1 is downstream of F3
					#print $file[$i+1]."\n"; (start +1)
						if ($file[$i+1]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
						{
						my $seq1=substr($6,1,length($7));
						my $seq2=substr($7,1,length($7));
						my $Replace=($1+1)."\t".$2."\t".($3+1)."\t".$4."\t".$5."\t".$seq1."\t".$seq2."\t".length($seq1).":".length($seq1);
						my $AL=$1."\t".$2."\t".$3."\t".$4."\t(.*)\t(.*)\t(.*)\t(.*)";
						editfile($AL,$Replace,"alignment.txt");
						}
					}
					else
					{
					######### F1 ---> F3 is upstream of F1
					#print $file[$i]."\n"; (End -1)
						if ($file[$i]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
						{
						my $seq1=substr($6,0,length($7)-1);
						my $seq2=substr($7,0,length($7)-1);
						my $Replace=$1."\t".($2-1)."\t".$3."\t".($4-1)."\t".$5."\t".$seq1."\t".$seq2."\t".length($seq1).":".length($seq1);
						my $AL=$1."\t".$2."\t".$3."\t".$4."\t(.*)\t(.*)\t(.*)\t(.*)";
						editfile($AL,$Replace,"alignment.txt");
						}
					}
			
				}
				elsif(($frame1 eq 'F3') && ($frame2 eq 'F2'))
				{
					if($score1 >= $score2)
					{
					######### F3 ----> F2 is downstream of F3
					#print $file[$i+1]."\n"; (start +1)
						if ($file[$i+1]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
						{
						my $seq1=substr($6,1,length($7));
						my $seq2=substr($7,1,length($7));
						my $Replace=($1+1)."\t".$2."\t".($3+1)."\t".$4."\t".$5."\t".$seq1."\t".$seq2."\t".length($seq1).":".length($seq1);
						my $AL=$1."\t".$2."\t".$3."\t".$4."\t(.*)\t(.*)\t(.*)\t(.*)";
						editfile($AL,$Replace,"alignment.txt");
						}
					}
					else
					{
					######### F2 ----> F3 is upstream of F2
					#print $file[$i]."\n"; (End -1)
						if ($file[$i]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
						{
						my $seq1=substr($6,0,length($7)-1);
						my $seq2=substr($7,0,length($7)-1);
						my $Replace=$1."\t".($2-1)."\t".$3."\t".($4-1)."\t".$5."\t".$seq1."\t".$seq2."\t".length($seq1).":".length($seq1);
						my $AL=$1."\t".$2."\t".$3."\t".$4."\t(.*)\t(.*)\t(.*)\t(.*)";
						editfile($AL,$Replace,"alignment.txt");
						}
					}
				}			
			}
		}
	}
}

unlink('file.txt') or die "Could not delete the file!\n";
unlink('alignment.txt') or die "Could not delete the file!\n";

