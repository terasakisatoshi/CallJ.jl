# Original code is taken from 
# https://github.com/simonbyrne/libcg/blob/master/Makefile

.PHONY: clean, all

OS := $(shell uname)
DLEXT := $(shell julia -e 'using Libdl; print(Libdl.dlext)')

JULIA := julia
JULIA_DIR := $(shell $(JULIA) -e 'print(dirname(Sys.BINDIR))')
MAIN := main
PACKAGENAME := CallJ
LIBNAME := callj

ifeq ($(OS), WINNT)
  MAIN := $(MAIN).exe
endif

ifeq ($(OS), Darwin)
  WLARGS := -Wl,-rpath,"$(JULIA_DIR)/lib" -Wl,-rpath,"@executable_path"
else
  WLARGS := -Wl,-rpath,"$(JULIA_DIR)/lib:$$ORIGIN"
endif

CFLAGS+=-O2 -fPIE -I$(JULIA_DIR)/include/julia
LDFLAGS+=-L$(JULIA_DIR)/lib -L. -ljulia -lm $(WLARGS)

.DEFAULT_GOAL := all

lib${LIBNAME}.$(DLEXT): builder/compile.jl src/${PACKAGENAME}.jl
	$(JULIA) --startup-file=no --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.test()'
	$(JULIA) --startup-file=no --project=builder -e 'using Pkg; Pkg.instantiate()'
	$(JULIA) --startup-file=no --project=builder $<

${MAIN}_int.c ${MAIN}_double.c: builder/generate_code.jl
	$(JULIA) --startup-file=no --project=builder $<

${MAIN}_int.o: ${MAIN}_int.c
	$(CC) $< -c -o $@ $(CFLAGS) -DJULIAC_PROGRAM_LIBNAME=\"lib${LIBNAME}.$(DLEXT)\"

${MAIN}_double.o: ${MAIN}_double.c
	$(CC) $< -c -o $@ $(CFLAGS) -DJULIAC_PROGRAM_LIBNAME=\"lib${LIBNAME}.$(DLEXT)\"

$(MAIN)_int: ${MAIN}_int.o lib${LIBNAME}.$(DLEXT)
	$(CC) -o $@ $< $(LDFLAGS) -l${LIBNAME}
	# run
	./$@

$(MAIN)_double: ${MAIN}_double.o lib${LIBNAME}.$(DLEXT)
	$(CC) -o $@ $< $(LDFLAGS) -l${LIBNAME}
	# run
	./$@

all: $(MAIN)_int $(MAIN)_double
	./$(MAIN)_int
	./$(MAIN)_double

clean:
	$(RM) ${MAIN}_* *.$(DLEXT)
