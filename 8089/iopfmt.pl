#!/usr/bin/perl -n

BEGIN {
	$ssp = 1;
	$hd = 0;
	print ".ft CW\n";
}
END {
	print ".ft R\n";
}

if (/^;;(\.bp)/) {
	print "$1\n";
	next;
}
/^;;/ and next;

chomp;

if (/^;------------*/) {
	#print ".sp 1\n";
	#$hd = !$hd;
	#my $line = "\\f[R];";
	my $line = ";\\f[R]";
	$line .= "\\[em]" x 40;
	$line .= "\\f[]\n.br\n";
	if ($hd) {
		print $line;
		#print ".sp 1\n";
		$hd = 0;
	} else {
		#print ".sp 1\n";
		print $line;
		$hd = 1;
	}
	next;
}

if ($hd) {
	/^;\s*(.*\S)\s+:$/ or die;
	print "; \\f[R]$1\\f[]\n.br\n";
	next;
}

if (/^\s*$/) {
	next if $ssp;
	$ssp = 1;
} else {
	$ssp = 0;
}

($p, $c) = /([^;]*)(;.*)?$/ or die;

$c =~ s/^(;.*)/\\f[I]$1\\f[]/;
$p =~ s/\b([A-Z_][A-Z0-9_]+)/\\f[CB]$1\\f[]/g;
$p =~ s/\\f\[CB\](EQU|DS|STRUC|ENDS)\\f\[\]/$1/g;

print "$p$c\n.br\n";
