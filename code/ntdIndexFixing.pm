package main;
use warnings;
use strict;
no warnings 'uninitialized';
no warnings 'substr';

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

1;
