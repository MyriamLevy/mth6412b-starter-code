include("phase 3/union_rang.jl")
include("phase 3/compr_chemins.jl")
include("phase 4/RSL.jl")


function main(filename::String)
    graph = make_graph(filename)
    weights = []
    for i = 1 : length(nodes(graph))
        # j = rand(1:length(nodes(graph)))
        # println(j)
        tree,weight = RSL(graph,i,"kruskal")
        push!(weights,weight)
    end
    bestindex = argmin(weights)
    println(bestindex, RSL(graph,bestindex,"kruskal"))
end
