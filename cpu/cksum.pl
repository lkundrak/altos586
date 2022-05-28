# SPDX-License-Identifier: GPL-2.0-or-later

my $srcfile = shift @ARGV or die "Usage: $0 <romfile> > <checksummed>";

open my $f, $srcfile or die "$srcfile: $!";
my @b = unpack 'C*', join '', <$f>;

my $csum = 0;
$csum += $_ foreach @b[0..$#b-1];
$b[$#b] = -$csum & 0xff;

print pack 'C*', @b;
