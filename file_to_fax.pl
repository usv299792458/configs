BEGIN { $^W = 1 }
use strict;

# NOTE: "hylafax-server" package is necessary for this program to work.

mkdir '/file_to_fax'
  or $! eq 'File exists' ||
    die 'ERROR: ustanovite konstantu DATA_DISK v pravil\'noe znachenie';

for my $file ( glob '/file_to_fax/*.b64' ) { eval {

 die unless $file;

  ( my $name = $file ) =~ s/.*\/(.*)\..*/$1/;
  ( my $phone_num = $name ) =~ s/.*fax-([^-]+).*/$1/;
  rename $file, '/file_to_fax/done/'.$name.'.b64' or die;
  $file= '/file_to_fax/done/'.$name.'.b64';
  my @args = ("uudecode", $file);
  if ( system(@args) == 0 ) { unlink $file }
  else { die }
  system "sendfax -n -d $phone_num " . '/file_to_fax/done/'."$name";
} }

