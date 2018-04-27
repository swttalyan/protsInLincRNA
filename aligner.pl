#!/usr/bin/perl
use strict;
use warnings;







			################
                        # MAIN PROGRAM #
                        ################

# ################################################################################ #
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
use code::bigInsertionSkip;
use code::conservedScore;
use code::SeqScore;
use code::ntdIndexFixing;

my $num_args=$#ARGV+1;
if($num_args !=2)
{
print "Usage of Program: perl aligner.pl LincRNAID ProteinID\n";
exit;
}

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


unlink('file.txt') or die "Could not delete the file!\n";
unlink('alignment.txt') or die "Could not delete the file!\n";

