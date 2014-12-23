BEGIN { $^W = 1 }
use strict;

use DateTime;
use DateTime::Format::Natural;

open DOC, 'catdoc -t -w /home/doc/0_ПАМЯТКИ_ОБЩИЕ.doc |';
while(<DOC>) {
 next unless /^&?([^&]+)&([^&]+)&(.*)..$/;
  my ($date_str,$task,$who)=($1,$2,$3);
 next if $who =~ /&/;
  my $parser = DateTime::Format::Natural->new;
  my $date = $parser->parse_datetime($date_str);

  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime;
  my $now = DateTime->new( year   => $year+1900,
                           month  => $mon+1,
                           day    => $mday,
                           hour   => $hour,
                           minute => $min,
                           second => $sec,
                         );

  my $d = $now->subtract_datetime( $date );
  if ( $d->is_positive ) {
    for ( [ '192.168.40.190', 'debian' ], [ '192.168.40.152', 'usv-6' ], [ '192.168.40.159', 'usv11' ], [ '192.168.40.175', 'usv-15' ] ) {
      system "echo '$task\nАВТОР: $who' | smbclient -N -M ${$_}[1] -I ${$_}[0]";
    }
  }
}

