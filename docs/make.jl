using RedBlackGraph
using Documenter

DocMeta.setdocmeta!(RedBlackGraph, :DocTestSetup, :(using RedBlackGraph); recursive=true)

makedocs(;
    modules=[RedBlackGraph],
    authors="Dan Rapp",
    repo="https://github.com/rappdw/RedBlackGraph.jl/blob/{commit}{path}#{line}",
    sitename="RedBlackGraph.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://rappdw.github.io/RedBlackGraph.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/rappdw/RedBlackGraph.jl",
    devbranch="main",
)
