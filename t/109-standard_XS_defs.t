#!/usr/bin/perl
use strict;
use warnings;
use Capture::Tiny qw( capture );
use Test::More qw(no_plan); # tests =>  7;
use lib qw( lib );
use ExtUtils::ParseXS::Utilities qw(
    standard_XS_defs
);

my @statements = (
    '#ifndef PERL_UNUSED_VAR',
    '#ifndef PERL_ARGS_ASSERT_CROAK_XS_USAGE',
    '#ifdef PERL_IMPLICIT_CONTEXT',
    '#ifdef newXS_flags',
);

my ($stdout, $stderr);
($stdout, $stderr) = capture{
    standard_XS_defs();
};

foreach my $s (@statements) {
    like( $stdout, qr/$s/s, "Printed <$s>" );
}

pass("Passed all tests in $0");
