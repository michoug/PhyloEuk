#!/usr/bin/perl

use File::Slurp;
use strict;
use warnings;

my ($taxFile, $treeFile) = @ARGV;

my %taxHash;

open TAX, $taxFile or die $!;

while(<TAX>){
	chomp;
	next if /Assem/;
	my @line = split /\t/;
	$taxHash{$line[0]} = "$line[1]";	
}


close TAX;

# for my $i (keys %taxHash){
# 	print "$i\t$taxHash{$i}\n"
# }


my $text = read_file( $treeFile) ;

for my $i (keys %taxHash){
	$text =~ s/($i)/$taxHash{$1}/g;	
}

print "$text\n";