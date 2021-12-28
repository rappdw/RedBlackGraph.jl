using RedBlackGraph
using Test

function lookup_relationships()
    @test lookup_relationship(0, 0) == "self"
    @test lookup_relationship(0, 1) == "parent"
    @test lookup_relationship(0, 2) == "grandparent"
    @test lookup_relationship(0, 3) == "great grandparent"
    @test lookup_relationship(0, 4) == "2nd great grandparent"
    @test lookup_relationship(1, 1) == "sibling"
    @test lookup_relationship(1, 2) == "aunt/uncle"
    @test lookup_relationship(1, 3) == "great aunt/uncle"
    @test lookup_relationship(1, 4) == "2nd great aunt/uncle"
    @test lookup_relationship(2, 1) == "aunt/uncle"
    @test lookup_relationship(2, 2) == "1st cousin"
    @test lookup_relationship(2, 3) == "1st cousin 1 removed"
    @test lookup_relationship(2, 4) == "1st cousin 2 removed"
end

function test_cousins()
    r = red_one(1)
    o = one(r)
    a = [r, 2, 3, 4, 5, 6, 7, 0, 0, 0, 0, 0]
    b = [0, 0, 0, 0, 0, 6, 7, o, 2, 3, 4, 5]
    rel = calculate_relationship(a, b)
    @test rel.common_ancestor == 6
    @test rel.individual_a == 1
    @test rel.individual_b == 8
    @test rel.a_to_ancestor == 6
    @test rel.b_to_ancestor == 6
    @test lookup_relationship(rel) == "1st cousin"
end

@testset "relationship" begin
    lookup_relationships()
    test_cousins()
end
