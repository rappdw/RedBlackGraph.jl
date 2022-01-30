import Graphs: 
    AbstractGraph, edgetype, nv, ne, vertices, edges, is_directed, 
    has_vertex, has_edge, inneighbors, outneighbors, all_neighbors
import Graphs.SimpleGraphs: SimpleEdge

"""
    throw_if_invalid_eltype(T)

Internal function, throw a `DomainError` if `T` is not a concrete type `Integer`.
Can be used in the constructor of RBGraphs, as Julia's typesystem does not enforce 
concrete types, which can lead to problems. 
"""
function throw_if_invalid_eltype(T::Type{<:Integer})
    if !isconcretetype(T)
        throw(DomainError(T, "Eltype for RBGraph must be concrete type."))
    end
end

"""
    AbstractRBGraph{T, E} <: AbstractGraph{T} where E<:AInteger

AbstractRBGraph is an AbstractGraph with vertices of type T and edges that are AInteger
"""
abstract type AbstractRBGraph{V} <: AbstractGraph{V} end

"""
    RBGraph{T}

A type representing a RedBlackGraph. 
"""
mutable struct RBGraph{V, E} <: AbstractRBGraph{V}
     # RBGraphs are sparse (<< upper triangular), so representing the graph as a connectivity matrix is 
     # very inefficient, but it provides for a simple implementation
    graph::Matrix{E}
    ne::Int

    function RBGraph{V, E}(
            graph::Matrix{E},
            ne::Integer
    ) where V where E<:AInteger

        throw_if_invalid_eltype(V)
        return new(graph, ne)
    end
end

function RBGraph(graph::Matrix{E}, ne, ::Type{V} = Int64) where E<:AInteger where V
    return RBGraph{V, E}(graph, ne)
end

ne(g::AbstractRBGraph) = g.ne
nv(g::AbstractRBGraph) = size(g.graph, 1)

vertices(g::AbstractRBGraph) = Base.OneTo(nv(g))

is_directed(::Type{<:RBGraph}) = true

eltype(::RBGraph{V, E}) where V where E<:AInteger = V

edgetype(::RBGraph{T}) where T<:AInteger = SimpleEdge{T}

# ==(g::RBGraph, h::RBGraph) = g.graph == h.graph

function has_edge(g::RBGraph{V,E}, s::Integer, d::Integer) where V where E<:AInteger
    nv = size(g.graph, 1)

    if s < nv && d < nv && s != d
        @inbounds if g.graph[s][d] != 0
            return true
        end
    end
    return false
end

function has_edge(g::RBGraph{V,E}, e::SimpleEdge) where V where E<:AInteger
    s, d = e.src, e.dst
    return has_edge(g, s, d)
end

function add_edge!(g::RBGraph{V,E}, e::SimpleEdge) where V where E<:AInteger
    s, d = e.src, e.dst
    nv = size(g.graph, 1)
    if s < nv && d < nv && s!= d
        @inbounds g.graph[s][d] = g.graph[d][d] == 1 ? 3 : 2
        g.ne += 1
        return true # edge successfully added
    end
    return false
end

function rem_edge!(g::RBGraph{V,E}, e::SimpleEdge) where V where E<:AInteger
    s, d = e.src, e.dst
    if s < nv && d < nv && s!= d
        @inbounds g.graph[s][d] = 0
        g.ne -= 1
        return true # edge successfully removed
    end
    return false
end

function _is_edge(x::AInteger)
    return x > 1 && x != 0
end

function inneighbors(g::RBGraph{V,E}, v::Integer) where V where E<:AInteger
    if v <= size(g.graph, 1)
        return @inbounds findall(_is_edge, g.graph[:, v])
    end
    return []
end

function outneighbors(g::RBGraph{V,E}, v::Integer) where V where E<:AInteger
    if v <= size(g.graph, 1)
        return @inbounds findall(_is_edge, g.graph[v, :])
    end
    return []
end


function all_neighbors(g::RBGraph{V,E}, u::Integer) where V where E<:AInteger
    i, j = 1, 1
    in_nbrs, out_nbrs = inneighbors(g, u), outneighbors(g, u)
    in_len, out_len = length(in_nbrs), length(out_nbrs)
    union_nbrs = Vector{V}(undef, in_len + out_len)
    indx = 1
    @inbounds while i <= in_len && j <= out_len
        if in_nbrs[i] < out_nbrs[j]
            union_nbrs[indx] = in_nbrs[i]
            i += 1
        elseif in_nbrs[i] > out_nbrs[j]
            union_nbrs[indx] = out_nbrs[j]
            j += 1
        else 
            union_nbrs[indx] = out_nbrs[j]
            i += 1
            j += 1
        end
        indx += 1
    end
    @inbounds while i <= in_len
        union_nbrs[indx] = in_nbrs[i]
        i += 1
        indx += 1
    end
    @inbounds while j <= out_len
        union_nbrs[indx] = out_nbrs[j]
        j += 1
        indx += 1
    end
    resize!(union_nbrs, indx-1)
    return union_nbrs
end

"""
    permute(g::RBGraph{T}, p::Vector{U}; upper_triangular=false) where T<:AInteger where U<:Integer

Permutes the vertices of the graph, g, as specified by the permutation vector, p. If the graph is 
represented by an upper triangular matrix, then upper_triangular can be set to `true` to optimize
the computation.

# Examples
```julia
using Graphs
using RedBlackGraph

g = RBGraph(...)
p = topological_sort_by_dfs(g)
g′ = permute(g, p) 
# g′ will be an upper triangular matrix with the "youngest" vertex in the first position, 
# and the "oldest" vertex in the last position
```
"""
function permute(g::RBGraph{V,E}, p::Vector{V}; upper_triangular=false) where V where E<:AInteger
    n = nv(g)
    g′ = zeros(V, n, n)
    for i in 1:n
        start = upper_triangular ? i : 1
        for j in start:n
            g′[i, j] = g.graph[p[i], p[j]]
        end
    end
    return g′
end