# SPDX-License-Identifier: GPL-2.0-or-later

use strict;
use warnings;
use warnings FATAL => 'all';

package mem;

use CPU::Emulator::Memory::Banked;
use base qw/CPU::Emulator::Memory::Banked/;

sub trace { $mem::trace->(@_) if $mem::trace }
sub dis { my $addr = shift; $main::code{$addr}[0] // '-' }
#sub dis { '-' }

my %hostmem = main::hostmem();

sub hostmem_name
{
	my $bus_adr = shift;
	my $name = undef;

	if (exists $hostmem{$bus_adr}) {
		$name = $hostmem{$bus_adr};
		if (not exists $hostmem{$bus_adr + 1}) {
			$name .= " - Lo";
		}
	} elsif (exists $hostmem{$bus_adr - 1}) {
		$name = $hostmem{$bus_adr - 1};
		if (exists $hostmem{$bus_adr + 1}) {
			$name .= " - Hi";
		} else {
			$name .= " - Mid";
		}
	} elsif (exists $hostmem{$bus_adr - 2}) {
		$name = $hostmem{$bus_adr - 2};
		$name .= " - Hi";
	}

	return $name;
}

sub peek
{
	my $self = shift;
	my $adr = $_[0];
	my $dis = dis($adr);

	trace 'MEM READ 0x%04x', $adr if $mem::debug;

	if ($adr >= 0x8000) {
		my $bus_adr = $mem::base + $adr - 0x8000;
		my $val = exists $main::busmem{$bus_adr} ? $main::busmem{$bus_adr} : 0x00;
		my $name = hostmem_name($bus_adr);
		die sprintf 'BAD HOST MEM READ:  0x%04x', $bus_adr unless defined $name;
		trace 'HOST MEM READ:  0x%04x -> 0x%02x [%s]', $bus_adr, $val, $name;
		return $val;
	} elsif ($adr >= 0x2800) {
		die sprintf 'UNMAPPED READ 0x%04x', $adr unless main::buggy_access();
		warn 'emulator generated an extra mem access due to a bug';
		#warn sprintf 'UNMAPPED READ 0x%04x', $adr;
	} else {
		my $val = $self->SUPER::peek(@_);
		if ($adr >= 0x2000) {
			trace 'RAM MEM READ 0x%04x -> 0x%02x %s', $adr, $val, $dis; # if $mem::debug;
		} else {
			#trace 'ROM MEM READ 0x%04x -> 0x%02x', $adr, $val if $mem::debug;
		}
		return $val;
	}
}

sub poke
{
	my $self = shift;
	my ($adr, $val) = @_;
	my $dis = dis($adr);
	#warn sprintf 'MEM WRITE 0x%04x <- 0x%04x', $adr, $val if $adr >= 0x2000;
	#die if $adr >= 0x2800 and $adr < 0x8000;

	if ($adr >= 0x8000) {
		my $bus_adr = $mem::base + $adr - 0x8000;
		my $name = hostmem_name($bus_adr);
		die sprintf 'BAD HOST MEM WRITE: 0x%04x', $bus_adr if not defined $name;
		trace 'HOST MEM WRITE: 0x%04x <- 0x%02x [%s]', $bus_adr, $val, $name;
		$main::busmem{$bus_adr} = $val;
	} elsif ($adr >= 0x2800) {
		die sprintf 'UNMAPPED MEM WRITE 0x%04x <- 0x%02x', $adr, $val if $adr >= 0x2000;
	} elsif ($adr < 0x2000) {
		die sprintf 'ROM MEM WRITE 0x%04x <- 0x%02x', $adr, $val if $adr >= 0x2000;
	} else {
		trace 'RAM MEM WRITE 0x%04x <- 0x%02x %s', $adr, $val, $dis; # if $mem::debug;
	}

	$self->SUPER::poke(@_);
}

package main;

use CPU::Emulator::Z80;
use POSIX qw/isatty F_SETFL O_NONBLOCK/;
use IO::Stty;
use Fcntl;

my %regs = regs();
my $m = new mem;
my $debug = $ENV{DEBUG};

$m->bank (address => 0x0000, type => 'ROM', file => ($ARGV[0] // 'iop.bin'));
$m->bank (address => 0x2000, type => 'RAM', size => 0x0800);
#$m->bank (address => 0x8000, type => 'RAM', size => 0x8000); # #DRAM

my $e = new CPU::Emulator::Z80 (memory => $m, ports => 256);
my $insncnt = 0;

my @calls;
my $func;

sub call { unshift @calls, shift }
sub uncall { shift @calls }

sub buggy_access
{
	# https://rt.cpan.org/Ticket/Display.html?id=142489
	my $ret = 0;
	eval {
		$ret = 1 if $m->peek($e->register('PC')->get - 1) == 0xfc
			and $m->peek($e->register('PC')->get - 2) == 0xcb;
	};
	return $ret;
}

sub fregs
{
	my $e = shift;
	sprintf 'a=%02x b=%02x c=%02x d=%02x e=%02x f=%02x h=%02x l=%02x ix=%04x iy=%04x sp=%04x pc=%04x',
		map { $e->register($_)->get } qw/A B C D E F H L IX IY SP PC/;
}

sub trace
{
	my ($msg) = sprintf shift, @_;
	my $indent = '  ' x scalar @calls;
	chomp $msg;
	printf STDERR "%10d %s %s[%s]: $msg\n", $insncnt, fregs($e), $indent, $func;
}

sub trace2
{
	trace (@_);
	#warn $e->format_registers;
}

$mem::base = 0;
$mem::trace = \&trace2;
$mem::debug = $debug;

my $fdc_intrq = 0;
my $fdc_data = 0;
my $fdc_sector = 0;
my $fdc_status = 0;
my $fdc_track = 0;
my $sio_a_reg = undef;

my $dma_state = 0;
my $dma_len = 0;
my $dma_porta = 0;
my $dma_portb = 0;
my $fdc_bytes = 0;

my %out = (
	0x00 => sub {
		my ($adr, $val) = @_;
		#trace "WRITE 0x%02x 0x%04x", $adr, $val;
		#$val <<= 15;
		$mem::base = $val << 15;
		trace "WINDOW AT 0x8000 ACCESSES HOST MEMORY AT 0x%04x 0x%02x <- 0x%02x [%s]", $mem::base, @_ if $debug;
	},

#	# PIO
#	0x34 => sub { trace "WRITE 0x%02x 0x%02x [%s]", @_; },	# Data port A
#	0x35 => sub { trace "WRITE 0x%02x 0x%02x [%s]", @_; },	# Command port A
#	0x37 => sub { trace "WRITE 0x%02x 0x%02x [%s]", @_; },	# Command port B
#
#	0x27 => sub { trace "WRITE 0x%02x 0x%02x [%s]", @_; },
#	0x26 => sub { trace "WRITE 0x%02x 0x%02x [%s]", @_; },
#	0x25 => sub { trace "WRITE 0x%02x 0x%02x [%s]", @_; },
#	0x29 => sub { trace "WRITE 0x%02x 0x%02x [%s]", @_; },
#	0x31 => sub { trace "WRITE 0x%02x 0x%02x [%s]", @_; },
	0x2c => sub {
		my ($adr, $val) = @_;
		trace "SIO DATA WRITE 0x%02x <- 0x%02x [%s]", @_;
		if (not isatty *STDERR) {
			print chr($val);
			flush STDOUT;
		}
	},
	0x2d => sub {
		my ($adr, $val) = @_;
		if (defined $sio_a_reg) {
			trace "SIO REG WR%d VAL ADDR WRITE 0x%02x <- 0x%02x [%s]", $sio_a_reg, @_;
			$sio_a_reg = undef;
		} else {
			$sio_a_reg = $val;
			trace "SIO REG WR%d ADDR WRITE 0x%02x <- 0x%02x [%s]", $sio_a_reg, @_;
		}
	},
#	0x2f => sub { trace "WRITE 0x%02x 0x%02x [%s]", @_; },
#	0x2b => sub { trace "WRITE 0x%02x 0x%02x [%s]", @_; },
#	0x33 => sub { trace "WRITE 0x%02x 0x%02x [%s]", @_; },
#
#	0x36 => sub { trace "WRITE 0x%02x 0x%02x [%s]", @_; },

	0x38 => sub {
		my ($adr, $val) = @_;
		if ($val == 0x08) {
			trace "FDC CMD WRITE RESTORE WITH HEAD LOAD 0x%02x <- 0x%02x [%s]", @_;
			$fdc_status = 0x24; # head loaded | track 0
		} elsif ($val == 0x10) {
			trace "FDC CMD WRITE SEEK 0x%02x <- 0x%02x [%s]", @_;
			$fdc_status &= 0x20; # keep head loaded
			$fdc_status |= 0x04 if $fdc_data == 0; # track 0
			$fdc_track = $fdc_data;
		} elsif ($val == 0x18) {
			trace "FDC CMD WRITE SEEK WITH HEAD LOAD 0x%02x <- 0x%02x [%s]", @_;
			$fdc_status = 0x20; # head loaded
			$fdc_status |= 0x04 if $fdc_data == 0; # track 0
			$fdc_track = $fdc_data;
		} elsif ($val == 0x8a || $val == 0x88) { # 8a = side 1, 88 = side 0
			# E=0 no head load, F1=Side 1
			trace "FDC CMD READ SINGLE 512B SECTOR 0x%02x <- 0x%02x [%s]", @_;
			$fdc_status = 0x00;
		} elsif ($val == 0xe0) {
			trace "FDC CMD READ TRACK 0x%02x <- 0x%02x [%s]", @_;
			$fdc_status = 0x00;
			$fdc_status = 0x02;
		} elsif ($val == 0xf0) {
			trace "FDC CMD WRITE TRACK 0x%02x <- 0x%02x [%s]", @_;
			$fdc_status = 0x00;
			$fdc_status = 0x02;
			$fdc_bytes = 6328;
		} else {
			trace "FDC CMD WRITE 0x%02x <- 0x%02x [%s]", @_;
			die;
		}
		$fdc_intrq = 1;
		
		# 0001 0000
		# seek hV01 seek, no head load, no verify, rate=0 (lower)
		# 0x1915: FDC CMD WRITE 0x38 <- 0x10 [FDC - Write command, Read status]
	},
	0x3a => sub {
		my ($adr, $val) = @_;
		$fdc_sector = $val;
		trace "FDC SECTOR WRITE 0x%02x <- 0x%02x [%s]", @_;
	},
	0x3b => sub {
		my ($adr, $val) = @_;
		$fdc_data = $val;
		trace "FDC DATA WRITE 0x%02x <- 0x%02x [%s]", @_;
	},

	0x3c => sub {
		my ($adr, $val) = @_;
		if ($dma_state == 0) {
			my ($adr, $val) = @_;
			if ($val == 0xc3) {
				# Group 6
				trace 'DMA WRITE RESET 0x%02x <- 0x%02x [%s]', @_;
			} elsif ($val == 0x14) {
				# Group 1 Configure port A
				trace 'DMA WRITE PORT A MEMORY, INCREMENTS 0x%02x <- 0x%02x [%s]', @_;
			} elsif ($val == 0x28) {
				# Group 2 Configure port B
				trace 'DMA WRITE PORT B I/O, FIXED 0x%02x <- 0x%02x [%s]', @_;
			} elsif ($val == 0x92) {
				# Group 5
				trace 'DMA WRITE STOP, CE/WAIT MUX, READY LOW 0x%02x <- 0x%02x [%s]', @_;
			} elsif ($val == 0x79) {
				# Group 0
				trace 'DMA WRITE PORT B -> PORT A TRANSFER (ADDR16, LEN16) 0x%02x <- 0x%02x [%s]', @_;
				$dma_state = 1;
			} elsif ($val == 0x85) {
				# Group 4
				trace 'DMA WRITE BYTE PORT B (ADDR8) 0x%02x <- 0x%02x [%s]', @_;
				$dma_state = 5;
			} elsif ($val == 0xcf) {
				# Group 6
				trace 'DMA WRITE LOAD ADDRS, RESET COUNTER 0x%02x <- 0x%02x [%s]', @_;
			} elsif ($val == 0x87) {
				# Group 6
				trace 'DMA WRITE ENABLE 0x%02x <- 0x%02x [%s]', @_;
			} elsif ($val == 0x05) {
				# Group 0
				trace 'DMA WRITE PORT A -> PORT B TRANSFER 0x%02x <- 0x%02x [%s]', @_;
			} else {
				die sprintf '%02x', $val;
			}
		} elsif ($dma_state == 1) {
			trace 'DMA WRITE PORT A ADDR LO 0x%02x <- 0x%02x [%s]', @_;
			$dma_porta = $val;
			$dma_state = 2;
		} elsif ($dma_state == 2) {
			trace 'DMA WRITE PORT A ADDR HI 0x%02x <- 0x%02x [%s]', @_;
			$dma_porta |= $val << 8;
			$dma_state = 3;
		} elsif ($dma_state == 3) {
			trace 'DMA WRITE PORT A LEN LO 0x%02x <- 0x%02x [%s]', @_;
			$dma_len = $val;
			$dma_state = 4;
		} elsif ($dma_state == 4) {
			trace 'DMA WRITE PORT A LEN HI 0x%02x <- 0x%02x [%s]', @_;
			$dma_len |= $val << 8;
			$dma_state = 0;
		} elsif ($dma_state == 5) {
			trace 'DMA WRITE PORT B ADDR 0x%02x <- 0x%02x [%s]', @_;
			$dma_portb = $val;
			$dma_state = 0;
		} else {
			die;
		}
	},
);

my @sio_c;
my %in = (
#	# PIO
	0x34 => sub {
		# Data port A
		our $cnt;
		my $val = 0x56;
		$val |= 0x80 if $fdc_intrq;
		$cnt++;
		if ($cnt++ > 20) {
			$val |= 0x01;
			$cnt = 0 if $cnt > 40;
		}
		#trace "READ 0x%02x -> 0x%02x [%s]", shift, $_, shift; $_
		trace "PIO DATA PORT A READ 0x%02x -> 0x%02x [%s]", shift, $val, shift;
		return $val;
	},
	0x36 => sub {
		# Data port B
		# ~0x80 enables further poll
		#my $val = 0x91;
		my $val = 0x00;
		trace "PIO DATA PORT B READ 0x%02x -> 0x%02x [%s]", shift, $val, shift;
		return $val;
	},

#	0x39 => sub { $_ = 0xff; trace "READ 0x%02x -> 0x%02x [%s]", shift, $_, shift; $_ },
#	0x39 => sub { $_ = 0xff; trace "READ 0x%02x -> 0x%02x [%s]", shift, $_, shift; $_ },
#
#	0x38 => sub { $_ = 0xff; trace "READ 0x%02x -> 0x%02x [%s]", shift, $_, shift; $_ },
#
#	0x29 => sub { $_ = 0xff; trace "READ 0x%02x -> 0x%02x [%s]", shift, $_, shift; $_ },
#	0x31 => sub { $_ = 0xff; trace "READ 0x%02x -> 0x%02x [%s]", shift, $_, shift; $_ },
#
#	0x2d => sub { $_ = 0xff; trace "READ 0x%02x -> 0x%02x [%s]", shift, $_, shift; $_ },

	0x2c => sub {
		my $val = scalar @sio_c ? shift @sio_c : 0x00;
		trace "SIO DATA READ 0x%02x -> 0x%02x [%s]", shift, $val, shift;
		return $val;
	},

	0x2d => sub {
		my $val;

		unless (defined $sio_a_reg) {
			trace 'NO SIO A REG';
			die unless $ARGV[0];
			return 0x00;
		}

		if ($sio_a_reg == 0) {
			# TX buf empty, DCD on. Only these two bits checked prior to transmit.
			$val = 0x0c;
			# RX char available?
			my $c;
			read STDIN, $c, 1 unless $c;
			push @sio_c, ord $c unless $c eq '';
			$val |= 0x01 if scalar @sio_c;
		}

		# All sent bit. Checked prior to transmit.
		$val = 0x01 if $sio_a_reg == 1;

		die unless defined $val;
		trace "SIO REG RR%d VAL READ 0x%02x -> 0x%02x [%s]", $sio_a_reg, shift, $val, shift;
		$sio_a_reg = undef;
		return $val;
	},

#	0x2f => sub { $_ = 0xff; trace "READ 0x%02x -> 0x%02x [%s]", shift, $_, shift; $_ },
#	0x2b => sub { $_ = 0xff; trace "READ 0x%02x -> 0x%02x [%s]", shift, $_, shift; $_ },
#	0x33 => sub { $_ = 0xff; trace "READ 0x%02x -> 0x%02x [%s]", shift, $_, shift; $_ },

	0x38 => sub {
		trace "FDC STAT READ 0x%02x -> 0x%02x [%s]", shift, $fdc_status, shift;
		if ($fdc_status & 0x02) {
			$fdc_status &= ~0x02 unless $fdc_bytes--;
		}
		$fdc_intrq = 0;
		return $fdc_status;
	},

	0x39 => sub {
		trace "FDC TRACK READ 0x%02x -> 0x%02x [%s]", shift, $fdc_track, shift;
		return $fdc_track;
	},

	0x94 => sub { $_ = 0x01; trace "RTC STAT READ 0x%02x -> 0x%02x [%s]", shift, $_, shift; $_ },
);

#if ($bus_addr == 0x1fffc) { $val = 0x16;
#} elsif ($bus_addr == 0x1fffd) { $val = 0x04;
#} elsif ($bus_addr == 0x1fffe) { $val = 0x00;

our %busmem = (
	0x1fffc => 0x16,
	0x1fffd => 0x04,
	0x1fffe => 0x00,
);

#0x021d: HOST MEM WRITE: 0x0419 <- 0x00 [SYS - Interrupt Vector Register]
#0x021d: HOST MEM WRITE: 0x041a <- 0x00 [SYS - Interrupt Vector Register - Hi]


sub cmd
{
}

for my $p (0..255) {
	$e->add_output_device(address => $p, function => sub {
		my $val = shift;
		# Got a name?
		if (exists $regs{$p}) {
			# Got a handler?
			if (exists $out{$p}) {
				$out{$p}->($p, $val, $regs{$p});
			} else {
				trace "IO WRITE: 0x%02x <- 0x%02x [%s]", $p, $val, $regs{$p};
			}
		} else {
			trace "BAD WRITE: 0x%02x <- 0x%02x", $p, $val;
			die unless $ARGV[0];
		}
	});
	$e->add_input_device(address => $p, function => sub {
		my $val = 0xff;

		# Got a name?
		if (exists $regs{$p}) {
			# Got a handler?
			if (exists $in{$p}) {
				$val = $in{$p}->($p, $regs{$p})
			} else {
				trace "IO READ:  0x%02x -> 0x%02x [%s]", $p, $val, $regs{$p};
			}
		} else {
			trace "BAD READ: 0x%02x", $p;
			die unless $ARGV[0];
		}

		return $val;
	});
}

our %entries;
my $dump;
my $subroutine;
open $dump, '<iop.lst' or die $!;

our %code;
my $entry;
while (<$dump>) {
	chomp;
	s/\r//g;
	$subroutine = undef if /S U B R O U T I N E|^RAM:/;
	/^R[OA]M:/ or next;
	/^R[OA]M:([^\s\*]+)[\s\*]?(\s*(([^\s:]+):)?\s*([^;]*[^\s:])?\s*(;.*)?)$/ or die "[$_]";
	my ($addr, $str, $label, $raw, $comment) = (hex $1, $2, $4, $5 // '', $6);
	if ($label and not $subroutine) {
		$subroutine = $label;
		$entry = $addr;
	} else {
	}
	next if $raw eq '';
	next if $raw eq ';';
	$code{$addr} = [$subroutine, $entry, $label, $raw];
}
$dump = undef;
$code{0x2000} = [ 'SRAM_JUMP_SLOT1', 0x2000, undef, '...' ];
#$code{0x1a48}[1] = 0x1a48;
#$code{0x1ba9}[1] = 0x1ba9;

#use Data::Dumper;
#foreach my $addr (sort { $a <=> $b } keys %code) {
#	warn Dumper [$addr, @{$code{$addr}}];
#}
#die;

sub chcmd
{
	my $ch = shift;

	my $base = 0x041c + (22 * $ch);
	$busmem{$base +  0} = 0xb4;	# Channel Parameter Register
	$busmem{$base +  1} = 0xfe;
	$busmem{$base +  2} = 0x00;	# Channel Status Register
	$busmem{$base +  3} = 0x00;
	$busmem{$base +  4} = 0x81;	# Channel Command Register = INITIALIZE
	$busmem{$base +  5} = 0x00;	# Transmit Data Buffer Address Register
	$busmem{$base +  6} = 0x00;
	$busmem{$base +  7} = 0x00;
	$busmem{$base +  8} = 0x00;	# Transmit Data Buffer Length Register
	$busmem{$base +  9} = 0x00;
	$busmem{$base + 10} = 0xaa;	# Receive Data Buffer Address Register
	$busmem{$base + 11} = 0x09;
	$busmem{$base + 12} = 0x00;
	$busmem{$base + 13} = 0x0a;	# Receive Data Buffer Length Register
	$busmem{$base + 14} = 0x00;
	$busmem{$base + 15} = 0x00;	# Receive Buffer Input Pointer Register
	$busmem{$base + 16} = 0x00;
	$busmem{$base + 17} = 0x00;	# Receive Buffer Output Pointer Register
	$busmem{$base + 18} = 0x00;
	$busmem{$base + 19} = 0x00;	# TTY Receive Register
	$busmem{$base + 20} = 0x00;	# Selectable Rate Register
	$busmem{$base + 21} = 0x00;
}


sub chio
{
	my $ch = shift;

	my $base = 0x041c + (22 * $ch);
	$busmem{$base +  4} = 0x82;	# Channel Command Register = TRANSMIT
	$busmem{$base +  5} = 0x64;	# Transmit Data Buffer Address Register
	$busmem{$base +  6} = 0x09;
	$busmem{$base +  7} = 0x00;
	$busmem{$base +  8} = 0x02;	# Transmit Data Buffer Length Register
	$busmem{$base +  9} = 0x00;
	$busmem{$base + 15} = 0x00;	# Receive Buffer Input Pointer Register
	$busmem{$base + 16} = 0x00;
}



my $orig_tio;
if (not isatty *STDERR) {
	END { IO::Stty::stty (\*STDIN, $orig_tio) if $orig_tio }
	$orig_tio = IO::Stty::stty (\*STDIN, '-g');
	IO::Stty::stty (\*STDIN, qw/-echo -echonl -icanon -iexten/);
}
fcntl STDIN, F_SETFL, O_NONBLOCK;

#use Data::Dumper;
#die Dumper \%dis;




# A:  0x00 F:  00000000 HL:  0x0000
# B:  0x00 C:  0x00                
# D:  0x00 E:  0x00                

# IX: 0x0000 IY: 0x0000 SP: 0x0000 PC: 0x0000

# R:  0x00 I:  0x00
# W:  0x00 Z:  0x00 (internal use only)




#$e->register('PC')->set(0x16c1);
#$e->register('HL')->set(0x1234);
#$e->register('A')->set(0x00);
#$e->register('SP')->set(0x26ff);

#$e->register('PC')->set(0x16a9);
#$e->register('A')->set(0x10);
#$e->register('SP')->set(0x26ff);

#$e->register('PC')->set(0x0356);
my $ni;
$ni = 20000;
my $init = 0;
#while (not defined $ni or $ni--) {
while (1) {
	#if ($insncnt++ > 50000) {
	#if ($insncnt++ > 5000000) {
	#if ($insncnt++ > 800000) {
	if ($insncnt++ > 2000000) {
	#if ($insncnt++ > 21) {
		last;
	}

	my $addr = $e->register('PC')->get;

	#@calls = ('JUMP', 'COROUTINE') if $addr == 0x02c8;
	my ($entry, $label, $dis);
	if (@ARGV) {
		($func, $entry, $label, $dis) = ('unk', 0, undef, '...');
	} else {
		($func, $entry, $label, $dis) = @{$code{$addr}};
	}
	#$func //= 'XD';
	@calls = ($func) unless @calls;
	if ($calls[0] ne $func) {
			#use Data::Dumper;
			#warn Dumper [$func, \@calls]; # if $addr == 0x02c8;
		if ($addr == $entry) {
			#warn sprintf "=== CCAALL {%x}", $addr;
			@calls = () if $calls[0] eq 'COROUTINE';
			unshift @calls, $func;
		} else {
			shift @calls if $calls[0] eq 'COROUTINE';
			#warn sprintf "=== return {%x}", $addr;
			#warn Dumper $code{$addr};
			#@calls = () if shift @calls eq 'COROUTINE';
			shift @calls;
		}
	}
	# elsif ($calls[0] eq 'COROUTINE') {
	#	shift @calls;
	#	shift @calls;
	#}
	unshift @calls, 'COROUTINE' if $addr == 0x02c8;
	trace $dis if $debug;

	##printf STDERR "%s\n", $e->format_registers;
	#trace '| '.($dis{$e->register('PC')->get} // '???') if $debug;

	$e->run(1);
	#next if @ARGV;

	#my $pc = $e->register('PC')->get;
	#if ($pc == 0x001f) {
	if ($insncnt == 15000) {
		if ($init) {
			#die;
		} else {
			trace '=== NMI ===';
			$e->nmi;
			#last;

			warn $e->format_registers;
			#last;
			$init = 1;
		}
	}
	#if ($pc == 0x01d6) {
		if ($insncnt == 30000) {
		#if ($init == 10) {
			trace '=== ENABLE CONTROLLER ===';
			# Command
			$busmem{0x417} = 0x81; # System Command Register = ENABLE CONTROLLER

			$busmem{0x41b}++; # New Command Register
		}
		#if ($init == 20) {
		#	trace '=== INITIALIZE CHANNEL 0 ===';
		#	chcmd(0);
		#	$busmem{0x41b}++; # New Command Register
		#}
		#if ($init == 50) {
		#	trace '=== INITIALIZE CHANNEL 1 ===';
		#	#chcmd(1);
		#	$busmem{0x41b}++; # New Command Register
		#}
		#if ($init == 50) {
		#	trace '=== UNK 0 ===';
		#	$busmem{0x4ea} = 0x81; # RTC!
		#	$busmem{0x41b}++; # New Command Register
		#}
		if ($insncnt == 50000) {
		#if ($init == 100) {
			trace '=== FDC UNK 0 ===';

			# EMU:     0 0x04a0       0x87 Command Register?
			$busmem{0x04a0} = 0x87; # Command -- set floppy params
			$busmem{0x04a1} = 0x00; # Status

			$busmem{0x04a2} = 0x60;	# commands
			$busmem{0x04a3} = 0x09;
			$busmem{0x04a4} = 0x00;
			$busmem{0x04a5} = 0x00;

			$busmem{0x04a6} = 0x02;	# number of entries at above address
			$busmem{0x04a7} = 0x00;

			$busmem{0x04aa+0} = 0x00;
			$busmem{0x04aa+1} = 0x02;

			$busmem{0x04aa+2} = 0x00;
			$busmem{0x04aa+3} = 0x02; # sector size

			$busmem{0x04aa+4} = 0x06;
			$busmem{0x04aa+5} = 0x00;
			$busmem{0x04aa+6} = 0x00;
			$busmem{0x04aa+7} = 0x00;
			$busmem{0x04aa+8} = 0x00;
			$busmem{0x04aa+9} = 0x00;
			$busmem{0x04aa+10} = 0x00;
			$busmem{0x04aa+11} = 0x00;
			$busmem{0x04aa+12} = 0x00;
			$busmem{0x04aa+13} = 0x00;
			$busmem{0x04aa+14} = 0x00;
			$busmem{0x04aa+15} = 0x00;
			$busmem{0x04aa+16} = 0x00;
			$busmem{0x04aa+17} = 0x00;
			$busmem{0x04aa+18} = 0x00;
			$busmem{0x04aa+19} = 0x00;
			$busmem{0x04aa+20} = 0x00;
			$busmem{0x04aa+21} = 0x00;
			$busmem{0x04aa+22} = 0x00;
			$busmem{0x04aa+23} = 0x00;
			$busmem{0x04aa+24} = 0x00;
			$busmem{0x04aa+25} = 0x00;
			$busmem{0x04aa+26} = 0x00;
			$busmem{0x04aa+27} = 0x00;
			$busmem{0x04aa+28} = 0x00;
			$busmem{0x04aa+29} = 0x00;
			$busmem{0x04aa+30} = 0x00;
			$busmem{0x04aa+31} = 0x00;
			$busmem{0x04aa+32} = 0x00;


			$busmem{0x04aa+33} = 0x02;
			$busmem{0x04aa+34} = 0x00;
			$busmem{0x04aa+35} = 0x02;
			$busmem{0x04aa+36} = 0x06;

			$busmem{0x04aa+37} = 0x00;
			$busmem{0x04aa+38} = 0x00;
			$busmem{0x04aa+39} = 0x00;
			$busmem{0x04aa+40} = 0x00;
			$busmem{0x04aa+41} = 0x00;
			$busmem{0x04aa+42} = 0x00;
			$busmem{0x04aa+43} = 0x00;
			$busmem{0x04aa+44} = 0x00;
			$busmem{0x04aa+45} = 0x00;
			$busmem{0x04aa+46} = 0x00;
			$busmem{0x04aa+47} = 0x00;
			$busmem{0x04aa+48} = 0x00;
			$busmem{0x04aa+49} = 0x00;
			$busmem{0x04aa+50} = 0x00;
			$busmem{0x04aa+51} = 0x00;
			$busmem{0x04aa+52} = 0x00;
			$busmem{0x04aa+53} = 0x00;
			$busmem{0x04aa+54} = 0x00;
			$busmem{0x04aa+55} = 0x00;
			$busmem{0x04aa+56} = 0x00;
			$busmem{0x04aa+57} = 0x00;
			$busmem{0x04aa+58} = 0x00;
			$busmem{0x04aa+59} = 0x00;
			$busmem{0x04aa+60} = 0x00;
			$busmem{0x04aa+61} = 0x00;
			$busmem{0x04aa+62} = 0x00;
			$busmem{0x04aa+63} = 0x00;
			$busmem{0x41b}++; # New Command Register




		}


		# 00068560:  00  00  00  00  00  00  00  00  00  00  00  00  00  00  08  40   ...............@
		#                                                                   cmd  stat
		#           RWx RWx RWx RWx RWx RWx RWx RWx RWx RWx RWx RWx RWx RWx RWx RWx
		# 00068570:  e8  85  06  02  01  00  00  00  00  02  00  02  00  00  00  00   ................
		#            ^^^^^^^^^^  ^^  ^^  ^^
		#            addr
		#           RWx RWx RWx RWx RWx RWx RWx RWx rWx rWx RWx RWx rWx rWx rWx rWx

		if ($insncnt == 300000) {
			trace '=== FDC UNK 0 ===';

			foreach (0..0) {
				$busmem{0x13020+4*$_} = 0x20;
				$busmem{0x13021+4*$_} = 0x10;
				$busmem{0x13022+4*$_} = 0x01;
			}


			$busmem{0x11020} = 0x25; # command
			$busmem{0x11021} = 0xeb; # <-- 0x00 on finish
			$busmem{0x11022} = 0x00;
			$busmem{0x11023} = 0x01; # track number
			$busmem{0x11024} = 0x00; # head
			$busmem{0x11025} = 0x01;
			$busmem{0x11026} = 0x06; # buffer lo
			$busmem{0x11027} = 0x47; # buffer mid
			$busmem{0x11028} = 0x01; # buffer hi
			$busmem{0x11029} = 0x00; # x<-- untouched on finish

#			$busmem{0x4a0} = 0x88; # Command 88-8c-8f=f8=c8=cf 83-3f-0f-f0-00-not
#			$busmem{0x4a1} = 0x00; # Status <-- 0x08 then 0x00 on all done
#			$busmem{0x4a2} = 0x20;	# commands
#			$busmem{0x4a3} = 0x30;
#			$busmem{0x4a4} = 0x01;
#			$busmem{0x4a5} = 0x02;
#			$busmem{0x4a6} = 0x01;	# number of entries at above address
#			$busmem{0x4a7} = 0x00;  # number of entries processed <-- 0x01 on done


			$busmem{0x4a0} = 0x8f; # Command 88-8c-8f=f8=c8=cf 83-3f-0f-f0-00-not
			$busmem{0x4a1} = 0x00; # Status <-- 0x08 then 0x00 on all done

			$busmem{0x4a2} = 0x5a;	# commands
			$busmem{0x4a3} = 0xa5;
			$busmem{0x4a4} = 0x01;

			$busmem{0x4a5} = 0x02;
			$busmem{0x4a6} = 0x00;	# number of entries at above address
			$busmem{0x4a7} = 0x00;  # number of entries processed <-- 0x01 on done

			$busmem{0x41b}++; # New Command Register
		}

=cut
		if ($insncnt == 300000) {
		#if ($init == 100) {
			trace '=== FDC UNK 0 ===';

			#foreach (0..63) {
			foreach (0..0) {
				$busmem{0x13020+4*$_} = 0x20;
				$busmem{0x13021+4*$_} = 0x10;
				$busmem{0x13022+4*$_} = 0x01;
			}

			# EMU:     0 0x04a0       0xc8 Command Register?
			#foreach (0..9) {
			#	$busmem{0x11020+$_} = 0xa5;
			#}
			# 1001 0000
			#$busmem{0x11020} = 0x80; # FDC_HANDLER07_NOTHING
			#$busmem{0x11020} = 0x90; # FDC_HANDLER01_SEEK
			#$busmem{0x11020} = 0xa0; # FDC_HANDLER02_WRITE_BUS 0xa0 == 0xaf it seems
			#$busmem{0x11020} = 0xb0; # FDC_HANDLER03_READ_BUS
			#$busmem{0x11020} = 0xc0; # FDC_HANDLER04_CHECK_IS_ZERO
			#$busmem{0x11020} = 0xd0; # FDC_HANDLER05_READ_TRACK
			#$busmem{0x11020} = 0xe0; # FDC_HANDLER06_WRITE_TRACK
			#$busmem{0x11020} = 0xf0; # FDC_HANDLER07_NOTHING

			#$busmem{0x11020} = 0x90; # FDC_HANDLER01_SEEK
			#$busmem{0x11020} = 0x90; # FDC_HANDLER01_SEEK
			#$busmem{0x11020} = 0xa0; # FDC_HANDLER02_WRITE_BUS
			#$busmem{0x11020} = 0xa0; # FDC_HANDLER02_WRITE_BUS  | BAD HOST MEM READ:  0x2800 at emu.pl line 53.
			#$busmem{0x11020} = 0xaf; # FDC_HANDLER02_WRITE_BUS  | BAD HOST MEM READ:  0x2800 at emu.pl line 53.
			#$busmem{0x11020} = 0x20; # FDC_HANDLER02_WRITE_BUS  | BAD HOST MEM READ:  0x2800 at emu.pl line 53.
			#$busmem{0x11020} = 0x20; # Read sector
			#$busmem{0x11020} = 0x30; # Write sector
			$busmem{0x11020} = 0x50; # Read track

			$busmem{0x11021} = 0xff; # something writes 0x80 here, looks like status
			#$busmem{0x11022} = 0x01; # unknown. 0x01, 0x02 bad
			$busmem{0x11022} = 0x00; # has to be zero guess
			$busmem{0x11023} = 0x03; # track number
			$busmem{0x11024} = 0x01; # head
			$busmem{0x11025} = 0x05; # sector

			#$busmem{0x11026} = 0x06; # buffer lo
			#$busmem{0x11027} = 0x47; # buffer mid
			#$busmem{0x11028} = 0x01; # buffer hi
			#$busmem{0x11029} = 0x12; # buffer hi
			# (map { 0x14706+$_ => sprintf ("FDC DATA BUF %d", $_) } 0..511),
			$busmem{0x11026} = 0x06; # buffer lo
			$busmem{0x11027} = 0x47; # buffer mid
			$busmem{0x11028} = 0x01; # buffer hi
			$busmem{0x11029} = 0x00; # buffer hi

			$busmem{0x14706} = 0x5a;


			$busmem{0x4a2} = 0x20;	# commands
			$busmem{0x4a3} = 0x30;
			$busmem{0x4a4} = 0x01;
			$busmem{0x4a5} = 0x00;

			$busmem{0x4a6} = 0x01;	# number of entries at above address
			$busmem{0x4a7} = 0x00;  # number of entries processed

			$busmem{0x04a0} = 0x88; # Command 88-8c-8f=f8=c8=cf 83-3f-0f-f0-00-not
			$busmem{0x04a1} = 0x00; # Status

			$busmem{0x41b}++; # New Command Register
		}
=cut

#
		#if ($init == 100) {
		#	warn '=== OUT CHANNEL 0 ===';
		#	$busmem{0x964} = 0x6a; #ord 'X';
		#	$busmem{0x965} = 0xa6; #ord 'X';
		#	$busmem{0x966} = 0x66; #ord 'X';
		#	$busmem{0x967} = 0xaa; #ord 'X';
		#	chio(0);
		#	$busmem{0x41b}++; # New Command Register
		#}
		#if ($init == 150) {
		#	last;
		#}
	#	$init++;
	#}
=cut
	if ($pc == 0x01e0) {
		if ($init == 200) {
			warn '=== INTERRUPT ===';
			warn $e->format_registers;
			die unless $e->interrupt;
			last;
			$init++;
		}
	}
=cut
}

#use Data::Dumper;
#warn Dumper $code{$e->register('HL')->get};

if ($debug) {
	print $e->format_registers;
	$mem::trace = undef;

	foreach my $addr (0x2000..0x27ff) {
		printf "%04x:", $addr unless $addr % 32;
		printf (' %02x', $m->peek($addr));
		printf "\n" unless ($addr+1) % 32;
		#warn $addr;
	}
}

sub regs { (
0x00 => 'Address Latch - System memory block number (bits 0 thru 4)',
0x20 => 'PIT 0 - Counter 0 provides baud rate for port 3',
0x21 => 'PIT 0 - Counter 1 provides baud rate for port 4',
0x22 => 'PIT 0 - Counter 2 provides baud rate for port 1',
0x23 => 'PIT 0 - Control byte for PIT 0',
0x24 => 'PIT 1 - Counter 0 provides baud rate for port 2',
0x25 => 'PIT 1 - Counter 1 provides baud rate for port 5',
0x26 => 'PIT 1 - Counter 2 timer interrupt',
0x27 => 'PIT 1 - Control byte for PIT 1',
0x28 => 'SIO 0 - Channel A data for serial port 3',
0x29 => 'SIO 0 - Channel A control for serial port 3',
0x2A => 'SIO 0 - Channel B data for serial port 4',
0x2B => 'SIO 0 - Channel B control for serial port 4',
0x2C => 'SIO 1 - Channel A data for serial port 1',
0x2D => 'SIO 1 - Channel A control for serial port 1',
0x2E => 'SIO 1 - Channel B data for serial port 2',
0x2F => 'SIO 1 - Channel B control for serial port 2',
0x30 => 'SIO 2 - Channel A data for serial port 5',
0x31 => 'SIO 2 - Channel A control for serial port 5',
0x32 => 'SIO 2 - Channel B data serial port 6',
0x33 => 'SIO 2 - Channel B control for serial port 6',
0x34 => 'PIO - Data port A',
0x35 => 'PIO - Command port A',
0x36 => 'PIO - Data port B',
0x37 => 'PIO - Command port B',
0x38 => 'FDC - Write command, Read status',
0x39 => 'FDC - Track number',
0x3A => 'FDC - Sector number',
0x3B => 'FDC - Read/Write data',
0x3C => 'DMA - All read and write registers',
0x40 => 'DMA - Clear carrier sense and parity error bit',
0x80 => 'RTC - Counter - thousandths of seconds',
0x81 => 'RTC - Counter - hundredths and tenths of seconds',
0x82 => 'RTC - Counter - seconds',
0x83 => 'RTC - Counter - minutes',
0x84 => 'RTC - Counter - hours',
0x85 => 'RTC - Counter - Day of Week',
0x86 => 'RTC - Counter - Day of Month',
0x87 => 'RTC - Counter - Months',
0x88 => 'RTC - Latches - Thousandths of seconds',
0x89 => 'RTC - Latches - Hundredths and tenths of seconds',
0x8A => 'RTC - Latches - Seconds',
0x8B => 'RTC - Latches - Minutes',
0x8C => 'RTC - Latches - Hours',
0x8D => 'RTC - Latches - Day of the Week',
0x8E => 'RTC - Latches - Day of the Month',
0x8F => 'RTC - Latches - Months',
0x90 => 'RTC - Interrupt Status Register',
0x91 => 'RTC - Interrupt Control Register',
0x92 => 'RTC - Counter Reset',
0x93 => 'RTC - Latch Reset',
0x94 => 'RTC - Status Bit',
0x95 => 'RTC - "GO" Command',
0x96 => 'RTC - Standby Interrupt',
0x9F => 'RTC - Test Mode',
# Not seen:
0x60 => '586T Generate MULTIBUS interrupt', # Controller board, Page 78
) }

sub hostmem { (
0x0416 => 'SYS - Firmware Version Register',
0x0417 => 'SYS - System Command Register',
0x0418 => 'SYS - System Status Register',
0x0419 => 'SYS - Interrupt Vector Register',
0x041b => 'SYS - New Command Register',
0x041c => 'CH 0 - Channel Parameter Register',
0x041e => 'CH 0 - Channel Status Register',
0x0420 => 'CH 0 - Channel Command Register',
0x0421 => 'CH 0 - Transmit Data Buffer Address Register',
0x0424 => 'CH 0 - Transmit Data Buffer Length Register',
0x0426 => 'CH 0 - Receive Data Buffer Address Register',
0x0429 => 'CH 0 - Receive Data Buffer Length Register',
0x042b => 'CH 0 - Receive Buffer Input Pointer Register',
0x042d => 'CH 0 - Receive Buffer Output Pointer Register',
0x042f => 'CH 0 - TTY Receive Register',
0x0430 => 'CH 0 - Selectable Rate Register',
0x0432 => 'CH 1 - Channel Parameter Register',
0x0434 => 'CH 1 - Channel Status Register',
0x0436 => 'CH 1 - Channel Command Register',
0x0437 => 'CH 1 - Transmit Data Buffer Address Register',
0x043a => 'CH 1 - Transmit Data Buffer Length Register',
0x043c => 'CH 1 - Receive Data Buffer Address Register',
0x043f => 'CH 1 - Receive Data Buffer Length Register',
0x0441 => 'CH 1 - Receive Buffer Input Pointer Register',
0x0443 => 'CH 1 - Receive Buffer Output Pointer Register',
0x0445 => 'CH 1 - TTY Receive Register',
0x0446 => 'CH 1 - Selectable Rate Register',
0x0448 => 'CH 2 - Channel Parameter Register',
0x044a => 'CH 2 - Channel Status Register',
0x044c => 'CH 2 - Channel Command Register',
0x044d => 'CH 2 - Transmit Data Buffer Address Register',
0x0450 => 'CH 2 - Transmit Data Buffer Length Register',
0x0452 => 'CH 2 - Receive Data Buffer Address Register',
0x0455 => 'CH 2 - Receive Data Buffer Length Register',
0x0457 => 'CH 2 - Receive Buffer Input Pointer Register',
0x0459 => 'CH 2 - Receive Buffer Output Pointer Register',
0x045b => 'CH 2 - TTY Receive Register',
0x045c => 'CH 2 - Selectable Rate Register',
0x045e => 'CH 3 - Channel Parameter Register',
0x0460 => 'CH 3 - Channel Status Register',
0x0462 => 'CH 3 - Channel Command Register',
0x0463 => 'CH 3 - Transmit Data Buffer Address Register',
0x0466 => 'CH 3 - Transmit Data Buffer Length Register',
0x0468 => 'CH 3 - Receive Data Buffer Address Register',
0x046b => 'CH 3 - Receive Data Buffer Length Register',
0x046d => 'CH 3 - Receive Buffer Input Pointer Register',
0x046f => 'CH 3 - Receive Buffer Output Pointer Register',
0x0471 => 'CH 3 - TTY Receive Register',
0x0472 => 'CH 3 - Selectable Rate Register',
0x0474 => 'CH 4 - Channel Parameter Register',
0x0476 => 'CH 4 - Channel Status Register',
0x0478 => 'CH 4 - Channel Command Register',
0x0479 => 'CH 4 - Transmit Data Buffer Address Register',
0x047c => 'CH 4 - Transmit Data Buffer Length Register',
0x047e => 'CH 4 - Receive Data Buffer Address Register',
0x0481 => 'CH 4 - Receive Data Buffer Length Register',
0x0483 => 'CH 4 - Receive Buffer Input Pointer Register',
0x0485 => 'CH 4 - Receive Buffer Output Pointer Register',
0x0487 => 'CH 4 - TTY Receive Register',
0x0488 => 'CH 4 - Selectable Rate Register',
0x048a => 'CH 5 - Channel Parameter Register',
0x048c => 'CH 5 - Channel Status Register',
0x048e => 'CH 5 - Channel Command Register',
0x048f => 'CH 5 - Transmit Data Buffer Address Register',
0x0492 => 'CH 5 - Transmit Data Buffer Length Register',
0x0494 => 'CH 5 - Receive Data Buffer Address Register',
0x0497 => 'CH 5 - Receive Data Buffer Length Register',
0x0499 => 'CH 5 - Receive Buffer Input Pointer Register',
0x049b => 'CH 5 - Receive Buffer Output Pointer Register',
0x049d => 'CH 5 - TTY Receive Register',
0x049e => 'CH 5 - Selectable Rate Register',


0x04a0 => 'CH FDC - Command?',
0x04a1 => 'CH FDC - Status?',
0x04a2 => 'CH FDC - Command Block Pointer Low',
0x04a3 => 'CH FDC - Command Block Pointer - 2',
0x04a4 => 'CH FDC - Command Block Pointer - 3',
0x04a5 => 'CH FDC - Command Block Pointer High',

0x04a6 => 'CH FDC - Command Block Count',
0x04a6 => 'CH FDC - Command Block Done',

# 0x4aa - 0x4e9
(map { 0x04aa+$_ => sprintf ("CH FDC %D", $_) } 0..63),

#EMU: [0x1fffc]  0x0416 Initialization Register
#EMU: [Unknown Registers (Floppy?)] {0x04a0}
#EMU:     0 0x04a0     0x87 Command Register?
#EMU:     1 0x04a1     0x00 Status Register?
#EMU:     2 0x04a2   0x0960 Some Buffer?
#EMU:    12 0x04ac   0x0200 Sector size?


0x04ea => 'CH RTC CMD',
0x04eb => 'CH RTC 1',
0x04ec => 'CH RTC 2',
0x04ed => 'CH RTC 3',
0x04ee => 'CH RTC 4',
0x04ef => 'CH RTC 5',
0x04f0 => 'CH RTC 6',
0x04f1 => 'CH RTC 7',
0x04f2 => undef,
#0x04eb => undef, # guards

0x964 => 'CH0 TX BUFFER [0]',
0x965 => 'CH0 TX BUFFER [1]',
0x966 => 'CH0 TX BUFFER [2]',
0x967 => 'CH0 TX BUFFER [3]',

(map { 0x11020+$_ => sprintf ("FDC COMMAND BUF %d", $_) } 0..9),
(map { 0x13020+4*$_ => sprintf ("FDC COMMAND BUF PTR %d", $_) } 0..63),

(map { 0x14706+$_ => sprintf ("FDC DATA BUF %d", $_) } 0..511),
#(map { 0x14706+$_ => sprintf ("FDC DATA BUF %d", $_) } 0..2019),
#(map { 0x14706+$_ => sprintf ("FDC DATA BUF2 %d", $_) } 2020..4095),

0x1fffc => 'Low Controller Control Word',
0x1fffd => 'Mid Controller Control Word',
0x1fffe => 'High Controller Control Word',

0x3008 => 'OLD FIRMWARE FETCHES THIS. WHY',
) }
