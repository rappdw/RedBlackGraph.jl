using RedBlackGraph
using Graphs
using Test

@testset "Graph Tests" begin
    r = red_one(1)

    A = [
        r 2 3 0 0;
        0 r 0 2 0;
        0 0 1 0 0;
        0 0 0 r 0;
        2 0 0 0 1
        ]

    R = RBGraph(A, 4)
    @test nv(R) == 5
    @test ne(R) == 4
    @test outneighbors(R, 1) == [2, 3]
    @test inneighbors(R, 1) == [5]
    @test all_neighbors(R, 1) == [2, 3, 5]

    v = topological_sort_by_dfs(R)
    @test v == [5, 1, 3, 2, 4]

    A = [
        r 0 0 2 0 3 0;
        0 r 0 0 0 0 0;
        2 0 1 0 0 0 0;
        0 0 0 r 0 0 0;
        0 2 0 0 r 0 3;
        0 0 0 0 0 1 0;
        0 0 0 0 0 0 1;
        ]
    R = RBGraph(A, 5)
    v = connected_components(R)
    @test length(v) == 2
end
