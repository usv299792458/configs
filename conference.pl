#!/usr/bin/perl
use strict;

$|=1;

# Setup some variables
my %AGI;

while(<STDIN>) {
	chomp;
	last unless length($_);
	if (/^agi_(\w+)\:\s+(.*)$/) {
		$AGI{$1} = $2;
	}
}

for( qw(4567) ) {
  open F, '>/var/spool/asterisk/call' . $_;
  print F <<EOF;
Channel: SIP/$_\@ses
Application: ConfBridge
Data: 1234,s
Callerid: Conference
EOF
  close F;
  rename '/var/spool/asterisk/call' . $_, '/var/spool/asterisk/outgoing/call' . $_;
}

