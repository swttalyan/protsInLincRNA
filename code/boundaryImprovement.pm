
	###########
        # MODULES #
        ###########

package main;
use strict;
use warnings;
use List::Util qw(first);


sub boundary_improvement
{

	my $SWP=$_[0];
	my $Frame1=$_[1];
	my $Frame2=$_[2];
	my $Frame3=$_[3];

	
	open (my $data , '<', "alignment.txt")|| die "could not open $ARGV[0]:\n$!";
	my @array=(<$data>);
	my @alignments=sort {(split(/\t/,$a))[1]<=>(split(/\t/,$b))[1]} @array;
	
	for (my $i=0;$i<$#alignments;$i++)
	{	
		my $SWP1=""; my $seq1=""; my $seq2="";my $Pos="";my $frame_1="";
		my $SS=0; my $score1=0;my $Firstline=""; my $Secondline="";
		
		if ($alignments[$i]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
		{
		$SS=$4;$frame_1=$5;
		if ($8=~m/(.*):(.*)/){$score1=$1;}
		}
		open (my $data , '<', "alignment.txt")|| die "could not open $ARGV[0]:\n$!";
		my @array=(<$data>);
		my @file=sort {(split(/\t/,$a))[1]<=>(split(/\t/,$b))[1]} @array;

		if ($alignments[$i+1]=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
		{
			
			if (($3-1) ==  $SS)
			{
				if ($8=~m/(.*):(.*)/)
				{
					if ($score1 <= $1)
					{
					#print "Winner is First Sequence\n";
					$Firstline= $file[$i+1];$Pos="FIRSTSTART";
					$Secondline= $file[$i]; my $frame="";my $start="";
					#print $Firstline."\n".$Secondline."\n";
						if ($Secondline=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
						{
						$frame=$5;$start=$2;
						}
						if ($Firstline=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
						{
							my $end=0;
							if(length($7) <= 15){$end=length($7)}
							elsif ((length($7)/2)>=15){$end=int(length($7)/2)}
							else{$end=15;}
							if ($5 eq 'F1'){$seq1=substr $Frame1,$3-1,$end}
							if ($5 eq 'F2'){$seq1=substr $Frame2,$3-1,$end}
							if ($5 eq 'F3'){$seq1=substr $Frame3,$3-1,$end}
							if ($frame eq 'F1'){$seq2=substr $Frame1,$3-1,$end}
							if ($frame eq 'F2'){$seq2=substr $Frame2,$3-1,$end}
							if ($frame eq 'F3'){$seq2=substr $Frame3,$3-1,$end}
							$SWP1=substr $SWP, $start,$1-$start+$end-1;
							#print $start."\t".($1-$start+$end)."\n";
						}					
					}
					else
					{
					#print "Winner is Second Sequence\n";
					$Firstline=$file[$i];
					$Secondline= $file[$i+1];my $frame="";
					$Pos="FIRSTEND";my $end1="";
					#print $Firstline."\n".$Secondline."\n";
						if ($Secondline=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
						{
						$frame=$5;$end1=$1;
						}
						if ($Firstline=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
						{
							my $end=0;
							if(length($7) <= 15){$end=length($7)}
							elsif ((length($7)/2)>=15){$end=int(length($7)/2)}
							else{$end=15;}
							#print $4."\t".$end."\n";
							if ($5 eq 'F1'){$seq1=substr ($Frame1,($4-$end),$end)}
							if ($5 eq 'F2'){$seq1=substr $Frame2,($4-$end),$end}
							if ($5 eq 'F3'){$seq1=substr $Frame3,($4-$end),$end}
							if ($frame eq 'F1'){$seq2=substr $Frame1,($4-$end),$end}
							if ($frame eq 'F2'){$seq2=substr $Frame2,($4-$end),$end}
							if ($frame eq 'F3'){$seq2=substr $Frame3,($4-$end),$end}
							$SWP1=substr $SWP, $2-$end,$end1-$2+$end-1;
						}
					}
				}
			}

			if((($3-2) ==  $SS)&& ($frame_1 ne $5))
			{
			#print "These are parameters\t".($3-2)."\t".$SS."\t".$frame_1."\t".$5."\n";
				if ($8=~m/(.*):(.*)/)
				{
					if ($score1 <= $1)
					{
					#print "Winner is First Sequence\n";
					$Firstline= $file[$i+1];$Pos="FIRSTSTART";
					$Secondline= $file[$i]; my $frame="";my $start="";
					#print $Firstline."\n".$Secondline."\n";
						if ($Secondline=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
						{
						$frame=$5;$start=$2;
						}
						if ($Firstline=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
						{
							my $end=0;
							if(length($7) <= 15){$end=length($7)}
							elsif ((length($7)/2)>=15){$end=int(length($7)/2)}
							else{$end=15;}
							if ($5 eq 'F1'){$seq1=substr $Frame1,$3-1,$end}
							if ($5 eq 'F2'){$seq1=substr $Frame2,$3-1,$end}
							if ($5 eq 'F3'){$seq1=substr $Frame3,$3-1,$end}
							if ($frame eq 'F1'){$seq2=substr $Frame1,$3-2,$end}
							if ($frame eq 'F2'){$seq2=substr $Frame2,$3-2,$end}
							if ($frame eq 'F3'){$seq2=substr $Frame3,$3-2,$end}
							$SWP1=substr $SWP, $start,$1-$start+$end-1;
							#print $start."\t".($1-$start+$end)."\n";
							#print $seq1."\t".$seq2."\t".$SWP1."\n";
						}					
					}
					else
					{
					#print "Winner is Second Sequence\n";
					$Firstline=$file[$i];
					$Secondline= $file[$i+1];my $frame="";
					$Pos="FIRSTEND";my $end1="";
					#print $Firstline."\n".$Secondline."\n";
						if ($Secondline=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
						{
						$frame=$5;$end1=$1;
						}
						if ($Firstline=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
						{
							my $end=0;
							if(length($7) <= 15){$end=length($7)}
							elsif ((length($7)/2)>=15){$end=int(length($7)/2)}
							else{$end=15;}
							#print $4."\t".$end."\n";
							if ($5 eq 'F1'){$seq1=substr ($Frame1,($4-$end),$end)}
							if ($5 eq 'F2'){$seq1=substr $Frame2,($4-$end),$end}
							if ($5 eq 'F3'){$seq1=substr $Frame3,($4-$end),$end}
							if ($frame eq 'F1'){$seq2=substr $Frame1,($4-$end),$end+1}
							if ($frame eq 'F2'){$seq2=substr $Frame2,($4-$end),$end+1}
							if ($frame eq 'F3'){$seq2=substr $Frame3,($4-$end),$end+1}
							$SWP1=substr $SWP, $2-$end,$end1-$2+$end-1;
							#print $seq1."\t".$seq2."\t".$SWP1."\n";
						}
					}
				}


			}
		}
	#print $seq1."\t".$seq2."\t".$SWP1."\n";
	if (length ($SWP1) >= length ($seq1))
	{
	my ($position,$score1,$score2)=scoreFunction ($SWP1,$seq1,$seq2,$Pos);
	printingInAlignment($position,$Firstline,$Secondline,$Pos,$score1,$score2,$SWP1,$seq1,$seq2);
	}
		

	}

	##################################################################
	#								 #
        # Function1 for Calculating Scores and Position of maximum Score #
	#								 #
        ##################################################################

	sub scoreFunction
	{
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

	
	my $SWP1=$_[0];my $seq1=$_[1]; my $seq2=$_[2];my $Pos=$_[3];
	my @seq1=split("",$seq1);
	my @seq2=split("",$seq2);
	my @SWP1=split("",$SWP1);
	my $score1=0;my $score2=0;
	my @score_1=();my @score_2=();
	my $match=1; my $mismatch=-1;
	push (@score_2,"0");

	if ($Pos eq 'FIRSTSTART')
	{
		#print "$SWP1\t$seq1\n";
		my @SWP11=reverse @SWP1;my @seq11=reverse @seq1;
		for (my $i=0;$i<=$#seq11;$i++)
		{
			if((defined $SWP11[$i]) && (defined $seq11[$i]))
			{
			my $char=$SWP11[$i].$seq11[$i];
				if ($SWP11[$i] eq $seq11[$i])
				{
				$score1=$score1+$match;
				push (@score_1,$score1);
				}
				else 
				{
					if(exists $substitution_matrix{$char})
					{
					$score1=$score1+$substitution_matrix{$char};
					push (@score_1,$score1);
					}
					else
					{
					$score1=$score1+$mismatch;
					push (@score_1,$score1);
					}
		
				}
			}
		}
		
		#print $Pos."\n";
		for (my $i=0;$i<=$#seq2;$i++)
		{
			if((defined $SWP1[$i]) && (defined $seq2[$i]))
			{
			my $char=$SWP1[$i].$seq2[$i];
				if ($SWP1[$i] eq $seq2[$i])
				{
				$score2=$score2+$match;
				push (@score_2,$score2);
				}
				else 
				{
					if(exists $substitution_matrix{$char})
					{
					$score2=$score2+$substitution_matrix{$char};
					push (@score_2,$score2);
					}
					else
					{
					$score2=$score2+$mismatch;
					push (@score_2,$score2);
					}
				}
			}
		}
	}
	if ($Pos eq 'FIRSTEND')
	{
		
		for (my $i=0;$i<=$#seq1;$i++)
		{
			if((defined $SWP1[$i]) && (defined $seq1[$i]))
			{
			my $char=$SWP1[$i].$seq1[$i];
				if ($SWP1[$i] eq $seq1[$i])
				{
				$score1=$score1+$match;
				push (@score_1,$score1);
				}
				else 
				{
					if(exists $substitution_matrix{$char})
					{
					$score1=$score1+$substitution_matrix{$char};
					push (@score_1,$score1);
					}
					else
					{
					$score1=$score1+$mismatch;
					push (@score_1,$score1);
					}
		
				}
			}
		}
		
		my @SWP2=reverse @SWP1; my @seq22=reverse @seq2;
		for (my $i=0;$i<=$#seq22;$i++)
		{
			if((defined $SWP2[$i]) && (defined $seq22[$i]))
			{
			my $char=$SWP2[$i].$seq22[$i];
				if ($SWP2[$i] eq $seq22[$i])
				{
				$score2=$score2+$match;
				push (@score_2,$score2);
				}
				else 
				{
					if(exists $substitution_matrix{$char})
					{
					$score2=$score2+$substitution_matrix{$char};
					push (@score_2,$score2);
					}
					else
					{
					$score1=$score1+$mismatch;
					push (@score_2,$score2);
					}
				}
			}
		}
	}
	my @score_11=reverse @score_1;
	push @score_11,"0";
	my @scores=();
	for (my $i=0;$i<=$#score_11;$i++)
	{
	push(@scores,$score_11[$i]+$score_2[$i]);
	#print $score_11[$i]."\t".$score_2[$i]."\n";
	}
	my $maxScore=max @scores;
	my $position = first {$scores[$_] eq $maxScore} 0 .. $#scores;#$position=$position-1;
	
	return ($position,$score1,$score2);	
	}


	##########################################################################
	#									 #
        # Function2 for Printing the modified alignments in final alignment file #
	#									 #
        ##########################################################################



	sub printingInAlignment
	{
	my $position=$_[0]; my $Firstline=$_[1];my $Secondline=$_[2];my $Pos=$_[3];my $score1=$_[4]; my $score2=$_[5];
	my $SWP1=$_[6];my $seq1=$_[7]; my $seq2=$_[8];
	chomp ($Firstline);chomp ($Secondline);
	#print "Alignemnt1\t".$Firstline."\nAlignment2\t".$Secondline."\n";
	#print $SWP1."\t".$seq1."\t".$seq2."\n";
	#print "\nThis is position:".$position."\n";
	
	#print $score1."\t".$score2."\n";
		my $remainings="";
		if ($position ==2 )
		{
		$remainings=$position;
		}
		else
		{
		$remainings=$position;
		}
		if ($Pos eq 'FIRSTSTART')
		{
			if (length ($seq1) == 1)
			{
			
				if ($score1 >= $score2)
				{
				}
				else
				{
					my $position=1;
					if ($Firstline=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
					{
					my $S1=$1+$position; my $S2=$3+$position;my $SQ=substr($6, $position,length($6)-$position);my $sq=substr($7,$position,length($7)-$position);
					my $Replace1=$S1."\t".$2."\t".$S2."\t".$4."\t".$5."\t".$SQ."\t".$sq."\t".$8;my $AL=$1."\t".$2."\t".$3."\t".$4."\t(.*)\t(.*)\t(.*)\t(.*)";
					editfile($AL,$Replace1,"alignment.txt");
					}
					if ($Secondline=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
					{
					my $E1=$2+$position; my $E2=$4+$position;my $SQ=$6.substr($SWP1,0,$position);my $sq=$7.$seq2;
					my $Replace2=$1."\t".$E1."\t".$3."\t".$E2."\t".$5."\t".$SQ."\t".$sq."\t".$8;my $AL=$1."\t".$2."\t".$3."\t".$4."\t(.*)\t(.*)\t(.*)\t(.*)";
					editfile($AL,$Replace2,"alignment.txt");
					}
				}
			}
			elsif ($position == 0)
			{

			}
			else
			{
				if ($Firstline=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
				{
				my $S1=$1+$remainings; my $S2=$3+$remainings;my $SQ=substr($6,$remainings,length($6)-$remainings);my $sq=substr ($7,$remainings,length($7)-$remainings);
				my $Replace1=$S1."\t".$2."\t".$S2."\t".$4."\t".$5."\t".$SQ."\t".$sq."\t".$8;my $AL=$1."\t".$2."\t".$3."\t".$4."\t(.*)\t(.*)\t(.*)\t(.*)";
				#print $S1."\t".$2."\t".$S2."\t".$4."\t".$5."\t".$SQ."\t".$sq."\t".$8."\n";
				#print $1."\t".$2."\t".$3."\t".$4."\t(.*)\t(.*)\t(.*)\t(.*)"."\n";
				editfile($AL,$Replace1,"alignment.txt");
				}
				if ($Secondline=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
				{
				my $E1=$2+$remainings; my $E2=$4+$remainings;my $SQ=$6.substr($SWP1,0,$remainings);my $sq=$7.substr ($seq2,0,$remainings);
				my $Replace2=$1."\t".$E1."\t".$3."\t".$E2."\t".$5."\t".$SQ."\t".$sq."\t".$8;my $AL=$1."\t".$2."\t".$3."\t".$4."\t(.*)\t(.*)\t(.*)\t(.*)";
				#print $1."\t".$E1."\t".$3."\t".$E2."\t".$5."\t".$SQ."\t".$sq."\t".$8."\n";
				#print $1."\t".$2."\t".$3."\t".$4."\t(.*)\t(.*)\t(.*)\t(.*)"."\n";
				editfile($AL,$Replace2,"alignment.txt");
				}
			}	
									
		}
		if($Pos eq 'FIRSTEND')
		{

			if ((length ($seq1) == 1) && (length ($seq2) ==  1))
			{				
				if ($score1 >= $score2)
				{
				}
				else
				{	
					my $position=1;
					if ($Firstline=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
					{
					my $E1=$2-$position; my $E2=$4-$position;my $SQ=substr($6, 0,length($6)-$position);my $sq=substr($7,0,length($7)-$position);
					my $Replace1=$1."\t".$E1."\t".$3."\t".$E2."\t".$5."\t".$SQ."\t".$sq."\t".$8;my $AL=$1."\t".$2."\t".$3."\t".$4."\t(.*)\t(.*)\t(.*)\t(.*)";
					editfile($AL,$Replace1,"alignment.txt");
					}
					if ($Secondline=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
					{
					my $S1=$1-$position; my $S2=$3-$position;my $SQ=substr($SWP1,-$position).$6;my $sq=$seq2.$7;
					my $Replace2=$S1."\t".$2."\t".$S2."\t".$4."\t".$5."\t".$SQ."\t".$sq."\t".$8;my $AL=$1."\t".$2."\t".$3."\t".$4."\t(.*)\t(.*)\t(.*)\t(.*)";
					editfile($AL,$Replace2,"alignment.txt");
					}
				}
			}
			elsif ($position == 0)
			{
			}
			else
			{
				if ($Firstline=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
				{
				my $E1=$2-$remainings; my $E2=$4-$remainings;my $SQ=substr($6, 0,length($6)-$remainings);my $sq=substr($7,0,length($7)-$remainings);
				my $Replace1=$1."\t".$E1."\t".$3."\t".$E2."\t".$5."\t".$SQ."\t".$sq."\t".$8;my $AL=$1."\t".$2."\t".$3."\t".$4."\t(.*)\t(.*)\t(.*)\t(.*)";
				editfile($AL,$Replace1,"alignment.txt");
				}
				if ($Secondline=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
				{
				my $S1=$1-$remainings; my $S2=$3-$remainings;my $SQ=substr ($SWP1,-$remainings).$6;my $sq=substr($seq2,-$remainings).$7;
				my $Replace2=$S1."\t".$2."\t".$S2."\t".$4."\t".$5."\t".$SQ."\t".$sq."\t".$8;my $AL=$1."\t".$2."\t".$3."\t".$4."\t(.*)\t(.*)\t(.*)\t(.*)";
				editfile($AL,$Replace2,"alignment.txt");
				}
			}
		
		}

	
	}
	sub newscore
	{
		open (FH,"alignment.txt");
		my @input=<FH>;
		foreach my $line (@input)
		{
		chomp($line);
			if($line=~m/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
			{
			my ($score1)=seqScore($6,$7);
			my $Replace= $1."\t".$2."\t".$3."\t".$4."\t".$5."\t".$6."\t".$7."\t".$score1.":".length($6)."\n";
			editfile($line,$Replace,"alignment.txt");
			}
		}	
	}
	sub editfile
	{
		my $find=$_[0];my $replace=$_[1];my $file=$_[2];
		open (IN, $file) || die "Cannot open file ".$file." for read";     
		my @lines=<IN>;  
		close IN;
		 #print $replace."\t".$find."\n";
		open (OUT, ">", $file) || die "Cannot open file ".$file." for write";
		foreach my $line (@lines)
		{  
		   $line =~s/$find/$replace/ig;  
		   print OUT $line;   
		}  
		close OUT;
	}
}

1;
