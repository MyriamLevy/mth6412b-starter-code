include("phase 1/node.jl")
include("phase 1/edge.jl")
include("phase 1/read_stsp.jl")
include("phase 1/make_graph.jl")
include("phase 1/graph.jl")
include("phase 2/kruskal.jl")


function main(filename::String)
    graph = make_graph(filename)
    kruskal(graph)
end
