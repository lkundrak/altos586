# SPDX-License-Identifier: GPL-2.0-or-later

sub f {
	open my $f, shift or die;
	reverse split //, join '', <$f>;
}

die unless scalar @ARGV == 2;
my @a = f(shift @ARGV);
my @b = f(shift @ARGV);

print $_, shift @b foreach @a;
