# Aligner
Code for the alignment of protein-coding genes against lincRNA genes.


The code is used for aligning and checking the alignment of two sequences where the query is protein-coding genes sequences (amino acid) and target is non-coding gene sequences (DNA). This code uses a new scoring matrix which is created by simulating punctual mutations according to the neutral theory of molecular evolution between human and chimpanzees. The alignment of the target and query sequences is shown on the consol in three different sections Top: Alignment of the protein sequence against the three frame of lincRNA gene sequences. Middle: The protein sequence is aligned against the three translated frames. Bottom: Alignment of the protein sequence to the non-coding DNA sequence.



The code is created for the following project:
"Protein coding sequences remains within lincRNAs". 
Sweta Talyan, Miguel A.Andrade-Navarro, Enrique M.Muro. Manuscript in preparation.




Prerequisites
1.  String::LCSS_XS
http://search.cpan.org/~limaone/String-LCSS_XS-1.2/lib/String/LCSS_XS.pm
2. Tested with version 1.007001 of BioPerl.

Command to run the program
Download the reposiroty from github
go to the directory Aligner 
cd Aligner
Run the following command to visualize the alignment
perl aligner.pl ENSG00000177757 P0C7U9
