include("phase 3/union_rang.jl")
include("phase 3/compr_chemins.jl")
include("phase 4/RSL.jl")


function main(filename::String)
    graph = make_graph(filename)
    kruskal(graph)
end
