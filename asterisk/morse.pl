#!/usr/bin/perl -w
use strict;

use Asterisk::AGI;
use List::Util 'shuffle';
use Digest::MD5 qw(md5_hex);

my $AGI = new Asterisk::AGI;

my $num = $AGI->get_data('beep', 15000, 2);

if ( $num == 99 ) {
  open F, '/home/user/morse.txt';
  my @lines = <F>;
  close F;

  my $text = $lines[rand@lines];
  my $hash = md5_hex($text);

  my $sounddir = "/var/lib/asterisk/sounds/tts";
  my $wavefile = "$sounddir/"."tts-$hash.wav";

  unless (-f $wavefile) {
    chomp $text;
    my $execf="echo $text | text2wave -scale 1.5 -F 8000 -o $wavefile";
    system($execf);
  }
  $wavefile =~ s/.wav$//;

  $AGI->exec('Morsecode', $text);
  $AGI->exec('Playback', $wavefile);
}
elsif ( $num == 00 ) {
  $AGI->exec('MP3Player','/home/user/130903_20WPM.mp3');
}
else {
  my $alph = 'kmrsuaptlowi.njef0yvg5q9zh38b?427c1d6x';
  my @a=split(//,substr$alph,0,$num);
  while (1) {
    $AGI->exec('Morsecode', "@a" . ' ');
    @a = shuffle(@a);
  }
}
__END__
#System(echo "This is a test of Festival" | /usr/bin/text2wave -scale 1.5 -F 8000 -o /tmp/festival.wav)


#!/usr/bin/perl

use Asterisk::AGI;
use File::Basename;
use Digest::MD5 qw(md5_hex);

$AGI = new Asterisk::AGI;

my %input = $AGI->ReadParse();

my $f = $ARGV[0];
my $text = "@ARGV";
if (open(F, "$f")) {
  local $/;
  $text = <F>;
}
my $hash = md5_hex($text);
my $sounddir = "/var/lib/asterisk/sounds/tts";
my $wavefile = "$sounddir/"."tts-$hash.wav";

unless (-f $wavefile) {
 open(fileOUT, ">$sounddir"."/say-text-$hash.txt");
 print fileOUT "$text";
 close(fileOUT);

 my $execf="text2wave -eval '(voice_msu_ru_nsh_clunits)' $sounddir/say-text-$hash.txt -F 8000 -o $wavefile";
 system($execf);
 unlink($sounddir."/say-text-$hash.txt");
}
$wavefile =~ s/.wav$//;

$AGI->exec('Playback', $wavefile);
