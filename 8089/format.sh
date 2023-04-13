set -e
set -x
expand iop3268.asm |perl iopfmt.pl >iop3268.me
expand hd-test.asm |perl iopfmt.pl >hd-test.me
