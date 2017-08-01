#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#undef do_open
#undef do_close
#ifdef __cplusplus
}
#endif

#include<string>
#include<map>

MODULE=test_template_types_as_arguments
MODULE=test_template_types_as_arguments PACKAGE=test_template_types_as_arguments

int
check_map_of_strings_strings( std::map< std::string, std::string > argument )
  CODE:
      RETVAL = 1;
  OUTPUT: RETVAL

int
check_template_nesting( std::map< std::string, std::vector< std::string > > argument_template_nesting )
  CODE:
      RETVAL = 1;
  OUTPUT: RETVAL

int
check_template_nesting_mixed_multiple_arguments(std::pair< std::map< std::string, std::string >, std::vector<double> > argument_left_nesting, int first, std::map< std::string, std::vector< std::string > > argument_template_nesting_mixed_multiple_arguments, int second, std::vector< double > vector_of_doubles )
  CODE:
      RETVAL = 1;
  OUTPUT: RETVAL
