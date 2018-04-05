package main;
use warnings;
use strict;
use Bio::DB::Fasta;

sub fetsequence
{
	my $QueryID=$_[0];my $QueryFile=$_[1];
	my $Querydb= Bio::DB::Fasta->new($QueryFile);
	my @Queryids = $Querydb->get_all_primary_ids;

	my $QueryID_new="";
	foreach my $line (@Queryids)
	{
		chomp ($line);
		if ($line=~m/$QueryID/)
		{
		$QueryID_new = $line;
		last;
		}
	}

	my $Queryseq= $Querydb->get_Seq_by_id($QueryID_new);
	my $Queryseqstr  = $Queryseq->seq;
	return $Queryseqstr;
}
1;
