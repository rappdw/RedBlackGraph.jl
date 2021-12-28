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

function test_calc_relationships()
    r = red_one(1)
    o = one(r)
    # my daughter, me
    u = [r, 0]
    v = [ 2, o]
    @test lookup_relationship(calculate_relationship(u, v)) == "parent"

    # my daughter, my father
    u = [r, 0]
    v = [4, o]
    @test lookup_relationship(calculate_relationship(u, v)) == "grandparent"

    # my son, my maternal grandmother
    u = [ o,  0]
    v = [ 11, r]
    @test lookup_relationship(calculate_relationship(u, v)) == "great grandparent"

    # 2nd great grandparent
    u = [ o,  0]
    v = [ 16, r]
    @test lookup_relationship(calculate_relationship(u, v)) == "2nd great grandparent"

    # 3rd great grandparent
    u = [ o,  0]
    v = [ 32, r]
    @test lookup_relationship(calculate_relationship(u, v)) == "3rd great grandparent"

    # 4th great grandparent
    u = [ o,  0]
    v = [ 64, r]
    @test lookup_relationship(calculate_relationship(u, v)) == "4th great grandparent"

    # myself, my brother
    u = [ r, 0, 2]
    v = [ 0, r, 2]
    @test lookup_relationship(calculate_relationship(u, v)) == "sibling"

    # myself, my uncle
    u = [ r, 0, 4]
    v = [ 0, r, 2]
    @test lookup_relationship(calculate_relationship(u, v)) == "aunt/uncle"

    # myself, my cousin
    u = [ r, 0, 4]
    v = [ 0, r, 4]
    @test lookup_relationship(calculate_relationship(u, v)) == "1st cousin"

    # myself, my 2nd cousin
    u = [ r, 0, 8]
    v = [ 0, r, 8]
    @test lookup_relationship(calculate_relationship(u, v)) == "2nd cousin"

    # myself, my 3rd cousin
    u = [ r, 0, 16]
    v = [ 0, r, 16]
    @test lookup_relationship(calculate_relationship(u, v)) == "3rd cousin"

    # myself, my 4th cousin
    u = [ r, 0, 32]
    v = [ 0, r, 32]
    @test lookup_relationship(calculate_relationship(u, v)) == "4th cousin"

    # myself, my cousin once remove
    u = [ r, 0, 4]
    v = [ 0, r, 8]
    @test lookup_relationship(calculate_relationship(u, v)) == "1st cousin 1 removed"

    # myself, my 2nd cousin
    u = [ r, 0, 8]
    v = [ 0, r, 16]
    @test lookup_relationship(calculate_relationship(u, v)) == "2nd cousin 1 removed"

    # myself, my 3rd cousin
    u = [ r, 0, 16]
    v = [ 0, r, 32]
    @test lookup_relationship(calculate_relationship(u, v)) == "3rd cousin 1 removed"

    # myself, my 4th cousin
    u = [ r, 0, 32]
    v = [ 0, r, 64]
    @test lookup_relationship(calculate_relationship(u, v)) == "4th cousin 1 removed"

    # no relationship
    u = [ r, 0]
    v = [ 0, r]
    @test lookup_relationship(calculate_relationship(u, v)) == "No Relationship"
end

@testset "relationship" begin
    lookup_relationships()
    test_calc_relationships()
end
