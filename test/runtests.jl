using SafeTestsets

@safetestset "Basic Avos Tests" begin include("avos_tests.jl") end
@safetestset "Shortest Paths Tests" begin include("shortestpaths_test.jl") end
@safetestset "Relationship Tests" begin include("relationship_test.jl") end