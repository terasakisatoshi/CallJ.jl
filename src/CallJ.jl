module CallJ

ALL_TYPES=[Cint, Clong, Cfloat, Cdouble]

TYPES=[Cdouble]

Base.@ccallable greet()::Cvoid = println("Hello World!")

for T in TYPES
    @eval Base.@ccallable function gettype(x::$(T))::Cvoid
        @show typeof(x)
        return nothing
    end
end

for T in TYPES
    @eval Base.@ccallable function f(x::$(T))::$(T)
        return x
    end

    @eval Base.@ccallable function f(x::$(T), y::$(T))::$(T)
        return x + y
    end

    @eval Base.@ccallable function f(x::$(T), y::$(T), z::$(T))::$(T)
        return x + y + z
    end
end

for T in TYPES
    @eval Base.@ccallable function jlmax(cx::Ptr{$T}, len::Csize_t)::$T
        x = unsafe_wrap(Array, cx, (len,))
        return  maximum(x)
    end
end

for T in TYPES
    @eval Base.@ccallable function jlmin(cx::Ptr{$T}, len::Csize_t)::$T
        x = unsafe_wrap(Array, cx, (len,))
        return  minimum(x)
    end
end

for T in TYPES
    @eval Base.@ccallable function jlminus(cx::Ptr{$T}, len::Csize_t)::Cint
        x = unsafe_wrap(Array, cx, (len,))
        for i in 1:length(x)
            x[i] = -one($T)*x[i]
        end
        return 0
    end
end

for T in TYPES
    @eval Base.@ccallable function jlreverse(cx::Ptr{$T}, len::Csize_t)::Cint
        x = unsafe_wrap(Array, cx, (len,))
        reverse!(x)
        return 0
    end
end

end # module
