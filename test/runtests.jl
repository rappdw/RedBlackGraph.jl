using RedBlackGraph
using Test

function test_basic_properties(T::Type)
    r1 = red_one(T)
    @test typeof(r1) == T
    zip = T(0)
    @test typeof(zip) == T
    eins = T(1)
    @test typeof(eins) == T
    @test r1 != eins
    @test r1 != zip

    @test typemin(T) == zip
end

function test_basic_avos_sum(T1::Type, T2::Type)
    @test T1(0) + T2(1) == T2(1)
    @test T1(1) + T2(1) == T1(1)
    @test T1(1) + T2(2) == T1(1)
end

function test_basic_avos_product(T1::Type, T2::Type)
    @test T1(0) * T2(1) == 0
    @test T1(1) * T2(1) == 1
    @test T1(1) * T2(2) == 2
    @test T1(2) * T2(2) == 4
    @test T1(2) * T2(3) == 5
    @test T1(3) * T2(2) == 6
    @test T1(3) * T2(3) == 7
end



@testset "RedBlackGraph.jl" begin
    test_basic_properties(AInt8)
    test_basic_properties(AInt16)
    test_basic_properties(AInt32)
    test_basic_properties(AInt64)
    test_basic_properties(AInt128)
    
#     test_basic_avos_sum(AInt8, AInt8)
#     test_basic_avos_sum(AInt16, AInt16)
#     test_basic_avos_sum(AInt32, AInt32)
#     test_basic_avos_sum(AInt64, AInt64)
#     test_basic_avos_sum(AInt128, AInt128)
#
#     test_basic_avos_product(AInt8, AInt8)
#     test_basic_avos_product(AInt16, AInt16)
#     test_basic_avos_product(AInt32, AInt32)
#     test_basic_avos_product(AInt64, AInt64)
#     test_basic_avos_product(AInt128, AInt128)
end
