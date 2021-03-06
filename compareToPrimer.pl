#the following lines will print the usage statement (if no arguments are supplied)
unless (@ARGV)
{ print "usage: perl $0 <input.fa> <primer> \nperl compare.pl set1_fw.preprocessed.fa GGMATGGTKCCSTGGCA >set1_fw.identities\n";
  print "Note: input.fa needs to be a sub-alignment (fasta format) corresponding to the aligned primer\n";
}

$reference = $ARGV[1]; # this is the reference primer sequence that is directly input as parameter 2 (e.g., GGMATGGTKCCSTGGCA)

#subroutine to compute the sequence identity for a sequence against the reference primer
sub compute_id
{
	$r = $_[1];
	$o = $_[0];
	$seqlength = 0;
	$match = 0;
	#the following for loop will directly compare each base in position i from sequence "o" versus sequence "r" and count the number of matches
	#a nucleotide ambiguity code is allowed here as well for primers containins R, Y, S, etc.
	for $i (0 .. length($r)-1)
	{	$r_val = uc substr($r,$i,1);
		$o_val = uc substr($o,$i,1);
	
		if ($o_val ne "" and $o_val ne "-")
		{	$seqlength++;
			
			if ($o_val eq $r_val)
			{	$match++;
			}
			else
			{	if ($r_val eq "R" and ($o_val eq "A" or $o_val eq "G"))
				{	$match++;
				}
				if ($r_val eq "Y" and ($o_val eq "C" or $o_val eq "T"))
				{       $match++;
				}
				if ($r_val eq "S" and ($o_val eq "G" or $o_val eq "C"))
				{       $match++;
				}
				if ($r_val eq "W" and ($o_val eq "A" or $o_val eq "T"))
				{       $match++;
				}
				if ($r_val eq "K" and ($o_val eq "G" or $o_val eq "T"))
				{       $match++;
				}
				if ($r_val eq "M" and ($o_val eq "A" or $o_val eq "C"))
				{       $match++;
				}
				if ($r_val eq "B" and ($o_val eq "C" or $o_val eq "G" or $o_val eq "T"))
				{       $match++;
				}
				if ($r_val eq "D" and ($o_val eq "A" or $o_val eq "G" or $o_val eq "T"))
				{       $match++;
				}
				if ($r_val eq "H" and ($o_val eq "A" or $o_val eq "C" or $o_val eq "T"))
				{       $match++;
				}
				if ($r_val eq "V" and ($o_val eq "A" or $o_val eq "C" or $o_val eq "G"))
				{       $match++;
				}
				if ($r_val eq "N")
				{       $match++;
				}
			}
		}
	}
	if ($seqlength == 0)
	{	return "NA";
	}
	else
	{
		return $match . "\t" . $seqlength . "\t" . $match/$seqlength;
	}
}


#opens the input file (parameter 1)
open FILE,$ARGV[0];

while (<FILE>)
{
	if (substr($_,0,1) eq ">")
	{	chomp;
		substr($_,0,1) = "";
		@tempsplit = split("/",$_);
		print $tempsplit[0];
	}
	else
	{	chomp;
		$id = "NA";
		$id = compute_id($_,$reference);
		if ($id ne "NA")
		{
			print "\t",$id,"\n";
		}
	}

}
