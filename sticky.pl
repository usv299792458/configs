# ATTENTION !!!
# Do not edit .doc file with MS Word. Only openoffice can be used.

# NOTE: aptitude install catdoc libdatetime-format-natural-perl smbclient

# NOTE: on windows do: Мой компьютер - управление - Службы и приложения - службы - Служба сообщений - свойства - тип запуска авто, пуск, применить , ок

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
    for ( qw/komp usv-6 usv11 usv-15/ ) {
      system "echo '$task\nАВТОР: $who' | smbclient -N -M $_";
    }
  }
}

