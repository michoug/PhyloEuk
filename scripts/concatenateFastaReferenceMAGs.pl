#!/usr/bin/env perl

use strict;
use warnings;
use Bio::DB::Fasta;

my ($dir,$listRef,$listMAGs) = @ARGV;

my %hash;

open FILE, $listRef;
while(<FILE>){
	chomp;
	s/\.faa//g;
	$hash{$_} = 1;
}
close FILE;

open FILE, $listMAGs;
while(<FILE>){
	chomp;
	s/\.faa//g;
	$hash{$_} = 1;
}
close FILE;

my %finalhash = %hash;

close FILE;

opendir (DIR, $dir) or die "Error occured, $!";

while (my $file = readdir DIR) {
	my %temphash = %hash;
	next if $file !~ /align_all.faa$/;
	my $toRemove = $file;
	$toRemove =~ s/_align_all.faa//g;
	
	my $db       = Bio::DB::Fasta->new("$dir/$file");
	my @ids      = $db->get_all_primary_ids;

	my $length   = $db->length($ids[0]);
	#print "$length\n";

	for my $i (@ids){
		my $j = $i;
		$j =~ s/\_$toRemove.*//g;
		#print "$j\n";
		my $seq     = $db->get_Seq_by_id($i);
		if($finalhash{$j} eq 1)
		{
			$finalhash{$j} = $seq->seq;
			delete $temphash{$j}
		}
		else{
			$finalhash{$j} .= $seq->seq;
			delete $temphash{$j}
		}
	}

	for my $rest (keys %temphash){
		if($finalhash{$rest} eq 1)
		{
			$finalhash{$rest} = "-" x $length;
		}
		else{
			$finalhash{$rest} .= "-" x $length;
		}
	}
}

my $fileout = $listMAGs;
$fileout =~ s/list//g;
$fileout =~ s/.txt/_align.fasta/g;

open FILEOUT, ">", $fileout;

for my $j (keys %finalhash){
	if($j =~ /ENSEMBLE/){
		my $count = $finalhash{$j} =~ tr/-//;
		next if $count == length($finalhash{$j});
		#print $count."\n";
		print FILEOUT ">$j\n$finalhash{$j}\n";
	}
}
close FILEOUT;