using RedBlackGraph
using LinearAlgebra
using Test

@testset "Avus Linear Algebra Tests" begin
    r = red_one(1)
    o = one(r)

    # test dot product of myself and father
    u = [r, 2, 3, 0, 0]
    v = [2, r, 0, 0, 0]
    @test u ⋅ v == 2

    # test dot product of myself and mother
    u = [r, 2, 3, 0, 0]
    v = [3, 0, o, 0, 0]
    @test u ⋅ v == 3

    # sample from docs
    u = [2, 0, 0, 0, r]
    v = [3, 0, r, 0, 0]
    @test u ⋅ v == 5

    # test dot product of my daughter and my father
    u = [2, 0, 0, 0, o]
    v = [2, r, 0, 0, 0]
    @test u ⋅ v == 4


    A = [r 2 3 0 0;
         0 r 0 2 0;
         0 0 1 0 0;
         0 0 0 r 0;
         2 0 0 0 1]
    expected_result =  [r 2 3 4 0;
                        0 r 0 2 0;
                        0 0 1 0 0;
                        0 0 0 r 0;
                        2 4 5 0 1]
    result = A * A
    @test result == expected_result

    expected_result =  [r 2 3 4 0;
                        0 r 0 2 0;
                        0 0 1 0 0;
                        0 0 0 r 0;
                        2 4 5 8 1]
    result = A * result
    @test result == expected_result

    A =  [r 2 3 4 0;
          0 r 0 2 0;
          0 0 1 0 0;
          0 0 0 r 0;
          2 4 5 0 1]
    u = [2 0 0 0 0]
    v = [0, 3, 0, 0, 0]

    result = u * A
    u_lambda = [2 4 5 8 0]
    @test result == u_lambda

    result = A * v
    v_lambda = [5; 3; 0; 0; 9]
    @test result == v_lambda

    A = [r 2 3 0 0;
         0 r 0 2 0;
         0 0 1 0 0;
         0 0 0 r 0;
         2 0 0 0 1]
    @test A == A * I

end
