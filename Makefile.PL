use ExtUtils::MakeMaker;
WriteMakefile(
  'NAME' => 'ExtUtils::ParseXS',
  'VERSION_FROM' => 'lib/ExtUtils/ParseXS.pm',
  'PREREQ_PM' => {
    'Carp' => 0,
    'Cwd' => 0,
    'DynaLoader' => 0,
    'Exporter' => 0,
    'ExtUtils::CBuilder' => 0,
    'File::Basename' => 0,
    'File::Spec' => 0,
    'Symbol' => 0,
    'Test::More' => '0.47'
  },
  ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
    (ABSTRACT_FROM  => 'lib/ExtUtils/ParseXS.pod',
     AUTHOR         => 'Ken Williams <ken@mathforum.org>') : ()),
  'INSTALLDIRS' => ($] < 5.008009 ? 'site' : 'perl'),
  #'EXE_FILES' => ['script/xsubpp'],
  'PL_FILES' => {}
);
