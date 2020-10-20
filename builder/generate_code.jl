function generate_C_source(array_type::Union{Symbol, AbstractString})

if Symbol(array_type) == :int
  type_format = "%d"
elseif Symbol(array_type) == :long
  type_format = "%ld"
elseif Symbol(array_type) == :float
  type_format = "%f"
elseif Symbol(array_type) == :double
  type_format = "%lf"
else
  error("Invalid array_type. Expected double or int, actual=$(array_type)")
end

template = """
#include <stdio.h>
#include <stdlib.h>

#include <uv.h>
#include <julia.h>
#include "callj_$(array_type).h"

JULIA_DEFINE_FAST_TLS()

int main(int argc, char *argv[])
{
  // initialization of libuv and julia
  uv_setup_args(argc, argv);
  libsupport_init();
  jl_parse_opts(&argc, &argv);
  // JULIAC_PROGRAM_LIBNAME defined on command-line for compilation
  jl_options.image_file = JULIAC_PROGRAM_LIBNAME;
  julia_init(JL_IMAGE_JULIA_HOME);

  size_t len = 6;
  $(array_type) *x = ($(array_type) *)malloc(len * sizeof($(array_type)));
  for (int i = 0; i < len; i++)
  {
    x[i] = ($(array_type))i;
  }
  printf("show initial Array x\\n");
  for (int i = 0; i < len; i++)
  {
    printf("x[%d]=$(type_format)\\n", i, x[i]);
  }

  greet();
  printf("calc max of Array x");
  printf("jlmax(x)=$(type_format)\\n", jlmax(x, len));
  
  printf("apply jlminus to Array x\\n");
  jlminus(x, len);

  printf("calc min of Array x\\n");
  printf("jlmin(jlminus(x))=$(type_format)\\n", jlmin(x, len));
  for (int i = 0; i < len; i++)
  {
    printf("x[%d]=$(type_format)\\n", i, x[i]);
  }

  printf("apply jlreverse to Array x\\n");
  jlreverse(x, len);
  for (int i = 0; i < len; i++)
  {
    printf("x[%d]=$(type_format)\\n", i, x[i]);
  }

  free(x);
  int ret = 0;
  jl_atexit_hook(ret);

  return ret;
}
"""

open("main_$(array_type).c", "w") do f
  print(f, template)
end

end

function generate_C_header(array_type::Union{Symbol, AbstractString})
array_type = Symbol(array_type)

template = """
// Julia headers (for initialization and gc commands)
#include "uv.h"
#include "julia.h"

// prototype of the C entry points in our application
void greet(void);
$(array_type) jlmax($(array_type) *cx, size_t len);
$(array_type) jlmin($(array_type) *cx, size_t len);
int jlminus($(array_type) *cx, size_t len);
int jlreverse($(array_type) *cx, size_t len);
"""

open("callj_$(array_type).h", "w") do f
  print(f, template)
end

end

function generate(array_type::Union{Symbol, AbstractString})
  generate_C_source(array_type)
  generate_C_header(array_type)
end

#=
for t in [:int, :long, :float, :double]
  generate(t)
end
=#

generate(:int)
