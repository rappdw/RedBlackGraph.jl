@doc """
    floyd_warshall_transitive_closure(g)

Use the [Floyd-Warshall algorithm](http://en.wikipedia.org/wiki/Floyd–Warshall_algorithm)
to compute the transistive closure of a redblackgraph `g`. Return a Matrix{AInteger} that
represents the transitive closure of the redblackgraph adjacency matrix.
"""
function floyd_warshall_transitive_closure(m::Matrix{A}) where A <: AInteger
	n = size(m)[1]
	w = copy(m)
	for k in 1:n
		for i in 1:n
			for j in 1:n
				w[i, j] = w[i, j] + w[i, k] * w[k, j]
			end
		end
	end
	return w
end