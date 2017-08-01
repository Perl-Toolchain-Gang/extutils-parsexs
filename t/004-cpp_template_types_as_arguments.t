#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Test::More tests => 3;
use ExtUtils::ParseXS;

chdir('t') if -d 't';

{
my $pxs = ExtUtils::ParseXS->new;

tie *FH, 'Foo';
$pxs->process_file( filename => 'XScpp_template_types_as_arguments.xs', output => \*FH, prototypes => 1, typemap => 'typemap_cpp_template_types_as_arguments', hiertype => 1);

my $content = tied(*FH)->content;

like $content, '/std::map<\s*std::string,\s*std::string\s*>\s+argument\s*=\s*ST\(0\)/', "Output has the function with the template with multiple arguments";
like $content, '/std::map<\s*std::string,\s*std::vector<\s*std::string\s*>\s*>\s+argument_template_nesting\s*=\s*ST\(\d\)/', "Output has the function with the template with nested multiple arguments";
like $content, '/std::pair<\s*std::map<\s*std::string,\s*std::string\s*>,\s*std::vector<\s*double\s*>\s*>\s+argument_left_nesting\s*=\s*ST\(\d\)/', "Output has the function with the template with nested left multiple arguments";
}

#####################################################################

sub Foo::TIEHANDLE { bless {}, 'Foo' }
sub Foo::PRINT { shift->{buf} .= join '', @_ }
sub Foo::content { shift->{buf} }
