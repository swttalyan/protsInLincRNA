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
use Getopt::Long;



			###########
                        # MODULES #
                        ###########

package main;

use Predictioncode::DNAtoAAtranslation;
use Predictioncode::extendalignment;
use Predictioncode::ntdIndexFixing;
use Predictioncode::boundaryImprovement;
use Predictioncode::masteroutputprocessing;
use Predictioncode::perfectalignmentSimulExtension;
use Predictioncode::bigInsertionSkip;
use Predictioncode::conservedScore;
use Predictioncode::SeqScore;


			######################
                        # Command line input #
                        ######################

my $num_args=$#ARGV+1;
if($num_args !=2)
{
print "Usage of Program: perl MasterScript.pl Psgfile SwissProt\n";
exit;
}
### command how to run the code
#perl predictionScript.pl data/LincRNASequences.fa data/ProteinSequences.fa >alignments.txt

open (PSG,$ARGV[0]) || die "couldnt open $!";
my @Pseudogenes=<PSG>; 

open (SWP,$ARGV[1]) || die "couldnt open $!";
my @SwissProt=<SWP>; 

my $minReadlen=4;


print "Target\tQuery\tAlignmentLength\tPercentIdentity\tMatch:Conserved:Semiconserved\tTargetStart\tTargetEnd\tQueryStart\tQueryEnd\n";
for (my $i=0;$i<=$#Pseudogenes;$i=$i+2)
{
	chomp $Pseudogenes[$i];chomp $Pseudogenes[$i+1]; 
	my $DNASeq=$Pseudogenes[$i+1];
	my ($FRAME1,$FRAME2,$FRAME3)=translation ($DNASeq);
	
	for (my $j=0;$j<=$#SwissProt;$j=$j+2)
	{	
		chomp $SwissProt[$j];chomp $SwissProt[$j+1];
		my $SWP=$SwissProt[$j+1];
		open (ALN,">alignment.txt");
		my $unalSt_CC=0;
		my $unalSt_SWP=0;
		perfect_alignment($SWP,$FRAME1,$FRAME2,$FRAME3,$minReadlen,$unalSt_CC,$unalSt_SWP);
		close (ALN);
		bigInsertionSkip("alignment.txt");
		ntdindex("alignment.txt");
		boundary_improvement($SWP,$FRAME1,$FRAME2,$FRAME3);	
		masteroutputprocessing($Pseudogenes[$i],$SwissProt[$j],$DNASeq,$SWP,"alignment.txt");

	}
}



unlink('alignment.txt') or die "Could not delete the file!\n";

