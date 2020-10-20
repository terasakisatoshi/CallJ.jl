using PackageCompiler, Libdl

PackageCompiler.create_sysimage(
	Symbol[:CallJ];
    project=pwd(),
    precompile_execution_file=[joinpath("test", "runtests.jl")],
    sysimage_path="libcallj.$(Libdl.dlext)",
)