# Sequence remnants within lincRNA detection and Visualization platform

Code for the alignment of protein-coding genes against lincRNA genes.


The code is used for aligning and checking the alignment of two sequences where the query is protein-coding genes sequences (amino acid) and target is non-coding gene sequences (DNA). This code uses a new scoring matrix which is created by simulating punctual mutations according to the neutral theory of molecular evolution between human and chimpanzees. The alignment of the target and query sequences is shown on the consol in three different sections Top: Alignment of the protein sequence against the three frame of lincRNA gene sequences. Middle: The protein sequence is aligned against the three translated frames. Bottom: Alignment of the protein sequence to the non-coding DNA sequence.



The code for the following project:
"Identification of transcribed protein coding sequence remnants within lincRNAs"
Sweta Talyan, Miguel A.Andrade-Navarro, Enrique M.Muro. Manuscript Submitted.


 Requisites
1.  String::LCSS_XS
http://search.cpan.org/~limaone/String-LCSS_XS-1.2/lib/String/LCSS_XS.pm
2. Tested with version 1.007001 of BioPerl.




# Proteins Sequence remnants within lincRNA detection

Follow the steps for alignment of protein coding sequences to lincRNA sequences.
Download the reposiroty from github
go to the directory protsInLincRNA 

Step1: Run the prediction script by providing two multisequences fasta file FirstFile is LincRNA sequences file and second sequences is proteins. The program will print the output on the command line redirect the output in a file and wait until the code finish this script can take longer time depending upon the number of sequences to be aligned.

This script will align all the query sequences against database/template sequences,and report only those alignments which are above rost curve in the file name "AlignmentOutput.txt" in the following format: "Target	Query	AlignmentLength	PercentIdentity	Match:Conserved:Semiconserved	TargetStart	TargetEnd	QueryStart	QueryEnd". 

perl predictionScript.pl data/LincRNATestSequences.fa data/ProteinSequences.fa >AlignmentOutput.txt

Step3: Euclidean distance from Rost-curve and Ranking of results. The script will print the ranked alignments based on euclidean distance for lincRNA sequences on the command line please redirect these alignments in a file for further analysis.

perl RankingbyEuclideanDistance.pl AlignmentOutput.txt >alignmentAboveRostCurvewithEuclDistance.txt

To get only the rank 1 alignment per query sequences, below command can be used, where it will first select the rank one alignment and if there are two alignment for same query sequences then it will sort based on euclidean distance and alignment length.

grep -P "\t1\t" alignmentAboveRostCurvewithEuclDistance.txt| sort -k4,6n | sort -k1,1 -u


# Visualization platform
The visualization is divided into three main sections. First, the protein sequence against the three-frame-translated lincRNA sequence; highlighted colors are used for the different translated frames and scores of each alignment is represented as AlignmentScore:AlignmentLength:Ratio(AlignmentScore/AlignmentLength). Second, the protein sequence against the three different ORFs of the three translated lincRNA sequences; one alignment for each frame. Third, Alignment of the protein sequence against the lincRNA DNA sequence, where the divergence can be observed with a resolution of one nt.
The alignments are highlighted with three different colors: red, green and blue for frames 1, 2 and 3, respectively. Furthermore, standard symbols have been used to represent the alignment quality: “|” for identity, “:” for conserved (probability value ≥ 0.2) and “.” for semi-conserved (probability < 0.2) (Fig. 3A-C). Note that here, conservation is defined by the probability of amino acid substitutions we calculated above.

Command to run the program for the visualization of alignment of two sequences.

perl aligner.pl ENSG00000177757 P0C7U9

