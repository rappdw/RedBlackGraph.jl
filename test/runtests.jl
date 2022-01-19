using SafeTestsets

@safetestset "Basic Avus Tests" begin include("avus_tests.jl") end
@safetestset "Shortest Paths Tests" begin include("shortestpaths_test.jl") end
@safetestset "Relationship Tests" begin include("relationship_test.jl") end
@safetestset "Avus Linear Algebra Tests" begin include("linalg_test.jl") end
@safetestset "Graph Tests" begin include("graph_test.jl") end