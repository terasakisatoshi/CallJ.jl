#include <uv.h>
#include <julia.h>

void jlinit(int argc, char *argv[]){
  // initialization of libuv and julia
  uv_setup_args(argc, argv);
  libsupport_init();
  jl_parse_opts(&argc, &argv);
  // JULIAC_PROGRAM_LIBNAME defined on command-line for compilation
  jl_options.image_file = JULIAC_PROGRAM_LIBNAME;
  julia_init(JL_IMAGE_JULIA_HOME);
}
