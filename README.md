# CallJ.jl

Building a shared object of Julia package using PackageCompiler and call it from C

# Usage 

```console
$ make
```

## Call Julia from Rust (Optional)

- (tested on my mac)

```
$ make rustrun
./rustrun
Hello World!
```

# References

- [simonbyrne/libcg](https://github.com/simonbyrne/libcg)
- [PackageCompiler](https://github.com/JuliaLang/PackageCompiler.jl)
