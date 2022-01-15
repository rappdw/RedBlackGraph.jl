using CSV
using FilePaths; 
using FilePathsBase: /
"""
    A collection of utiliites to parse input csv files into a RedBlackGraph.

    By convention, there are two csv files <basename>.edges.csv and <basename>.vertices.csv. 
    
    <basename>.edges.csv may have more than two columns, but the first two are significant for these utilities.
    Column 1 is the source vetex id, column 2 is the destination vertex id.

    <basename>.vertices.csv may have more than 3 columns, but the first three are significant for these utilites.
    Column 1 is the vertex id, column 2 is the "gender" (either 1 or red_one(1)), and column three is a "user friendly" name for the vertex.
"""

function read_graph(dir::String, name::String)
    dir = Path(dir)
    vertex_rows = CSV.Rows(dir / "$name.canonical.vertices.csv"; select=["vertex_number"], reusebuffer=true, types=Dict("vertex_number"=>Int64))

    lastarg(_,x) = x
    n = foldl(lastarg, vertex_rows)[1] # got this from the discussion https://discourse.julialang.org/t/getting-the-last-element-of-an-iterator/49696/44
    use_spare = n > 10000
    graph = nothing
    r = red_one(AInt64)
    if use_spare
        # figure this one out later...
    else
        graph = zeros(AInt64, n, n)
    end
    vertex_rows = CSV.Rows(dir / "$name.canonical.vertices.csv"; select=["vertex_number" ,"color"], reusebuffer=true, types=Dict("vertex_number"=>Int64, "color"=>Int64))
    for vertex in vertex_rows
        # get the vertex number (first column) and color (second column)
        i = vertex[1]
        val = r                 # TODO: support AInt64(-1) and then just use that for value, e.g. graph[i, i] = AInt64(vertex[2])
        if vertex[2] == 1
            val = 1
        end
        graph[i, i] = val
    end
    edge_rows = CSV.Rows(dir / "$name.canonical.edges.csv"; types=Dict("Column1"=>Int64, "Column2"=>Int64), header=0)
    for edge in edge_rows
        # get the source (first column) and destination (second column)
        i = edge[1]
        j = edge[2]
        # set the relationship to 2 (father), 3 (mother) based on color of vertex
        val = 2
        if graph[j, j] == 1
            val = 3
        end
        graph[i, j] = val
    end
    return graph
end