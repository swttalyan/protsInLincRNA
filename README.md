# Protein sequence remnants within lincRNAs (Detection and Visualization platform)

Code for the alignment of protein-coding genes against lincRNA genes.

The code is used for aligning and checking the alignment of two sequences where query is protein-coding gene sequences (amino acid) and target is non-coding gene sequences (DNA). This code uses a new scoring matrix which is created by simulating punctual mutations according to the neutral theory of molecular evolution between human and chimpanzees. There are two scripts under this code: First: Prediction Program (To detect the remnants of protein coding genes sequences inside non-coding RNAs) and Second: Visualization platform (To check the alignment of two sequences).


The code for the following project:
"Identification of transcribed protein coding sequence remnants within lincRNAs"
Sweta Talyan, Miguel A.Andrade-Navarro, Enrique M.Muro. Manuscript Submitted.


 Requisites
1.  String::LCSS_XS
http://search.cpan.org/~limaone/String-LCSS_XS-1.2/lib/String/LCSS_XS.pm
2. Tested with version 1.007001 of BioPerl.


# Proteins Sequence remnants within lincRNA detection

Follow the steps for alignment of protein-coding sequences to lincRNA sequences.

DDownload the repository from github
go to the directory protsInLincRNA-master 

Step1: Run the prediction script by providing two multisequences fasta file FirstFile is LincRNA sequences (DNA) file and second sequences is proteins (amino acid). This script will align all the query sequences against database/template sequences,and report only those alignments which are above rost curve in the file name "AlignmentOutput.txt" in the following format: "Target	Query	AlignmentLength	PercentIdentity	Match:Conserved:Semiconserved	TargetStart	TargetEnd	QueryStart	QueryEnd". This script can take longer time depending upon the number of sequences to be aligned.

perl predictionScript.pl data/LincRNATestSequences.fa data/ProteinSequences.fa >AlignmentOutput.txt

NOTE: This script take approximately 5 minutes for aligning LincRNATestSequences.fa and ProteinSequences.fa (provided as data).

Step2: Euclidean distance from Rost-curve and Ranking of results. The script will print the ranked alignments based on euclidean distance on the command line and out put is stored in "alignmentAboveRostCurvewithEuclDistance.txt" for further analysis.

perl RankingbyEuclideanDistance.pl AlignmentOutput.txt >alignmentAboveRostCurvewithEuclDistance.txt

To get only the rank 1 alignment per query sequences, below command can be used:

grep -P "\t1\t" alignmentAboveRostCurvewithEuclDistance.txt


# Visualization platform

The second part of the code is visualization of alignment. This visualization platform is divided into three main sections. First, the protein sequence against the three-frame-translated lincRNA sequence; highlighted colors are used for the different translated frames and scores of each alignment is represented as AlignmentScore : AlignmentLength : Ratio(AlignmentScore/AlignmentLength). Second, the protein sequence against the three different ORFs of the translated lincRNA sequences; one alignment for each frame. Third, Alignment of the protein sequence against the lincRNA DNA sequence, where the divergence can be observed with a resolution of one nt.
The alignments are highlighted with three different colors: red, green and blue for frames 1, 2 and 3, respectively. Furthermore, standard symbols have been used to represent the alignment quality: “|” for identity, “:” for conserved  and “.” for semi-conserved. 

Command to run the program for the visualization of alignment of two sequences.

perl aligner.pl ENSG00000177757 P0C7U9

