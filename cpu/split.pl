# SPDX-License-Identifier: GPL-2.0-or-later

die "Usage: $0 <hi.bin> <lo.bin> <full.bin>" unless scalar @ARGV == 3;
my ($hifile, $lofile, $srcfile) = @ARGV;

my $sz = 0x2000;

open my $f, $srcfile or die "$srcfile: $!";
my @b = reverse split //, join '', <$f>;

my $hi = '';
my $lo = '';

while (@b) {
	$hi .= shift @b;
	die unless scalar @b;
	$lo .= shift @b;
}

my $len = length $hi;
die unless $len == length $lo;
die if $sz % $len;

$hi x= $sz / $len;
$lo x= $sz / $len;

open $f, '>', $hifile or die "$hifile: $!";
print $f $hi;

open $f, '>', $lofile or die "$lofile: $!";
print $f $lo;
