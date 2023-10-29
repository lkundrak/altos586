set -e
set -x

expand 8089/iop3268.asm |perl 8089/iopfmt.pl >8089/iop3268.me
expand 8089/hd-test.asm |perl 8089/iopfmt.pl >8089/hd-test.me
groff -P-pa4 -p -t -me -Tpdf re586.me >re586.pdf
