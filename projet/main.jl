include("phase1/node.jl")
include("phase1/edge.jl")
include("phase1/read_stsp.jl")
include("phase1/make_graph.jl")
include("phase1/graph.jl")
include("phase2/kruskal.jl")


function main(filename::String)
    graph = make_graph(filename)
    kruskal(graph)
end
