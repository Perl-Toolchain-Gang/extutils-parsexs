use strict;
use warnings;
use Test::More tests => 2;

use File::Spec;
use Cwd qw(cwd);
use ExtUtils::ParseXS;
use File::Temp qw(tempdir);

my $cwd = cwd();
my $tdir = tempdir( CLEANUP => 1 );
chdir($tdir);
$SIG{TERM} = $SIG{INT} = sub {chdir($cwd); exit(0)};

END { chdir($cwd) }

open my $tmfh, ">", "typemap" or die $!;
print $tmfh <<'HERE';
TYPEMAP
std::map< std::string, std::vector<int> > T_SOMETHING
std::vector<std::vector<double> > * T_OTHER
std::map<std::string, std::string> * T_SOMETHING_ELSE

INPUT
T_SOMETHING
	$var = $arg;
T_SOMETHING_ELSE
	$var = $arg;
T_OTHER
	$var = $arg;

OUTPUT
T_SOMETHING
	$arg = $var;
T_SOMETHING_ELSE
	$arg = $var;
T_OTHER
	$arg = $var;
HERE
close $tmfh or die $!;

open my $xsfh, ">", "Foo.xs" or die $!;
print $xsfh <<'HERE';
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

MODULE = Foo	PACKAGE = Foo

std::map<std::string, std::string> *
mapper(std::map<std::string, std::vector<int> > arg1, std::vector< std::vector< double > > *arg2)
  CODE:
    RETVAL = NULL;
  OUTPUT: RETVAL

HERE
close $xsfh or die $!;

open my $xsfh2, ">", "Bar.xs" or die $!;
print $xsfh2 <<'HERE';
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

MODULE = Foo	PACKAGE = Foo

std::map<std::string, std::string> *
mapper(arg1, arg2)
    std::map<std::string, std::vector<int> > arg1;
    std::vector< std::vector< double > > *arg2;
  CODE:
    RETVAL = NULL;
  OUTPUT: RETVAL

HERE
close $xsfh2 or die $!;

my $pxs = ExtUtils::ParseXS->new;
$pxs->process_file(
  hiertype => 1,
  filename => 'Bar.xs',
  output => 'Bar.c',
);

pass("Processed KR-style parameters");

$pxs->process_file(
  hiertype => 1,
  filename => 'Foo.xs',
  output => 'Foo.c',
);

pass("Processed ANSI-style parameters");
