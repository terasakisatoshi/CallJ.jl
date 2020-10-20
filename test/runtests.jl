using CallJ

using Test

@testset "greet" begin
    @test isnothing(CallJ.greet())
end

for T in CallJ.TYPES
    @eval begin
        @testset "gettype $($T)" begin
            @test isnothing(CallJ.gettype(one($(T))))
        end
    end
end


for T in CallJ.TYPES
    @eval begin
        @testset "f $($T) " begin
            @test one($T) ≈ (CallJ.f(one($T)))
            @test 2 * one($T) ≈ (CallJ.f(one($T), one($T)))
            @test 3 * one($T) ≈ (CallJ.f(one($T), one($T), one($T)))
        end
    end
end

for T in CallJ.TYPES
    @eval begin
        @testset "jlmax $($T)" begin
            x = $(T)[1,2,3,4,5]
            @test $(T)(5) ≈ CallJ.jlmax(pointer(x), length(x)|>UInt)
        end
    end
end


for T in CallJ.TYPES
    @eval begin
        @testset "jlmin $($T)" begin
            x = $(T)[1,2,3,4,5]
            @test one($(T)) ≈ CallJ.jlmin(pointer(x), length(x)|>UInt)
        end
    end
end

for T in CallJ.TYPES
    @eval begin
        @testset "jlminus $($T)" begin
            x = $(T)[1,2,3,4,5]
            expected = $(T)[-1,-2,-3,-4,-5]
            CallJ.jlminus(pointer(x), length(x)|>UInt)
            @test all(x .≈ expected)
        end
    end
end

for T in CallJ.TYPES
    @eval begin
        @testset "jlreverse $($T)" begin
            x = $(T)[1,2,3,4,5]
            expected = $(T)[5,4,3,2,1]
            CallJ.jlreverse(pointer(x), length(x)|>UInt)
            @test all(x .≈ expected)
        end
    end
end
