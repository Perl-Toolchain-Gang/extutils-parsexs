#!/usr/bin/perl
use strict;
use warnings;
use Carp;
use Cwd qw(cwd);
use File::Temp qw( tempdir );
use Test::More tests =>  2;
use ExtUtils::ParseXS::Utilities qw(
  process_typemaps
);

my $startdir  = cwd();
{
    my ($type_kind_ref, $proto_letter_ref, $input_expr_ref, $output_expr_ref);
    my $typemap = 'typemap';
    my $tdir = tempdir( CLEANUP => 1 );
    chdir $tdir or croak "Unable to change to tempdir for testing";
    eval {
        ($type_kind_ref, $proto_letter_ref, $input_expr_ref, $output_expr_ref)
            = process_typemaps( $typemap, $tdir );
    };
    like( $@, qr/Can't find \Q$typemap\E in \Q$tdir\E/, #'
        "Got expected result for no typemap in current directory" );
    chdir $startdir;
}

{
    my ($type_kind_ref, $proto_letter_ref, $input_expr_ref, $output_expr_ref);
    my $typemap = [ qw( pseudo typemap ) ];
    my $tdir = tempdir( CLEANUP => 1 );
    chdir $tdir or croak "Unable to change to tempdir for testing";
    open my $IN, '>', 'typemap' or croak "Cannot open for writing";
    print $IN "\n";
    close $IN or croak "Cannot close after writing";
    eval {
        ($type_kind_ref, $proto_letter_ref, $input_expr_ref, $output_expr_ref)
            = process_typemaps( $typemap, $tdir );
    };
    like( $@, qr/Can't find pseudo in \Q$tdir\E/, #'
        "Got expected result for no typemap in current directory" );
    chdir $startdir;
}



## Make sure that the entries in last-most typemap files listed in the
## array-ref passed to process_typemaps() actually take precedence over
## the entries in the files that come before.
##
## The next two test blocks will verify that this is working properly.


# A user-supplied file should take precedence over any global typemaps.
{
    my @tfiles = (
       [ 'typemap-foo' => "TYPEMAP\n".
                          "int            T_FOO_INT\n" ]
    );
    
    my $typemap = [ 'typemap-foo' ];
    my $tdir = tempdir( CLEANUP => 1 );
    chdir $tdir or croak "Unable to change to tempdir for testing";
    
    for (@tfiles) {
       open my $fh, '>', $_->[0] or croak "Cannot open for writing";
       print $fh $_->[1];
       close $fh or croak "Cannot close after writing";
    }
    
    my $t; 
    eval { $t = process_typemaps( $typemap, $tdir ) };
    
    croak "Got invalid object from process_typemaps()"
       unless ref($t) eq 'ExtUtils::Typemaps';
    
    my $xs_int_type  = $t->get_typemap(ctype => 'int')->xstype;
    my $xs_uint_type = $t->get_typemap(ctype => 'unsigned int')->xstype;
    
    like($xs_int_type, qr/T_FOO_INT/, # From 'typemap-foo' file.
       'Last typemap file passed to process_typemaps() takes precedence'
    );
    
    chdir $startdir;
}


# A user-supplied file should take precedence over a root 'typemap' file.
{
    my @tfiles = (
       [ 'typemap'     => "TYPEMAP\n".
                          "int            T_ROOT_INT\n" ],
       
       [ 'typemap-foo' => "TYPEMAP\n".
                          "int            T_FOO_INT\n" ]
    );
    
    my $typemap = [ 'typemap-foo' ];
    my $tdir = tempdir( CLEANUP => 1 );
    chdir $tdir or croak "Unable to change to tempdir for testing";
    
    for (@tfiles) {
       open my $fh, '>', $_->[0] or croak "Cannot open for writing";
       print $fh $_->[1];
       close $fh or croak "Cannot close after writing";
    }
    
    my $t; 
    eval { $t = process_typemaps( $typemap, $tdir ) };
    
    croak "Got invalid object from process_typemaps()"
       unless ref($t) eq 'ExtUtils::Typemaps';
    
    my $xs_int_type  = $t->get_typemap(ctype => 'int')->xstype;
    my $xs_uint_type = $t->get_typemap(ctype => 'unsigned int')->xstype;
    
    like($xs_int_type, qr/T_FOO_INT/, # From 'typemap-foo' file.
       'Last typemap file passed to process_typemaps() takes precedence'
    );
    
    chdir $startdir;
}

