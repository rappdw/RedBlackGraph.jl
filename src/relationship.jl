"""
    struct Relationship

A structure designed to capture the relationship between two individuals
"""
struct Relationship
    common_ancestor::Integer # the vertex id of the common ancestor
    individual_a::Integer # the vertex id of the first individual
    individual_b::Integer # the vertex id of the second individual
    a_to_ancestor::AInteger # the relationship of the first individual to the common ancestor
    b_to_ancestor::AInteger # the relationship of the second individual to the common ancestor
end

function cousinth(generational)
    if generational == 2
        return "1st cousin"
    elseif generational == 3
        return "2nd cousin"
    elseif generational == 4
        return "3rd cousin"
    else
        return "$(generational - 1)th cousin"
    end
end

function grandparentith(removal)
    if removal == 4
        return "2nd"
    elseif removal == 5
        return "3rd"
    else
        return "$(removal - 2)th"
    end
end

"""
    lookup_relationship(AInteger, AInteger)

Given two individuals with a common ancestor where the first parameter is the generational distance
from the first individual to the common ancestor and the second parameter is the generational
distance from the second individual to the common ancestor, this function provides a string
representation of how the two individuals are related.

"""
function lookup_relationship(da::Integer, db::Integer)
    if da > db
        removal = da - db
    else
        removal = db - da
    end
    if da == 0 && db == 0
        return "self"
    elseif da == 0 || db == 0
        # direct ancestor
        if removal == 1
            return "parent"
        elseif removal == 2
            return "grandparent"
        elseif removal == 3
            return "great grandparent"
        else
            return "$(grandparentith(removal)) great grandparent"
        end
    else
        generational = min(da, db)
        if generational == 1
            if removal == 0
                return "sibling"
            elseif removal == 1
                return "aunt/uncle"
            elseif removal == 2
                return "great aunt/uncle"
            else
                return "$(grandparentith(removal + 1)) great aunt/uncle"
            end
        elseif removal == 0
            return cousinth(generational)
        else
            return "$(cousinth(generational)) $removal removed"
        end
    end
end

function lookup_relationship(r::Relationship)
    a = r.a_to_ancestor
    b = r.b_to_ancestor
    if a == red_one(a)
        a = one(a)
    end
    if b == red_one(b)
        b = one(b)
    end
    if a == 0 || b == 0
        return "No Relationship"
    end
    return lookup_relationship(MSB(a), MSB(b))
end

function calculate_relationship(a::Vector{T}, b::Vector{T}) where T <: AInteger
    common_ancestor = 0
    closest_relationship = (T(0), T(0))
    individual_a = 0
    individual_b = 0
    for (index, value) in enumerate(zip(a, b))
        if value[1] == 1 || value[1] == red_one(value[1])
            individual_a = index
        end
        if value[2] == 1 || value[2] == red_one(value[1])
            individual_b = index
        end
        if value[1] != 0 && value[2] != 0
            if value[1] + value[2] < closest_relationship[1] + closest_relationship[2]
                common_ancestor = index
                closest_relationship = value
            end
        end
    end
    return Relationship(common_ancestor, individual_a, individual_b, closest_relationship[1], closest_relationship[2])
end