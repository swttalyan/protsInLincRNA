package main;
use warnings;
use strict;

sub translation
{
	my $DNA=$_[0];
	my $protein1='';my $protein2=''; my $protein3=''; 
	my $codon1; my $codon2; my $codon3; 
	
	for(my $i=0;$i<(length($DNA)-2);$i+=3)
	{
	$codon1=substr($DNA,$i,3);
	$protein1.=&codon2aa($codon1);
	}
	for(my $i=1;$i<(length($DNA)-2);$i+=3)
	{
	$codon2=substr($DNA,$i,3);
	$protein2.=&codon2aa($codon2);
	}
	for(my $i=2;$i<(length($DNA)-2);$i+=3)
	{
	$codon3=substr($DNA,$i,3);
	$protein3.=&codon2aa($codon3);
	}
	
	return ($protein1,$protein2,$protein3);
	sub codon2aa
	{
		my($codon1)=@_;
		$codon1=uc $codon1;
		my($codon2)=@_;
		$codon2=uc $codon2;
		my($codon3)=@_;
		$codon3=uc $codon3;
		
		my(%g)=('TCA'=>'S','TCC'=>'S','TCG'=>'S','TCT'=>'S','TTC'=>'F','TTT'=>'F','TTA'=>'L','TTG'=>'L','TAC'=>'Y','TAT'=>'Y','TAA'=>'*','TAG'=>'*' ,
		'TGC'=>'C','TGT'=>'C','TGA'=>'*','TGG'=>'W','CTA'=>'L','CTC'=>'L','CTG'=>'L','CTT'=>'L','CCA'=>'P','CCC'=>'P','CCG'=>'P','CCT'=>'P','CAC'=>'H',
		'CAT'=>'H','CAA'=>'Q','CAG'=>'Q','CGA'=>'R','CGC'=>'R','CGG'=>'R','CGT'=>'R','ATA'=>'I','ATC'=>'I','ATT'=>'I','ATG'=>'M','ACA'=>'T','ACC'=>'T',
		'ACG'=>'T','ACT'=>'T','AAC'=>'N','AAT'=>'N','AAA'=>'K','AAG'=>'K','AGC'=>'S','AGT'=>'S','AGA'=>'R','AGG'=>'R','GTA'=>'V','GTC'=>'V','GTG'=>'V',
		'GTT'=>'V','GCA'=>'A','GCC'=>'A','GCG'=>'A','GCT'=>'A','GAC'=>'D','GAT'=>'D','GAA'=>'E','GAG'=>'E','GGA'=>'G','GGC'=>'G','GGG'=>'G','GGT'=>'G');
		if(exists $g{$codon1}){return $g{$codon1};}
		if(exists $g{$codon2}){return $g{$codon2};}
		if(exists $g{$codon3}){return $g{$codon3};}
		else
		{
		print STDERR "Bad codon \"$codon1\"!!\n";
		exit;
		}
	}
}
1;
