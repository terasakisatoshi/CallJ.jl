#include <stdio.h>
#include <stdlib.h>

#include <uv.h>
#include <julia.h>
#include "callj.h"

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

  size_t len = 5;
  int *x = (int *)malloc(len * sizeof(int));
  for (int i = 0; i < len; i++)
  {
    x[i] = i;
  }
  printf("show initial Array x\n");
  for (int i = 0; i < len; i++)
  {
    printf("x[%d]=%d\n", i, x[i]);
  }

  greet();
  printf("calc max of Array x");
  printf("jlmax(x)=%d\n", jlmax(x, len));
  
  printf("apply jlminus to Array x\n");
  jlminus(x, len);

  printf("calc min of Array x\n");
  printf("jlmin(jlminus(x))=%d\n", jlmin(x, len));
  for (int i = 0; i < len; i++)
  {
    printf("x[%d]=%d\n", i, x[i]);
  }

  printf("apply jlreverse to Array x\n");
  jlreverse(x, len);
  for (int i = 0; i < len; i++)
  {
    printf("x[%d]=%d\n", i, x[i]);
  }

  free(x);
  int ret = 0;
  jl_atexit_hook(ret);

  return ret;
}