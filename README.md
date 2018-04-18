# Aligner and prediction code
Code for the alignment of protein-coding genes against lincRNA genes.


The code is used for aligning and checking the alignment of two sequences where the query is protein-coding genes sequences (amino acid) and target is non-coding gene sequences (DNA). This code uses a new scoring matrix which is created by simulating punctual mutations according to the neutral theory of molecular evolution between human and chimpanzees. The alignment of the target and query sequences is shown on the consol in three different sections Top: Alignment of the protein sequence against the three frame of lincRNA gene sequences. Middle: The protein sequence is aligned against the three translated frames. Bottom: Alignment of the protein sequence to the non-coding DNA sequence.



The code for the following project:
"Protein coding sequences remains within lincRNAs". 
Sweta Talyan, Miguel A.Andrade-Navarro, Enrique M.Muro. Manuscript in preparation.




Requisites
1.  String::LCSS_XS
http://search.cpan.org/~limaone/String-LCSS_XS-1.2/lib/String/LCSS_XS.pm
2. Tested with version 1.007001 of BioPerl.

Command to run the program for the visualization of alignment of two sequences
Download the reposiroty from github
go to the directory Aligner 
cd protsInLincRNA
Run the following command to visualize the alignment
perl aligner.pl ENSG00000177757 P0C7U9

Follow the steps for alignment of protein coding sequences to lincRNA sequences

Step1: Run the prediction script by providing two multisequences fasta file FirstFile is LincRNA sequences file and second sequences is proteins. The program will print the output on the command line redirect the output in a file and wait until the code finish this script can take longer time depending upon the number of sequences to be aligned.

perl predictionScript.pl data/LincRNASequences.fa data/ProteinSequences.fa >alignments.txt

Step2: Filtering of the alignment results using Rost-curve. This script will only print the alignments on command line which are above the curve and can be redirect to a new file which further can be used for Raning.

perl AlignmentAboveRostCurve.pl alignments.txt >alignmentAboveRostCurve.txt

Step3: Euclidean distance from Rost-curve and Ranking of results. The script will print the ranked alignments based on euclidean distance for lincRNA sequences on the command line please redirect these alignments in a file for further analysis.

perl RankingbyEuclideanDistance.pl alignmentAboveRostCurve.txt >alignmentAboveRostCurvewithEuclDistance.txt

These alignment results can be further analyzed

