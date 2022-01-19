import Graphs: 
    AbstractGraph, edgetype, nv, ne, vertices, edges, is_directed, 
    has_vertex, has_edge, inneighbors, outneighbors, all_neighbors
import Graphs.SimpleGraphs: SimpleEdge

"""
    throw_if_invalid_eltype(T)

Internal function, throw a `DomainError` if `T` is not a concrete type `AInteger`.
Can be used in the constructor of RBGraphs, as Julia's typesystem does not enforce 
concrete types, which can lead to problems. 
"""
function throw_if_invalid_eltype(T::Type{<:AInteger})
    if !isconcretetype(T)
        throw(DomainError(T, "Eltype for RBGraph must be concrete type."))
    end
end

abstract type AbstractRBGraph{T<:AInteger} <: AbstractGraph{T}end

"""
    RBGraph{T}

A type representing a RBGraph.
"""
mutable struct RBGraph{T <: AInteger} <: AbstractRBGraph{T}
    graph::Matrix{T}
    ne::Int

    function RBGraph{T}(
            graph::Matrix{T},
            ne::Integer
    ) where T

        throw_if_invalid_eltype(T)
        return new(graph, ne)
    end
end

function RBGraph(graph::Matrix{T}, ne) where T<:AInteger
    return RBGraph{T}(graph, ne)
end

ne(g::AbstractRBGraph) = g.ne
nv(g::AbstractRBGraph) = size(g.graph, 1)

vertices(g::AbstractRBGraph) = Base.OneTo(nv(g))

is_directed(::Type{<:RBGraph}) = true

eltype(x::RBGraph{T}) where T = T

edgetype(::RBGraph{T}) where T<:AInteger = SimpleEdge{T}

# ==(g::RBGraph, h::RBGraph) = g.graph == h.graph

function has_edge(g::RBGraph{T}, s::Integer, d::Integer) where T
    nv = size(g.graph, 1)

    if s < nv && d < nv && s != d
        @inbounds if g.graph[s][d] != 0
            return true
        end
    end
    return false
end

function has_edge(g::RBGraph{T}, e::SimpleEdge) where T<:AInteger
    s, d = e.src, e.dst
    return has_edge(g, s, d)
end

function add_edge!(g::RBGraph{T}, e::SimpleEdge) where T<:AInteger
    s, d = e.src, e.dst
    nv = size(g.graph, 1)
    if s < nv && d < nv && s!= d
        @inbounds g.graph[s][d] = g.graph[d][d] == 1 ? 3 : 2
        g.ne += 1
        return true # edge successfully added
    end
    return false
end

function rem_edge!(g::RBGraph{T}, e::SimpleEdge) where T<:AInteger
    s, d = e.src, e.dst
    if s < nv && d < nv && s!= d
        @inbounds g.graph[s][d] = 0
        g.ne -= 1
        return true # edge successfully removed
    end
    return false
end

# TODO: just copied from SimpleDiGraph

# function add_vertex!(g::SimpleDiGraph{T}) where T
#     (nv(g) + one(T) <= nv(g)) && return false       # test for overflow
#     push!(g.badjlist, Vector{T}())
#     push!(g.fadjlist, Vector{T}())

#     return true
# end

# function rem_vertices!(g::SimpleDiGraph{T},
#                        vs::AbstractVector{<: Integer};
#                        keep_order::Bool=false
#                       ) where {T <: Integer}
#     # check the implementation in simplegraph.jl for more comments

#     n = nv(g)
#     isempty(vs) && return collect(Base.OneTo(n))

#     # Sort and filter the vertices that we want to remove
#     remove = sort(vs)
#     unique!(remove)
#     (1 <= remove[1] && remove[end] <= n) ||
#             throw(ArgumentError("Vertices to be removed must be in the range 1:nv(g)."))

#     # Create a vmap that maps vertices to their new position
#     # vertices that get removed are mapped to 0
#     vmap = Vector{T}(undef, n)
#     if keep_order
#         # traverse the vertex list and shift if a vertex gets removed
#         i = 1
#         @inbounds for u in vertices(g)
#             if i <= length(remove) && u == remove[i]
#                 vmap[u] = 0
#                 i += 1
#             else
#                 vmap[u] = u - (i - 1)
#             end
#         end
#     else
#         # traverse the vertex list and replace vertices that get removed 
#         # with the furthest one to the back that does not get removed
#         i = 1
#         j = length(remove)
#         v = n
#         @inbounds for u in vertices(g)
#             u > v && break
#             if i <= length(remove) && u == remove[i]
#                 while v == remove[j] && v > u
#                    vmap[v] = 0
#                    v -= one(T)
#                    j -= 1
#                 end
#                 # v > remove[j] || u == v
#                 vmap[v] = u
#                 vmap[u] = 0
#                 v -= one(T)
#                 i += 1
#             else
#                 vmap[u] = u
#             end
#         end
#     end

#     fadjlist = g.fadjlist
#     badjlist = g.badjlist

#     # count the number of edges that will be removed
#     num_removed_edges = 0
#     @inbounds for u in remove
#         for v in fadjlist[u]
#             num_removed_edges += 1
#         end
#         for v in badjlist[u]
#             if vmap[v] != 0
#                 num_removed_edges += 1
#             end
#         end
#     end
#     g.ne -= num_removed_edges

#     # move the lists in the adjacency list to their new position
#     # order of traversing is important!
#     @inbounds for u in (keep_order ? (one(T):1:n) : (n:-1:one(T)))
#         if vmap[u] != 0
#             fadjlist[vmap[u]] = fadjlist[u]
#             badjlist[vmap[u]] = badjlist[u]
#         end
#     end
#     resize!(fadjlist, n - length(remove))
#     resize!(badjlist, n - length(remove))

#     # remove vertices from the lists in fadjlist and badjlist
#     @inbounds for list_of_lists in (fadjlist, badjlist)
#         for list in list_of_lists
#             Δ = 0
#             for (i, v) in enumerate(list)
#                 if vmap[v] == 0
#                     Δ += 1
#                 else
#                     list[i - Δ] = vmap[v]
#                 end
#             end
#             resize!(list, length(list) - Δ)
#             if !keep_order
#                 sort!(list)
#             end
#         end
#     end

#     # we create a reverse vmap, that maps vertices in the result graph
#     # to the ones in the original graph. This resembles the output of
#     # induced_subgraph
#     reverse_vmap = Vector{T}(undef, nv(g))
#     @inbounds for (i, u) in enumerate(vmap)
#         if u != 0
#             reverse_vmap[u] = i
#         end
#     end

#     return reverse_vmap
# end

function _is_edge(x::AInteger)
    return x > 1 && x < 0
end

function inneighbors(g::RBGraph{T}, v::Integer) where T<:AInteger
    if v < size(g.graph, 1)
        return @inbounds findall(_is_edge, g.graph[:, v])
    end
    return []
end

function outneighbors(g::RBGraph{T}, v::Integer) where T<:AInteger
    if v < size(g.graph, 1)
        return @inbounds findall(_is_edge, g.graph[v, :])
    end
    return []
end


function all_neighbors(g::RBGraph{T}, u::Integer) where T<:AInteger
    i, j = 1, 1
    in_nbrs, out_nbrs = inneighbors(g, u), outneighbors(g, u)
    in_len, out_len = length(in_nbrs), length(out_nbrs)
    union_nbrs = Vector{T}(undef, in_len + out_len)
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
