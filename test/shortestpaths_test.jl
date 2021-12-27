using RedBlackGraph
using Test

function test_floyd_warshall(T::Type)
	r = red_one(T)

	M = [
	r 2 3 0 0;
	0 r 0 2 0;
	0 0 1 0 0;
	0 0 0 r 0;
	2 0 0 0 1
	]
    W = floyd_warshall_transitive_closure(M)
    W_expected = [
	r 2 3 4 0;
	0 r 0 2 0;
	0 0 1 0 0;
	0 0 0 r 0;
	2 4 5 8 1
	]
	@test W == W_expected
end


@testset "shortestpaths" begin
	test_floyd_warshall(AInt8)
	test_floyd_warshall(AInt16)
	test_floyd_warshall(AInt32)
	test_floyd_warshall(AInt64)
	test_floyd_warshall(AInt128)
end
