using CSV
using FilePaths; 
using FilePathsBase: /
"""
    read_graph(dir::String, name::String, sparse_size_threshold = 10000)

    A utility to parse input csv files into a RedBlackGraph. The first argument is the directory that holds the csv files.
    The second is the basename for the csv files. By convention, there are two csv files <basename>.canonical.edges.csv and 
    <basename>.canonical.vertices.csv. 
    
    <basename>.canonical.edges.csv may have more than two columns, but the first two are significant for these utilities.
    Column 1 is the source vetex number, Column 2 is the destination vertex number.

    <basename>.canonical.vertices.csv may have more than 2 columns, but two are significant for these utilites. It must contain
    a Column labeled "vertex_number" and one labeled "color". Both columns contain integers.

    This utility will return either a Matrix{AInt64} or a SparseMatrixCSC{AInt64, Int64} if the number of vertices in the graph
    is greater than the value of sparse_size_threshold.

    (Note: https://github.com/rappdw/fs-crawler can be used to generate the required csv files.)
"""
function read_graph(dir::String, name::String, sparse_size_threshold = 10000)
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