use warnings;
package main;
use Term::ANSIColor;
no warnings 'uninitialized';
no warnings 'numeric';
use List::MoreUtils qw(uniq);




			#############
                        # FUNCTIONS #
                        #############

# ######################################################################## #
# Function:   Coloring the Sequences to print on console based on match    #
#		mismatch, cons and gaps.                                   #
#                                                                          #
# IN:  nothing                                                             #
# OUT: nothing                                                             #
#                                                                          #
# COMMENT: Match uppercase BOLD for FRAME1-RED,FRAME2-GREEN, FRAME3-BLUE   #
#	   Mismatch Uppercase  Black color                                 #
#	   Cons Lowercase  for FRAME1-RED,FRAME2-GREEN, FRAME3-BLUE	   #
# ######################################################################## #

sub printSequence
{

	my $SWP=$_[0];chomp ($SWP);
	my $f1=$_[1];chomp ($f1);
	my $f2=$_[2];chomp ($f2);
	my $f3=$_[3];chomp ($f3);
	my $AlignedFile=$_[4];
	my $printSeq=$_[5];
	my $printScore=$_[6];
	my $DNAPosition=$_[7];
	my $SWPPosition=$_[8];
	my $printDNASeq=$_[9];
	my $DNAfile=$_[10];
	my $AAtoDNA=$_[11];

	my $string1=`sort -k1,1n $AlignedFile`;
	my @file2=split("\n",$string1);
	my $SWP_length= length ($SWP); my $F_length= length ($f1);


	#print "SWP_length= ".$SWP_length."\n";

	#print $SWP."\n".$f1."\n".$f2."\n".$f3."\n";
	
	open (SP,">SWP_alignment.txt");
	open (CC,">CC_alignment.txt");

	############ this is for the begining of the alignment #################
	if ($file2[0]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
	{
		
		if(($1 == 1)&& ($3 == 1))
		{
		}
		my $startS=1; my $endS=$1-1;my $startC=1;my $endC=$3-1;
			if(($endS == $endC))
			{
			my $s1=substr($SWP,$startS-1,$endS-$startS+1); 
			print SP $startS."\t".$endS."\tUnaligned\tNone\tNone\t".$s1."\n";
			my $lenC=$endC-$startC+1;my $s=("x" x $lenC);
			print CC $startC."\t".$endC."\tUnaligned\tNone\tNone\t".$s."\n";
			}
			else
			{
				if($endC>$endS)
				{
				my $lenC=$endC-$startC+1;my $lenS=$endS-$startS+1;
				my $s= ("x" x $lenC);
				print CC $startC."\t".$endC."\tUnaligned\tNone\tNone\t".$s."\n";
				my $diff=$lenC-$lenS;
				my $s1=substr($SWP,$startS-1,$endS-$startS+1).("-" x $diff);
				print SP $startS."\t".$endS."\tUnaligned\tNone\tNone\t".$s1."\n";
				}
				if($endC<$endS)
				{
				my $lenS=$endS-$startS+1;my $lenC=$endC-$startC+1;
				my $s1=substr($SWP,$startS-1,$endS-$startS+1);
				print  SP "1\t".$endS."\tUnaligned\tNone\tNone\t".$s1."\n";
				my $diff=$lenS-$lenC;
				my $s=("x" x $lenC).("-" x $diff);
				print CC $startC."\t".$endC."\tUnaligned\tNone\tNone\t".$s."\n";
				}
			}
		
		
	}
	
	for(my $k=0;$k<=$#file2;$k++)
	{
		
		my $SWP_end=0; my $CC_end=0;

		############ this is for the begining of the alignment #################
		if ($file2[$k]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
		{
			print SP $1."\t".$2."\tAligned\t".$5."\t".$6."\t".$7."\n";
			print CC $3."\t".$4."\tAligned\t".$5."\t".$6."\t".$7."\n";
			$SWP_end=$2;$CC_end=$4;	
		}

		############ this is what happening inbetween the alignment #################
		if ($file2[$k+1]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
		{
			#### conditions for the first situations ###############3		
			if((($SWP_end+1) ==$1) && (($CC_end+1)==$3))
			{
			}
			if((($SWP_end+1) < $1) && (($CC_end+1) == $3))
			{
			my $startS=$SWP_end+1;my $endS=$1-1;my $lenS=$endS-$startS+1;
			my $s=("-" x $lenS);
			print CC $CC_end."\t".$CC_end."\tUnaligned\tNone\tNone\t".$s."\n";
			my $s1=substr($SWP,$startS-1,$endS-$startS+1);
			print SP $SWP_end."\t".$SWP_end."\tUnaligned\tNone\tNone\t".$s1."\n";
			}
			if((($SWP_end+1) == $1) && (($CC_end+1)<$3))
			{
			my $startC=$CC_end+1;my $endC=$3-1;my $lenC=$endC-$startC+1;
			my $s= ("x" x $lenC);
			print CC $CC_end."\t".$CC_end."\tUnaligned\tNone\tNone\t".$s."\n";
			my $s1=("-" x $lenC);
			print SP $SWP_end."\t".$SWP_end."\tUnaligned\tNone\tNone\t".$s1."\n";
			}
			


			#### from here the second situation starts ############

			if((($SWP_end+1) < $1) && (($CC_end+1) < $3))
			{
				if(($1-($SWP_end+1)) == ($3-($CC_end+1)))
				{
				my $startS=$SWP_end+1;my $endS=$1-1;my $startC=$CC_end+1;my $endC=$3-1;
				my $s1=substr($SWP,$startS-1,$endS-$startS+1);
				print SP $startS."\t".$endS."\tUnaligned\tNone\tNone\t".$s1."\n";
				my $lenC=$endC-$startC+1;my $s=("x" x $lenC);
				print CC $startC."\t".$endC."\tUnaligned\tNone\tNone\t".$s."\n";
				}			
				if(($1-($SWP_end+1)) > ($3-($CC_end+1)))
				{
				my $startS=$SWP_end+1;my $endS=$1-1;my $startC=$CC_end+1;my $endC=$3-1;
				my $lenC=$endC-$startC+1; my $lenS=$endS-$startS+1;my $diff=$lenS-$lenC;
				my $s=substr($SWP,$startS-1,$endS-$startS+1);			
				print SP $startS."\t".$endC."\tUnaligned\tNone\tNone\t".$s."\n";
				my $s1=("x" x $lenC).("-" x $diff);
				print CC $startC."\t".$endC."\tUnaligned\tNone\tNone\t".$s1."\n";
				}
				if(($1-($SWP_end+1)) < ($3-($CC_end+1)))
				{
				my $startS=$SWP_end+1;my $endS=$1-1;my $startC=$CC_end+1;my $endC=$3-1;
				my $lenC=$endC-$startC+1; my $lenS=$endS-$startS+1;my $diff=$lenC-$lenS;
				my $s=("x" x $lenC);
				print CC $startC."\t".$endC."\tUnaligned\tNone\tNone\t".$s."\n";
				my $s1=substr($SWP,$startS-1,$endS-$startS+1).("-" x $diff);
				print SP $startS."\t".$endS."\tUnaligned\tNone\tNone\t".$s1."\n";
				}
			
			}
		}

	}
	if ($file2[$#file2]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
	{
		
	my $startS=$2+1;my $endS=$SWP_length;my $startC=$4+1;my $endC=$F_length;
	my $lenC=$endC-$startC+1;my $lenS=$endS-$startS+1;
		if ((($2) == $endS) && (($4)==$endC))
		{
		}
		else
		{
			if($lenS == $lenC)
			{
			my $s1=substr($SWP,$startS-1,$SWP_length);
			print SP $startS."\t".$endS."\tUnaligned\tNone\tNone\t".$s1."\n";
			my $s=("x" x $lenC);
			print CC $startC."\t".$endC."\tUnaligned\tNone\tNone\t".$s."\t";
			}
			else
			{				
				if($lenC>$lenS)
				{
				my $s= ("x" x $lenC);
				print CC $startC."\t".$endC."\tUnaligned\tNone\tNone\t".$s."\n";
				my $diff=$lenC-$lenS;my $s1=substr($SWP,$startS-1,$endS-$startS+1).("-" x $diff);
				print SP $startS."\t".$endS."\tUnaligned\tNone\tNone\t".$s1."\n";
				}
				elsif((length($f1)-$4)<(length($SWP)-$2))
				{
				my $s1=substr($SWP,$startS-1,$SWP_length);
				print SP $startS."\t".$endS."\tUnaligned\tNone\tNone\t".$s1."\n";
				my $diff=$lenS-$lenC;my $s= ("x" x $lenC).("-" x $diff);
				print CC $startC."\t".$endC."\tUnaligned\tNone\tNone\t".$s."\n";
				}
			}
		}	
		
	}
	

	###################Scoring Matrix#############
	my %substitution_matrix=('AV' => 0.22,'AT' => 0.22,'AS' => 0.06,'AP' => 0.06,'AG' => 0.06,'AD' => 0.03,'AE' => 0.03,'RG' => 0.11,'RH' => 0.07,'RK' => 0.07,'RQ' => 0.07,'RC' => 0.07,
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

	my $stringSWP1=`sort -k1,1n SWP_alignment.txt`;
	my @positionsSWP=split("\n",$stringSWP1);
	my $stringCC1=`sort -k1,1n  CC_alignment.txt`;
	my @positionsCC=split("\n",$stringCC1);
	################ for priting SwissProt Sequence ################
	#print "\nSwissProt Seq  \t: ";

	my $SWPstring1=""; my $stringALN=""; my $CCstring1=""; my $stringCOL="";my $stringCase="";my $coordinates=0;
	foreach  my $line (@positionsSWP)
	{
	#SWPstart	SWPend	alignYN	Frame	SWPseq	FFseq
		if($line =~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
		{
			if((defined $1) && (defined $2) && (defined $3)  && (defined $4) && (defined $5) && (defined $6))
			{
				#print $line."\n";
				if ($3 eq 'Aligned')
				{
					my @seq1=split("",$5);my @seq2=split("",$6);
					for(my $i=0;$i<=$#seq1;$i++)
					{
						#print $seq1[$i]."\t".$seq2[$i]."\n";
						if($4 eq 'F1')
						{
							if ($seq1[$i] eq $seq2[$i])
							{
							$SWPstring1= $SWPstring1.$seq1[$i];
							$stringCOL=$stringCOL."R";
							$stringCase=$stringCase."U";
							}
							else
							{
								my $char=$seq1[$i].$seq2[$i];
								if(exists $substitution_matrix{$char})
								{
								$SWPstring1= $SWPstring1.$seq1[$i];
								$stringCOL=$stringCOL."R";
								$stringCase=$stringCase."L";
								}
								else
								{
								$SWPstring1= $SWPstring1.$seq1[$i];
								$stringCOL=$stringCOL."A";
								$stringCase=$stringCase."L";
								}
							}							
						}
						if($4 eq 'F2')
						{
							if ($seq1[$i] eq $seq2[$i])
							{
							$SWPstring1= $SWPstring1.$seq1[$i];
							$stringCOL=$stringCOL."G";
							$stringCase=$stringCase."U";
							}
							else
							{
								my $char=$seq1[$i].$seq2[$i];
								if(exists $substitution_matrix{$char})
								{
								$SWPstring1= $SWPstring1.$seq1[$i];
								$stringCOL=$stringCOL."G";
								$stringCase=$stringCase."L";
								}
								else
								{
								$SWPstring1= $SWPstring1.$seq1[$i];
								$stringCOL=$stringCOL."A";
								$stringCase=$stringCase."L";
								}
							}							
						}
						if($4 eq 'F3')
						{
							if ($seq1[$i] eq $seq2[$i])
							{
							$SWPstring1= $SWPstring1.$seq1[$i];
							$stringCOL=$stringCOL."B";
							$stringCase=$stringCase."U";
							}
							else
							{
								my $char=$seq1[$i].$seq2[$i];
								if(exists $substitution_matrix{$char})
								{
								$SWPstring1=$SWPstring1.$seq1[$i];
								$stringCOL=$stringCOL."B";
								$stringCase=$stringCase."L";
								}
								else
								{
								$SWPstring1= $SWPstring1.$seq1[$i];
								$stringCOL=$stringCOL."A";
								$stringCase=$stringCase."L";
								}
							}	
						}
					}
				}
				if ($3 eq 'Unaligned')
				{
					my @s=split("",$6);
					for (my $j=0;$j<=$#s;$j++)
					{
					$SWPstring1= $SWPstring1.$s[$j];
					$stringCOL=$stringCOL."A";
					$stringCase=$stringCase."L";
					}
				}
			}
		}
	}
	foreach  my $line (@positionsSWP)
	{
		if($line =~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
		{
			if((defined $1) && (defined $2) && (defined $3)  && (defined $4) && (defined $5) && (defined $6))
			{
				my @seq1=split("",$5);my @seq2=split("",$6);
				if ($3 eq 'Aligned')
				{
					for(my $i=0;$i<=$#seq1;$i++)
					{
						if ($seq1[$i] eq $seq2[$i])
						{
						$stringALN=$stringALN."|";
						}
						else
						{
							my $char=$seq1[$i].$seq2[$i];
							if(exists $substitution_matrix{$char})
							{
								if($substitution_matrix{$char}>=0.10)
								{
								$stringALN=$stringALN.":";
								}
								else
								{
								$stringALN=$stringALN.".";
								}
							}
							else
							{
							$stringALN=$stringALN." ";
							}
						}
					}
				}
				if ($3 eq 'Unaligned')
				{
				my $len=length $6;
				my $s .= (" " x $len);
				$stringALN=$stringALN.$s;
				}
			}
		}

	}


		#print "\nAligned Seq\t: ";
	for ( my $line=0;$line<=$#positionsCC;$line++)
	{
		if($positionsCC[$line] =~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
		{
			my $stS=$1;
			if((defined $1) && (defined $2) && (defined $3)  && (defined $4) && (defined $5) && (defined $6))
			{
				
				#print $line."\n";
				
				if ($3 eq 'Aligned')
				{
				 	my @seq1=split("",$5);my @seq2=split("",$6);
					my $counter_2=0;
					for(my $i=0;$i<=$#seq1;$i++)
					{
						#print $seq1[$i]."\t".$seq2[$i]."\n";
						if($4 eq 'F1')
						{
							my @arr=split(",",$coordinates);
							my $st=$arr[-1];
														
							if($seq2[$i]=~m/[\-]/)
							{
							$coordinates=$coordinates.$st.",";
							}
							else
							{
							my $sc=(($stS+$counter_2)*3)-2;
							$coordinates=$coordinates.$sc.",";
							$counter_2++;							
							}
							if ($seq1[$i] eq $seq2[$i])
							{
							$CCstring1= $CCstring1.$seq2[$i];
							}
							else
							{
								my $char=$seq1[$i].$seq2[$i];
								if(exists $substitution_matrix{$char})
								{
								$CCstring1= $CCstring1.$seq2[$i];
								}
								else
								{
								$CCstring1= $CCstring1.$seq2[$i];
								}
							}							
						}
						if($4 eq 'F2')
						{
							my @arr=split(",",$coordinates);
							my $st=$arr[-1];
							if($seq2[$i]=~m/[\-]/)
							{
							$coordinates=$coordinates.$st.",";
							}
							else
							{
							my $sc=(($stS+$counter_2)*3)-1;
							$coordinates=$coordinates.$sc.",";
							$counter_2++;	
							}
							if ($seq1[$i] eq $seq2[$i])
							{
							$CCstring1= $CCstring1.$seq2[$i];
							}
							else
							{
								my $char=$seq1[$i].$seq2[$i];
								if(exists $substitution_matrix{$char})
								{
								$CCstring1= $CCstring1.$seq2[$i];
								}
								else
								{
								$CCstring1= $CCstring1.$seq2[$i];
								}
							}
						}
						if($4 eq 'F3')
						{
							my @arr=split(",",$coordinates);
							my $st=$arr[-1];
							if($seq2[$i]=~m/[\-]/)
							{
							$coordinates=$coordinates.$st.",";
							}
							else
							{
							my $sc=(($stS+$counter_2)*3);
							$coordinates=$coordinates.$sc.",";
							$counter_2++;
							}
							if ($seq1[$i] eq $seq2[$i])
							{
							$CCstring1= $CCstring1.$seq2[$i];
							}
							else
							{
								my $char=$seq1[$i].$seq2[$i];
								if(exists $substitution_matrix{$char})
								{
								$CCstring1= $CCstring1.$seq2[$i];
								}
								else
								{
								$CCstring1= $CCstring1.$seq2[$i];
								}
							}							
						}
					}
				}
				if ($3 eq 'Unaligned')
				{
				$CCstring1= $CCstring1.$6;
				my @s=split("",$6);
					for (my $o=0;$o<=$#s;$o++)
					{
						my @arr=split(",",$coordinates); my $st=$arr[-1];
						if($s[$o]=~m/[\-]/)
						{
						$coordinates=$coordinates.$st.",";
						}
						elsif(($line<1)&&($o<1))
						{
						$coordinates=$coordinates.($st+1).",";
						}
						else
						{
						$coordinates=$coordinates.($st+3).",";
						}
					}
				}
			}
		}
	}
		#print $coordinates."\n";
		################ for priting aligned Query Sequence ################
		#print "The Sequences are as follows:\n";
		#print $stringCOL."\n";
		#print $SWPstring1."\n";
		#print $stringALN."\n";
		#print $CCstring1."\n";
		#print $stringCase."\n";

	####################################################################################################
       	# Printing the alignment on console based on the information by post processing alignment.txt file #
       	####################################################################################################
	alignmentVis($SWPstring1,$CCstring1,$stringCOL,$stringALN,$stringCase,$SWPPosition,$DNAPosition,$coordinates);
	sub alignmentVis
	{	
		my $SWPstr1=$_[0]; my $CCstr1=$_[1]; my $strCOL=$_[2]; my $strALN=$_[3]; my $strCase=$_[4]; my $SWPPos=$_[5]; my $DNAPos=$_[6];my $coordinates=$_[7];
		#my @chunks = split(/(.{10})/,$SWP);
		my @chunksSWP=($SWPstr1 =~ /.{1,80}/g);
		my @chunksCC=($CCstr1 =~ /.{1,80}/g);
		my @chunksCOL=($strCOL =~ /.{1,80}/g);
		my @chunksALN=($strALN =~ /.{1,80}/g);
		my @chunksCase=($strCase =~ /.{1,80}/g);
		my @chunksCoordinates=split (",",$coordinates);
		#print scalar @chunksCoordinates."\n";
		

		my @startCoord=();my @endCoord=();
		for (my $line=0;$line<=$#chunksCoordinates;$line=$line+80)
		{
			my $start_variable=$chunksCoordinates[$line];
			my $required_start_variable="";
			for (my $i=1;$i<80;$i++)
			{
			#print $chunksCoordinates[$line+$i]." ";
			#push(@array,$chunksCoordinates[$line+$i]);
				if ($chunksCoordinates[$line+$i] == $start_variable)
				{
				}
				elsif (($chunksCoordinates[$line+$i] != $start_variable ) & ($i > 1))
				{
					$required_start_variable = $chunksCoordinates[$line+$i];
					if(defined $required_start_variable){}
					else
					{
					$required_start_variable = $chunksCoordinates[$line];
					}
				last;
				}
				else
				{
				$required_start_variable = $chunksCoordinates[$line];
				last;
				}			
			}
			#print $required_start_variable."\n";
			push (@startCoord,$required_start_variable);
			#my @uniq_array=uniq @array;
			#print $uniq_array[0]."\t".$uniq_array[-1]."\n";
			#for (my $i=0;$i<80;$i++)
			#{
			#print $chunksCoordinates[$line+$i]." ";
			#}
			#print "\n";
		}

		for (my $line=0;$line<=$#chunksCoordinates;$line=$line+80)
		{
		#push(@startCoord,$chunksCoordinates[$line]);
			if(defined $chunksCoordinates[$line+79] )
			{
			push(@endCoord,$chunksCoordinates[$line+79]);
			}
			else
			{
			push (@endCoord,$chunksCoordinates[-1]);
			}
		}
		#for (my $i=0;$i<=$#startCoord;$i++)
		#{
		#print "SWETA\t".$startCoord[$i]."\t".$endCoord[$i]."\n";
		#}
		my $countS=$SWPPos;
		my $countC=$DNAPos;
		#print $stringcoord;
		for (my $K=0;$K<=$#chunksSWP;$K++)
		{
			my @SWP1string=split("",$chunksSWP[$K]);
			my @CC1string=split("",$chunksCC[$K]);
			my @COLstring=split("",$chunksCOL[$K]);
			my @Casestring=split("",$chunksCase[$K]);
			print "Query   ".$countS  ."\t";
						
			for (my $a=0;$a<=$#SWP1string;$a++)
			{
				if (($COLstring[$a] eq 'R') && ($Casestring[$a] eq 'U'))
				{
				print color('bold red');
				print uc $SWP1string[$a];
				print color ('reset');
				}
				if (($COLstring[$a] eq 'R') && ($Casestring[$a] eq 'L'))
				{
				print color('bold red');
				print lc $SWP1string[$a];
				print color ('reset');
				}
				if (($COLstring[$a] eq 'G') && ($Casestring[$a] eq 'U'))
				{
				print color('bold green');
				print uc $SWP1string[$a];
				print color ('reset');
				}
				if (($COLstring[$a] eq 'G') && ($Casestring[$a] eq 'L'))
				{
				print color('bold green');
				print lc $SWP1string[$a];
				print color ('reset');
				}
				if (($COLstring[$a] eq 'B') && ($Casestring[$a] eq 'U'))
				{
				print color('bold blue');
				print uc $SWP1string[$a];
				print color ('reset');
				}
				if (($COLstring[$a] eq 'B') && ($Casestring[$a] eq 'L'))
				{
				print color('bold blue');
				print lc $SWP1string[$a];
				print color ('reset');
				}
				if (($COLstring[$a] eq 'A') && ($Casestring[$a] eq 'L'))
				{
				print color('bold black');
				print lc $SWP1string[$a];
				print color ('reset');
				}
		
			}
			$chunksSWP[$K]=~ s/-//gi;
			if(length($chunksSWP[$K])>0)
			{
			my $count1=($countS-1)+length($chunksSWP[$K]);
			print "\t".$count1."\n";
			$countS=$count1+1;
			}
			else
			{
			my $count1=$countS;
			print "\t".$count1."\n";
			$countS=$count1;
			}
		
		#print "TargetSeq ".$count  ."\t".$chunksSWP[$K]."\t".$count1."\n";
		print " 	 \t".$chunksALN[$K]."\t \n";
		#print "QuerySeq  ".$count  ."\t".$chunksCC[$K]."\t".$count1."\n";
		#$chunksCOL[$K]=~ s/A//gi;my $tmp=$chunksCOL[$K];my @tmp=split("",$tmp);
	
		
		$countC=$startCoord[$K];
		#if ($countC ==0)
		#{
		#	if($COLstring[0] eq 'R')
		#	{
		#	$countC=$countC+1;
		#	}
		#	if($COLstring[0] eq 'G')
		#	{
		#	$countC=$countC+2;
		#	}
		#	if($COLstring[0] eq 'B')
		#	{
		#	$countC=$countC+3;
		#	}
		#	else
		#	{
		#	$countC=$countC+0;
		#	}
		#}
		$chunksCC[$K]=~ s/-//gi;
		if(length($chunksCC[$K])==0)
		{
		$countC=$endCoord[$K];
		}
		else
		{
		$countC=$startCoord[$K];
		}
		if ($countC==00)
		{
		$countC=0;
		}
		if ($countC==01)
		{
		$countC=1;
		}		
		print "Target  ".$countC  ."\t";

		
			for (my $b=0;$b<=$#CC1string;$b++)
			{
				if (($COLstring[$b] eq 'R') && ($Casestring[$b] eq 'U'))
				{
				print color('bold red');
				print uc $CC1string[$b];
				print color ('reset');
				}
				if (($COLstring[$b] eq 'R') && ($Casestring[$b] eq 'L'))
				{
				print color('bold red');
				print lc $CC1string[$b];
				print color ('reset');
				}
				if (($COLstring[$b] eq 'G') && ($Casestring[$b] eq 'U'))
				{
				print color('bold green');
				print uc $CC1string[$b];
				print color ('reset');
				}
				if (($COLstring[$b] eq 'G') && ($Casestring[$b] eq 'L'))
				{
				print color('bold green');
				print lc $CC1string[$b];
				print color ('reset');
				}
				if (($COLstring[$b] eq 'B') && ($Casestring[$b] eq 'U'))
				{
				print color('bold blue');
				print uc $CC1string[$b];
				print color ('reset');
				}
				if (($COLstring[$b] eq 'B') && ($Casestring[$b] eq 'L'))
				{
				print color('bold blue');
				print lc $CC1string[$b];
				print color ('reset');
				}
				if (($COLstring[$b] eq 'A') && ($Casestring[$b] eq 'L'))
				{
				print color('bold black');
				print lc $CC1string[$b];
				print color ('reset');
				}
			}
			$chunksCC[$K]=~ s/-//gi;
			my $count2=$endCoord[$K];
			print "\t".$count2."\n";

			#if (($count2 ==0) && (length($chunksCC[$K])==0))
			#{
			#print "\t".$countC."\n";
			#}
			#elsif (($count2 ==0) && (length($chunksCC[$K]) >0))
			#{
			#$count2=$countC+length($chunksCC[$K])*3;
			#print "\t".$count2."\n";
			#}
			#else
			#{
			#print "\t".$count2."\n";
			#}
				
		print "\n";
		}
	}		

	###################################################################
        # Code for Printing the Score on Console from alignment.txt file  #
        ###################################################################

	if($printScore == 1)
	{
		foreach my $line (@file2)
		{
			chomp($line);
			if ($line=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
			{
				if($5 eq 'F1')
				{
					if($8=~m/(.*):(.*)/)
					{
						if($2>0)
						{
						print color ('bold red');
						printf ("%.2f",$1);print ":";print $2.":";printf ("%.2f",($1/$2));print "\t";
						print color ('reset');
						}
					}
				}
				if($5 eq 'F2')
				{
					if($8=~m/(.*):(.*)/)
					{
						if($2>0)
						{
						print color ('bold green');
						printf ("%.2f",$1);print ":";print $2.":";printf ("%.2f",($1/$2));print "\t";
						print color ('reset');
						}
					}
				}
				if($5 eq 'F3')
				{
					if($8=~m/(.*):(.*)/)
					{
						if($2>0)
						{
						print color ('bold blue');
						printf ("%.2f",$1);print ":";print $2.":";printf ("%.2f",($1/$2));print "\t";
						print color ('reset');
						}
					}
				}
			}
		}
	print "\n";
	}

	##########################################################################################
        # Code for Printing the Colored Sequence based on the alignments from alignment.txt file #
        ##########################################################################################

	if($printSeq == 1)
	{
		my @fr1=split("",$f1);
		my @fr2=split("",$f2);
		my @fr3=split("",$f3);
		my @SWP1=split("",$SWP);
			
		print "\nSWP \t";
		
		for (my $index=0;$index<=$#SWP1;$index++)
		{	
			my $char="";	
			for (my $index2=0; $index2 <=$#file2;$index2++)
			{
			
				my $frame="";my $startSWP=0; my $endSWP=0;
				if ($file2[$index2]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
				{
				$frame=$5; $startSWP=$1-1; $endSWP=$2;
				}
				#
				if (($index >= $startSWP) & ($index < $endSWP))
				{
					my $diff =$index - $startSWP;
					if($frame eq "F1")
					{
						print color('bold red');
						print $SWP1[$index];
						print color('reset');
						$char = $SWP1[$index];
					}
					if($frame eq "F2")
					{
						print color('bold green');
						print $SWP1[$index];
						print color('reset');
						$char = $SWP1[$index];
					}
					if($frame eq "F3")
					{
						print color('bold blue');
						print $SWP1[$index];
						print color('reset');
						$char = $SWP1[$index];
					}
				}
			}
			if ($char ne '')
			{
			}
			else
			{
			print $SWP1[$index];
			}
	
		}
		
		print color('bold red');	
		print "\n\nFrame 1\t";
		print color('reset');
		for (my $index=0;$index<=$#fr1;$index++)
		{	
			my $char="";	
			for (my $index2=0; $index2 <=$#file2;$index2++)
			{
			
				my $startCC=0; my $endCC=0; my $frame="";
				if ($file2[$index2]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
				{
				$startCC=$3-1; $endCC=$4; $frame=$5; 
				}
				if (($index >= $startCC) & ($index < $endCC))
				{
					my $diff =$index - $startCC;
					if($frame eq "F1")
					{
						print color('bold red');
						print $fr1[$index];
						print color('reset');
						$char = $fr1[$index];
					}
				}
			}
			if ($char ne '')
			{
			}
			else
			{
			print $fr1[$index];
			}
		}
		print color('bold green');	
		print "\n\nFrame 2\t";
		print color('reset');
		for (my $index=0;$index<=$#fr2;$index++)
		{	
			my $char="";	
			for (my $index2=0; $index2 <=$#file2;$index2++)
			{
			
				my $startCC=0; my $endCC=0; my $frame="";
				if ($file2[$index2]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
				{
				$startCC=$3-1; $endCC=$4; $frame=$5; 
				}
				if (($index >= $startCC) & ($index < $endCC))
				{
					my $diff =$index - $startCC;
					if($frame eq "F2")
					{
						print color('bold green');
						print $fr2[$index];
						print color('reset');
						$char = $fr2[$index];
					}
				}
			}
			if ($char ne '')
			{
			}
			else
			{
			print $fr2[$index];
			}
	
		}
		print color('bold blue');	
		print "\n\nFrame 3\t";
		print color('reset');
		for (my $index=0;$index<=$#fr3;$index++)
		{	
			my $char="";	
			for (my $index2=0; $index2 <=$#file2;$index2++)
			{
			
				my $startCC=0; my $endCC=0; my $frame="";
				if ($file2[$index2]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
				{
				$startCC=$3-1; $endCC=$4; $frame=$5; 
				}
				if (($index >= $startCC) & ($index < $endCC))
				{
					my $diff =$index - $startCC;
					if($frame eq "F3")
					{
						print color('bold blue');
						print $fr3[$index];
						print color('reset');
						$char = $fr3[$index];
					}
				}
			}
			if ($char ne '')
			{
			}
			else
			{
			print $fr3[$index];
			}
	
		}
	print "\n\n";
	}


	if ($printDNASeq == 1)
	{
	open (DNA,$DNAfile) || die "couldn't open the $DNAfile\n";
	my @DNA=<DNA>;
	my $DNAname=$DNA[0];$DNAname=~ s/>//gi;
	my $DNAseq=$DNA[1];
	print $DNAname;
		
		my @DNAseq1=split("",$DNAseq);
		for (my $index=0;$index<=$#DNAseq1;$index++)
		{	
			my $char="";	
			for (my $index2=0; $index2 <=$#file2;$index2++)
			{
			
				my $frame="";my $startCC=0; my $endCC=0;
				if ($file2[$index2]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
				{
				$frame=$5; 
					if($frame eq 'F1'){$startCC=(($3-1)*3); $endCC=$startCC+(($4-$3+1)*3);}
					if($frame eq 'F2'){$startCC=(($3-1)*3)+1; $endCC=$startCC+(($4-$3+1)*3);}
					if($frame eq 'F3'){$startCC=(($3-1)*3)+2; $endCC=$startCC+(($4-$3+1)*3);}
				}
				if (($index >= $startCC) & ($index < $endCC))
				{
					if($frame eq "F1")
					{
						print color('bold red');
						print $DNAseq1[$index];
						print color('reset');
						$char = $DNAseq1[$index];
					}
					if($frame eq "F2")
					{
						print color('bold green');
						print $DNAseq1[$index];
						print color('reset');
						$char = $DNAseq1[$index];
					}
					if($frame eq "F3")
					{
						print color('bold blue');
						print $DNAseq1[$index];
						print color('reset');
						$char = $DNAseq1[$index];
					}
				}
			}
			if ($char ne '')
			{
			}
			else
			{
			print $DNAseq1[$index];
			}
	
		}	
	print "\n";
	}


	if($AAtoDNA == 1)
	{
	print color ('bold');
	print "Alignment of AA to DNA\n";
	print color('reset');
	open (DNA,$DNAfile) || die "couldn't open the $DNAfile\n";
	my @DNA=<DNA>;
	my $DNAseq=$DNA[1];
	my $SWP_Pos=0;my $DNA_Pos=0;

		if ($file2[0]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
		{
		$SWP_Pos=$1;
			if ($3 ==1)
			{
			if ($5 eq 'F1'){$DNA_Pos=$3;}
			if ($5 eq 'F2'){$DNA_Pos=$3+1;}
			if ($5 eq 'F3'){$DNA_Pos=$3+2;}
			}
			else
			{
			if ($5 eq 'F1'){$DNA_Pos=($3*3)-2;}
			if ($5 eq 'F2'){$DNA_Pos=($3*3)-1;}
			if ($5 eq 'F3'){$DNA_Pos=($3*3);}
			}
		}
		my $stringDNA=""; my $stringCC="";my $stringSWP="";my $stringCOL="";my $stringALN="";my $stringCase="";my $stringCOL1="";my $stringCase1="";
		for (my $k=0;$k<=$#file2;$k++)
		{
			my $SWP_end=0;my $CC_end=0;my $seq1=""; my $seq2=""; #my @Queryaln=();
		my $endCC1=0;
			if ($file2[$k]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
			{
				
				$seq1=$6;my $frame=$5;#@Queryaln=split("",$7);my $DNAlen=2;
				#for(my $i=0;$i<=$#Queryaln;$i++)
				#{
				#	if($Queryaln[$i]=~/[\-]/)
				#	{
				#	print $Queryaln[$i]."\n";
				#	}
				#	else
				#	{
				#	$DNAlen=$DNAlen+1;
				#	}
				#}
				my @s=split("",$seq1);foreach my $line (@s){$stringSWP=$stringSWP." ".$line."  ";}
				#print scalar @Queryaln."\t".scalar @s."\n";
				my @aln1=split("",$seq1);my @aln2=split("",$7);
				
				for(my $i=0;$i<=$#aln1;$i++)
				{
					if ($aln1[$i] eq $aln2[$i])
					{
					$stringALN=$stringALN." |  ";
					}
					else
					{
						my $char=$aln1[$i].$aln2[$i];
						if(exists $substitution_matrix{$char})
						{
							if($substitution_matrix{$char}>=0.10)
							{
							$stringALN=$stringALN." :  ";
							}
							else
							{
							$stringALN=$stringALN." .  ";
							} 
						}
						else
						{
						$stringALN=$stringALN."    ";
						}
					}
				}
				
				for(my $i=0;$i<=$#aln1;$i++)
				{
					if($frame eq 'F1')
					{
						if ($aln1[$i] eq $aln2[$i])
						{
						$stringCOL=$stringCOL." R  ";
						$stringCase=$stringCase." U  ";
						$stringCOL1=$stringCOL1."RRR ";
						$stringCase1=$stringCase1."UUU ";
						}
						else
						{
							my $char=$aln1[$i].$aln2[$i];
							if(exists $substitution_matrix{$char})
							{
							$stringCOL=$stringCOL." R  ";
							$stringCase=$stringCase." L  ";
							$stringCOL1=$stringCOL1."RRR ";
							$stringCase1=$stringCase1."LLL ";
							}
							else
							{
							$stringCOL=$stringCOL." A  ";
							$stringCase=$stringCase." L  ";
							$stringCOL1=$stringCOL1."AAA ";
							$stringCase1=$stringCase1."LLL ";
							}
						}							
					}
					if($frame eq 'F2')
					{
						if ($aln1[$i] eq $aln2[$i])
						{
						$stringCOL=$stringCOL." G  ";
						$stringCase=$stringCase." U  ";
						$stringCOL1=$stringCOL1."GGG ";
						$stringCase1=$stringCase1."UUU ";
						}
						else
						{
							my $char=$aln1[$i].$aln2[$i];
							if(exists $substitution_matrix{$char})
							{
							$stringCOL=$stringCOL." G  ";
							$stringCase=$stringCase." L  ";
							$stringCOL1=$stringCOL1."GGG ";
							$stringCase1=$stringCase1."LLL ";
							}
							else
							{
							$stringCOL=$stringCOL." A  ";
							$stringCase=$stringCase." L  ";
							$stringCOL1=$stringCOL1."AAA ";
							$stringCase1=$stringCase1."LLL ";
							}
						}							
					}
					if($frame eq 'F3')
					{
						if ($aln1[$i] eq $aln2[$i])
						{
						$stringCOL=$stringCOL." B  ";
						$stringCase=$stringCase." U  ";
						$stringCOL1=$stringCOL1."BBB ";
						$stringCase1=$stringCase1."UUU ";
						}
						else
						{
							my $char=$aln1[$i].$aln2[$i];
							if(exists $substitution_matrix{$char})
							{
							$stringCOL=$stringCOL." B  ";
							$stringCase=$stringCase." L  ";
							$stringCOL1=$stringCOL1."BBB ";
							$stringCase1=$stringCase1."LLL ";
							}
							else
							{
							$stringCOL=$stringCOL." A  ";
							$stringCase=$stringCase." L  ";
							$stringCOL1=$stringCOL1."AAA ";
							$stringCase1=$stringCase1."LLL ";
							}
						}	
					}
				}
				
				$SWP_end=$2;$CC_end=$4;	my $startCC1="";
				if($frame eq 'F1'){$startCC1=(($3-1)*3);$endCC1=$startCC1+(($4-$3+1)*3);}
				if($frame eq 'F2'){$startCC1=(($3-1)*3)+1; $endCC1=$startCC1+(($4-$3+1)*3);}
				if($frame eq 'F3'){$startCC1=(($3-1)*3)+2;$endCC1=$startCC1+(($4-$3+1)*3);}
				#print "For i\t".$startCC1."\t".$endCC1."\n";
				my @splitQ=split("",$7);
				my $counter1=$startCC1;
				for (my $p=0;$p<=$#splitQ;$p++)
				{
				$stringDNA=$stringDNA." ".$splitQ[$p]."  ";
					if($splitQ[$p]=~m/[\-]/)
					{
					$stringCC=$stringCC."--- ";
					}
					else
					{
					$stringCC=$stringCC.substr $DNAseq,$counter1,3;
					$stringCC=$stringCC." ";
					$counter1= $counter1+3;
					
					}
				}
				
			}
			if ($file2[$k+1]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
			{
				my $ss1=substr $SWP,$SWP_end,$1-$SWP_end-1;
				my $startCC=0;my $endCC=0;
				if($5 eq 'F1'){$startCC=(($3-1)*3);$endCC=$startCC+(($4-$3+1)*3);}
				if($5 eq 'F2'){$startCC=(($3-1)*3)+1; $endCC=$startCC+(($4-$3+1)*3);}
				if($5 eq 'F3'){$startCC=(($3-1)*3)+2;$endCC=$startCC+(($4-$3+1)*3);}
				my $ss2=substr $DNAseq,$endCC1,$startCC-$endCC1;
				#print $ss2."\n";
				#if($DNAseq=~m/(.*)$seq2(.*)$ss/){$ss2=$2;}
				#print "For i+1\t".$startCC."\t".$endCC."\n";
				#print $seq2."\t".$ss."\n";				
				#print $ss2."\n";
				if (length ($ss1) ==(length($ss2)/3))
				{
					my @s=split("",$ss1);foreach my $line (@s){$stringSWP=$stringSWP." ".$line."  ";}
					my @codonss=($ss2 =~ /.{1,3}/g);
					foreach my $line (@codonss)
					{
					$stringCC=$stringCC.$line." ";
					$stringDNA=$stringDNA."    ";
					}
					$stringALN=$stringALN.("    " x length($ss1));
					$stringCOL=$stringCOL.(" A  " x length($ss1));
					$stringCase=$stringCase.(" L  " x length($ss1));
					$stringCOL1=$stringCOL1.("AAA " x length($ss1));
					$stringCase1=$stringCase1.("LLL " x length($ss1));
				#print $ss1."\t".$ss2."\n";
				}
				elsif (length ($ss1) > (length($ss2)/3))
				{
					my @s=split("",$ss1);foreach my $line (@s){$stringSWP=$stringSWP." ".$line."  ";}
					if(length($ss2)/3 == int(length($ss2)/3))
					{
					$ss2=$ss2;
					}
					if((length($ss2)+1)/3 == int((length($ss2)+1)/3))
					{
					$ss2=$ss2." ";
					}
					if((length($ss2)+2)/3 == int((length($ss2)+2)/3))
					{
					$ss2=$ss2."  ";
					}
					my $diff=(length($ss1))-(length($ss2)/3);
					$ss2=$ss2.("-" x ($diff*3));
					my @codonss=($ss2 =~ /.{1,3}/g);
					foreach my $line (@codonss)
					{
					$stringCC=$stringCC. $line." ";
					$stringDNA=$stringDNA."    ";
					}
					$stringALN=$stringALN.("    " x length($ss1));
					$stringCOL=$stringCOL.(" A  " x length($ss1));
					$stringCase=$stringCase.(" L  " x length($ss1));
					$stringCOL1=$stringCOL1.("AAA " x length($ss1));
					$stringCase1=$stringCase1.("LLL " x length($ss1));
				#print $ss1."\t".$ss2."\n";
				}
				else
				{
					if(length($ss2)/3 == int(length($ss2)/3))
					{
					$ss2=$ss2;
					}
					if((length($ss2)+1)/3 == int((length($ss2)+1)/3))
					{
					$ss2=$ss2." ";
					}
					if((length($ss2)+2)/3 == int((length($ss2)+2)/3))
					{
					$ss2=$ss2."  ";
					}
					my $diff=(length($ss2)/3)-length($ss1);
					$ss1=$ss1.("-" x $diff);
					my @s=split("",$ss1);foreach my $line (@s){$stringSWP=$stringSWP." ".$line."  ";}
					my @codonss=($ss2 =~ /.{1,3}/g);
					foreach my $line (@codonss)
					{
					$stringCC=$stringCC. $line." ";
					$stringDNA=$stringDNA."    ";
					}
					$stringALN=$stringALN.("    " x (length($ss2)/3));
					$stringCOL=$stringCOL.(" A  " x (length($ss2)/3));
					$stringCase=$stringCase.(" L  " x (length($ss2)/3));
					$stringCOL1=$stringCOL1.("AAA " x (length($ss2)/3));
					$stringCase1=$stringCase1.("LLL " x (length($ss2)/3));			
				#print $ss1."\t".$ss2."\n";
				}
			}
			
		}

		#alignmentVis($stringSWP,$stringCC,$stringCOL,$stringALN,$stringCase,$SWP_Pos,$DNA_Pos);
		#print $stringCase."\n";
		my @chunksSWP=($stringSWP =~ /.{1,120}/g);
		my @chunksCC=($stringCC =~ /.{1,120}/g);
		my @chunksDNA=($stringDNA =~ /.{1,120}/g);
		my @chunksCOL=($stringCOL =~ /.{1,120}/g);
		my @chunksALN=($stringALN =~ /.{1,120}/g);
		my @chunksCase=($stringCase =~ /.{1,120}/g);
		my @chunksCOL1=($stringCOL1 =~ /.{1,120}/g);
		my @chunksCase1=($stringCase1 =~ /.{1,120}/g);

		my $countS=$SWP_Pos;
		my $countC=$DNA_Pos;
		for (my $i=0;$i<=$#chunksSWP;$i++)
		{
			my @SWP1string=split("",$chunksSWP[$i]);
			my @CCstring=split("",$chunksCC[$i]);
			my @DNAstring=split("",$chunksDNA[$i]);
			my @COLstring=split("",$chunksCOL[$i]);
			my @ALNstring=split("",$chunksALN[$i]);
			my @Casestring=split("",$chunksCase[$i]);
			my @COLstring1=split("",$chunksCOL1[$i]);
			my @Casestring1=split("",$chunksCase1[$i]);
			
			#print $chunksCC[$i]."\n";
			#print $chunksCOL1[$i]."\n";
			#print $chunksCase1[$i]."\n";
			#print "\n";

			print "Query   ".$countS  ."\t";
			for (my $a=0;$a<=$#SWP1string;$a++)
			{
				if (($COLstring[$a] eq 'A') && ($Casestring[$a] eq 'L'))
				{
				print color ('bold black');
				print lc " ".$SWP1string[$a]."  ";
				print color ('reset');
				}
				if (($COLstring[$a] eq 'A') && ($Casestring[$a] eq 'U'))
				{
				print color ('bold black');
				print lc " ".$SWP1string[$a]."  ";
				print color ('reset');
				}
				if (($COLstring[$a] eq 'R') && ($Casestring[$a] eq 'U'))
				{
				print color ('bold red');
				print uc " ".$SWP1string[$a]."  ";
				print color ('reset');
				}
				if (($COLstring[$a] eq 'R') && ($Casestring[$a] eq 'L'))
				{
				print color ('bold red');
				print lc " ".$SWP1string[$a]."  ";
				print color ('reset');
				}
				if (($COLstring[$a] eq 'G') && ($Casestring[$a] eq 'U'))
				{
				print color ('bold green');
				print uc " ".$SWP1string[$a]."  ";
				print color ('reset');
				}
				if (($COLstring[$a] eq 'G') && ($Casestring[$a] eq 'L'))
				{
				print color ('bold green');
				print lc " ".$SWP1string[$a]."  ";
				print color ('reset');
				}
				if (($COLstring[$a] eq 'B') && ($Casestring[$a] eq 'U'))
				{
				print color ('bold blue');
				print uc " ".$SWP1string[$a]."  ";
				print color ('reset');
				}
				if (($COLstring[$a] eq 'B') && ($Casestring[$a] eq 'L'))
				{
				print color ('bold blue');
				print lc " ".$SWP1string[$a]."  ";
				print color ('reset');
				}
			}
			$chunksSWP[$i]=~ s/-//gi;$chunksSWP[$i]=~ s/ //gi;
			if(length($chunksSWP[$i])>0)
			{
			my $count1=($countS-1)+length($chunksSWP[$i]);
			print "\t".$count1."\n";
			$countS=$count1+1;
			}
			else
			{
			my $count1=$countS;
			print "\t".$count1."\n";
			$countS=$count1;
			}
		
		#print "TargetSeq ".$count  ."\t".$chunksSWP[$K]."\t".$count1."\n";
		print " 	 \t".$chunksALN[$i]."\t \n";
		
		print "Target  ".$countC  ."\t";
		
		$countC=$countC;
					
			for (my $k=0;$k<=$#CCstring;$k=$k+4)
			{
				### this is for red color andf for first ntd
				if (($COLstring1[$k] eq 'R') && ($Casestring1[$k] eq 'L'))
				{
				print color ('bold red');
				print lc $CCstring[$k];
				print color ('reset');
				}
				if (($COLstring1[$k] eq 'R') && ($Casestring1[$k] eq 'U'))
				{
				print color ('bold red');
				print uc $CCstring[$k];
				print color ('reset');
				}
				### this is for red color andf for second ntd
				if (($COLstring1[$k+1] eq 'R') && ($Casestring1[$k+1] eq 'L'))
				{
				print color ('bold red');
				print lc $CCstring[$k+1];
				print color ('reset');
				}
				if (($COLstring1[$k+1] eq 'R') && ($Casestring1[$k+1] eq 'U'))
				{
				print color ('bold red');
				print uc $CCstring[$k+1];
				print color ('reset');
				}
				### this is for red color andf for third ntd
				if (($COLstring1[$k+2] eq 'R') && ($Casestring1[$k+2] eq 'L'))
				{
				print color ('bold red');
				print lc $CCstring[$k+2]." ";
				print color ('reset');
				}
				if (($COLstring1[$k+2] eq 'R') && ($Casestring1[$k+2] eq 'U'))
				{
				print color ('bold red');
				print uc $CCstring[$k+2]." ";
				print color ('reset');
				}
				### this is for green color andf for first ntd
				if (($COLstring1[$k] eq 'G') && ($Casestring1[$k] eq 'L'))
				{
				print color ('bold green');
				print lc $CCstring[$k];
				print color ('reset');
				}
				if (($COLstring1[$k] eq 'G') && ($Casestring1[$k] eq 'U'))
				{
				print color ('bold green');
				print uc $CCstring[$k];
				print color ('reset');
				}
				### this is for green color and for second ntd
				if (($COLstring1[$k+1] eq 'G') && ($Casestring1[$k+1] eq 'L'))
				{
				print color ('bold green');
				print lc $CCstring[$k+1];
				print color ('reset');
				}
				if (($COLstring1[$k+1] eq 'G') && ($Casestring1[$k+1] eq 'U'))
				{
				print color ('bold green');
				print uc $CCstring[$k+1];
				print color ('reset');
				}
				### this is for green color and for third ntd
				if (($COLstring1[$k+2] eq 'G') && ($Casestring1[$k+2] eq 'L'))
				{
				print color ('bold green');
				print lc $CCstring[$k+2]." ";
				print color ('reset');
				}
				if (($COLstring1[$k+2] eq 'G') && ($Casestring1[$k+2] eq 'U'))
				{
				print color ('bold green');
				print uc $CCstring[$k+2]." ";
				print color ('reset');
				}
				### this is for blue color and for first ntd
				if (($COLstring1[$k] eq 'B') && ($Casestring1[$k] eq 'L'))
				{
				print color ('bold blue');
				print lc $CCstring[$k];
				print color ('reset');
				}
				if (($COLstring1[$k] eq 'B') && ($Casestring1[$k] eq 'U'))
				{
				print color ('bold blue');
				print uc $CCstring[$k];
				print color ('reset');
				}
				### this is for blue color and for second ntd
				if (($COLstring1[$k+1] eq 'B') && ($Casestring1[$k+1] eq 'L'))
				{
				print color ('bold blue');
				print lc $CCstring[$k+1];
				print color ('reset');
				}
				if (($COLstring1[$k+1] eq 'B') && ($Casestring1[$k+1] eq 'U'))
				{
				print color ('bold blue');
				print uc $CCstring[$k+1];
				print color ('reset');
				}
				### this is for blue color and for third ntd
				if (($COLstring1[$k+2] eq 'B') && ($Casestring1[$k+2] eq 'L'))
				{
				print color ('bold blue');
				print lc $CCstring[$k+2]." ";
				print color ('reset');
				}
				if (($COLstring1[$k+2] eq 'B') && ($Casestring1[$k+2] eq 'U'))
				{
				print color ('bold blue');
				print uc $CCstring[$k+2]." ";
				print color ('reset');
				}
				### this is for black color and for first ntd
				if (($COLstring1[$k] eq 'A') && ($Casestring1[$k] eq 'L'))
				{
				print color ('bold black');
				print lc $CCstring[$k];
				print color ('reset');
				}
				if (($COLstring1[$k] eq 'A') && ($Casestring1[$k] eq 'U'))
				{
				print color ('bold black');
				print uc $CCstring[$k];
				print color ('reset');
				}
				### this is for black color and for second ntd
				if (($COLstring1[$k+1] eq 'A') && ($Casestring1[$k+1] eq 'L'))
				{
				print color ('bold black');
				print lc $CCstring[$k+1];
				print color ('reset');
				}
				if (($COLstring1[$k+1] eq 'A') && ($Casestring1[$k+1] eq 'U'))
				{
				print color ('bold black');
				print uc $CCstring[$k+1];
				print color ('reset');
				}
				### this is for black color and for thirs ntd
				if (($COLstring1[$k+2] eq 'A') && ($Casestring1[$k+2] eq 'L'))
				{
				print color ('bold black');
				print lc $CCstring[$k+2]." ";
				print color ('reset');
				}
				if (($COLstring1[$k+2] eq 'A') && ($Casestring1[$k+2] eq 'U'))
				{
				print color ('bold black');
				print uc $CCstring[$k+2]." ";
				print color ('reset');
				}
				
			}
			print " ";

			$chunksCC[$i]=~ s/-//gi;$chunksCC[$i]=~ s/ //gi;
			if(length($chunksCC[$i])>0)
			{
			my $count2=($countC-1)+(length($chunksCC[$i]));
			print "\t".$count2."\n";
			$countC=$count2+1;
			}
			else
			{
			my $count2=$countC;
			print "\t".$count2."\n";
			$countC=$count2;
			}	
			print " 	 \t";
			for (my $a=0;$a<=$#DNAstring;$a++)
			{
				if (($COLstring[$a] eq 'A') && ($Casestring[$a] eq 'L'))
				{
				print color ('bold black');
				print lc " ".$DNAstring[$a]."  ";
				print color ('reset');
				}
				if (($COLstring[$a] eq 'A') && ($Casestring[$a] eq 'U'))
				{
				print color ('bold black');
				print lc " ".$DNAstring[$a]."  ";
				print color ('reset');
				}
				if (($COLstring[$a] eq 'R') && ($Casestring[$a] eq 'U'))
				{
				print color ('bold red');
				print uc " ".$DNAstring[$a]."  ";
				print color ('reset');
				}
				if (($COLstring[$a] eq 'R') && ($Casestring[$a] eq 'L'))
				{
				print color ('bold red');
				print lc " ".$DNAstring[$a]."  ";
				print color ('reset');
				}
				if (($COLstring[$a] eq 'G') && ($Casestring[$a] eq 'U'))
				{
				print color ('bold green');
				print uc " ".$DNAstring[$a]."  ";
				print color ('reset');
				}
				if (($COLstring[$a] eq 'G') && ($Casestring[$a] eq 'L'))
				{
				print color ('bold green');
				print lc " ".$DNAstring[$a]."  ";
				print color ('reset');
				}
				if (($COLstring[$a] eq 'B') && ($Casestring[$a] eq 'U'))
				{
				print color ('bold blue');
				print uc " ".$DNAstring[$a]."  ";
				print color ('reset');
				}
				if (($COLstring[$a] eq 'B') && ($Casestring[$a] eq 'L'))
				{
				print color ('bold blue');
				print lc " ".$DNAstring[$a]."  ";
				print color ('reset');
				}
			}
		print "\n\n";
				
		}
		
	}
`rm SWP_alignment.txt CC_alignment.txt`;


}
1;

