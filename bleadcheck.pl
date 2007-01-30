#!/usr/bin/perl

# A script to check a local copy against bleadperl, generating a blead
# patch if they're out of sync.  An optional directory argument will
# be chdir()-ed into before comparing.

use strict;
chdir shift() if @ARGV;

my $blead = "~/Downloads/perl/bleadperl";


diff( "$blead/lib/ExtUtils/ParseXS.pm", "lib/ExtUtils/ParseXS.pm");

diff( "$blead/lib/ExtUtils/ParseXS/t", "t",
      '.svn' );

######################
sub diff {
  my ($first, $second, @skip) = @_;
  local $_ = `diff -ur $first $second`;

  for my $x (@skip) {
    s/^Only in .* $x\n//m;
  }
  print;
}
