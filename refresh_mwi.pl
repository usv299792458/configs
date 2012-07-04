BEGIN { $^W = 1 }
use strict;

my %num = ( );

local @ARGV = 'sudo find /var/spool/asterisk/voicemail/my-common/ -type d -name INBOX |';
{ local $_; while (<>) {
  chomp;
  $num{$1} = 0 if /(\d+)/;
  local *ARGV;      # именно в
  local @ARGV = "sudo find $_ -name msg*.txt |"; # таком порядке
  print '*', "\n" unless @ARGV;
  { local $_; while (<>) {
    chomp;
    $num{$1} = 1 if /(\d+)\//;
  } }
} }
for ( keys %num ) {
  system "/usr/bin/myapp my-common $_ $num{$_} 0";
}

