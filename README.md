# Aligner
Code for the alignment of protein-coding genes against lincRNA genes.


The program align protein-coding genes sequences (amino acid) against non-coding gene sequences (DNA) using a new scoring matrix which is created by simulating punctual mutations according to the neutral theory of molecular evolution
between human and chimpanzees. The alignment of the target and query sequences is shown on the consol in three different sections Top: Alignment of the protein sequence against the three frame of lincRNA gene sequences. Middle: The protein sequence is aligned against the three translated frames. Bottom: Alignment of the protein sequence to the non-coding DNA sequence.



Prerequisites
1.  String::LCSS_XS
http://search.cpan.org/~limaone/String-LCSS_XS-1.2/lib/String/LCSS_XS.pm
2. Latest version of the BioPerl


Command to run the program
Download the reposiroty from github
go to the directory Aligner 
cd Aligner
Run the following command to visualize the alignment
perl aligner.pl ENSG00000177757 P0C7U9
