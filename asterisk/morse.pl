#!/usr/bin/perl
use Asterisk::AGI;
$AGI = new Asterisk::AGI;
open F, '/home/user/morse.txt';
my @lines = <F>;
close F;
$AGI->exec('Morsecode', $lines[rand@lines]);

