module RedBlackGraph

include("avus.jl")
include("shortestpaths/floyd-warshall.jl")
include("relationship.jl")

export
# Avus number system
red_one, AInteger, AInt8, AInt16, AInt32, AInt64, AInt128, MSB,

# Shortest Path / Transitive Closure
floyd_warshall_transitive_closure, floyd_warshall_transitive_closure!,

# Relationship calculation
lookup_relationship, calculate_relationship, Relationship

end
