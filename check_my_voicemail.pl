BEGIN { $^W = 1 }
use strict;

local @ARGV = "sudo find /var/spool/asterisk/voicemail/default/incoming/INBOX/ -name msg*.txt |";
{ local $_; while (<>) {
  system "echo 'Голосовая почта' | smbclient -N -M debian";
 last;
} }

