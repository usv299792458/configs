#!/usr/bin/perl -w
use strict;

use Asterisk::AGI;
use List::Util 'shuffle';

my $AGI = new Asterisk::AGI;
open F, '/home/user/morse.txt';
my @lines = <F>;
close F;

my $num = $AGI->get_data('beep', 15000, 2);
my $alph = 'kmrsuaptlowi.njef0yvg5q9zh38b?427c1d6x';

#$AGI->exec('Morsecode', $lines[rand@lines]);
#my $a = 'a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 ? . ';
my @a=split(//,substr$alph,0,$num);
while (1) {
  $AGI->exec('Morsecode', "@a" . ' ');
  @a = shuffle(@a);
}
