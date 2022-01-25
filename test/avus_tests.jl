using RedBlackGraph
using Graphs
using Test

function test_basic_properties(T::Type)
    zip = zero(T)
    @test typeof(zip) == T
    eins = one(T)
    @test typeof(eins) == T
    r1 = red_one(T)
    @test typeof(r1) == T

    @test r1 != eins
    @test r1 != zip

    @test typemin(T) == zip
    max = typemax(T)
    @test unsigned(max) < unsigned(r1)

    @test r1 < eins

    @test eins > r1

    second_r1 = red_one(eins)
    @test second_r1 == r1

    @test iseven(r1)
    @test !iseven(eins)
    @test iseven(zip)
end

function test_basic_avus_sum(T1::Type, T2::Type)
    @test T1(0) + T2(1) == T2(1)
    @test T1(1) + T2(1) == T1(1)
    @test T1(1) + T2(2) == T1(1)
end

function test_basic_avus_product(T1::Type, T2::Type)
    @test T1(0) * T2(1) == 0
    @test T1(1) * T2(1) == 1
    @test T1(1) * T2(2) == 2
    @test T1(2) * T2(2) == 4
    @test T1(2) * T2(3) == 5
    @test T1(3) * T2(2) == 6
    @test T1(3) * T2(3) == 7
end

function test_as_dict_key(T::Type)
    r = red_one(T)
    d = Dict()
    d[r] = "Test"
    @test d[r] == "Test"
end

function test_get_default_val(T::Type)
    i = one(T)
    d = Dict{T, T}()
    l = T(2)
    result = get!(d, l, i)
    @test result == i
end

function test_graph_components(T::Type)
    a = Vector{T}()
    push!(a, T(1))
    push!(a, T(1))
    push!(a, T(1))
    push!(a, T(2))
    push!(a, T(1))
    push!(a, T(2))
    c = Graphs.components(a)
    @test length(c) == 2
end

function test_equality_against_wider_types()
    types = [AInt8, AInt16, AInt32, AInt64, AInt128]
    for (l, T1) in enumerate(types)
        for i in l+1:length(types)
            T2 = types[i]
            @test one(T1) == one(T2)
            @test T1(2) == T2(2)
            @test zero(T1) == zero(T2)
            @test red_one(T1) == red_one(T2)
        end
    end
end

@testset "Basic Avus Tests" begin
    test_basic_properties(AInt8)
    test_basic_properties(AInt16)
    test_basic_properties(AInt32)
    test_basic_properties(AInt64)
    test_basic_properties(AInt128)

    test_equality_against_wider_types()

    test_as_dict_key(AInt8)
    test_as_dict_key(AInt16)
    test_as_dict_key(AInt32)
    test_as_dict_key(AInt64)
    test_as_dict_key(AInt128)
    
    test_get_default_val(AInt8)
    test_get_default_val(AInt16)
    test_get_default_val(AInt32)
    test_get_default_val(AInt64)
    test_get_default_val(AInt128)

    # test_graph_components(AInt8)
    # test_graph_components(AInt16)
    # test_graph_components(AInt32)
    # test_graph_components(AInt64)
    # test_graph_components(AInt128)

    test_basic_avus_sum(AInt8, AInt8)
    test_basic_avus_sum(AInt16, AInt16)
    test_basic_avus_sum(AInt32, AInt32)
    test_basic_avus_sum(AInt64, AInt64)
    test_basic_avus_sum(AInt128, AInt128)

    test_basic_avus_product(AInt8, AInt8)
    test_basic_avus_product(AInt16, AInt16)
    test_basic_avus_product(AInt32, AInt32)
    test_basic_avus_product(AInt64, AInt64)
    test_basic_avus_product(AInt128, AInt128)
end
