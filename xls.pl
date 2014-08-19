# NOTE: aptitude install libnet-ping-external-perl libspreadsheet-parseexcel-perl smbclient

BEGIN { $^W = 1 }
use strict;

use Encode ();

use Spreadsheet::ParseExcel ();
use Net::Ping::External qw(ping);

my $fmt = Spreadsheet::ParseExcel::FmtDefault->new;
    my $ips;
    my $w = Spreadsheet::ParseExcel::Workbook->Parse( '/home/doc/IP.xls', $fmt )->{Worksheet}[0];
    for ( my $i = $$w{MinRow}+1; defined $$w{MaxRow} && $i <= $$w{MaxRow}; $i++ ) {
      if ( $$w{Cells}[$i][8] && $$w{Cells}[$i][8]->Value ) {
        my $ip = join '.', map { ( $_->Value=~/(\d+)/ )[0] } @{$$w{Cells}[$i]}[0..3];
        unless ( ping(host => $ip, count => 3, timeout => 2) ) {
          $ips.= $ip . ' ' . Encode::encode( 'utf8', ${$$w{Cells}[$i]}[4]->Value ) . "\n";
        }
      }
    }
    if ($ips) {
          my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime;
          $year += 1900;
          $mon+=1;
          for ( qw/192.168.40.190 192.168.40.152 192.168.40.159 192.168.40.175/ ) {
            system "echo '$hour:$min:$sec $mday-$mon-$year НЕ ОТВЕЧАЕТ:\n$ips' | smbclient -N -M debian -I $_";
          }
    }

