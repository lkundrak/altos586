set -e
set -x

expand hdc/iop3268.asm |perl hdc/iopfmt.pl >hdc/iop3268.me
expand hdc/hd-test.asm |perl hdc/iopfmt.pl >hdc/hd-test.me
groff -U -P-pa4 -ep -t -me -Tpdf re586.me >re586.pdf
