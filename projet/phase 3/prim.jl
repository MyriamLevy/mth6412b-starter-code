#prim
include("../phase 1/node.jl")
include("../phase 1/edge.jl")
include("../phase 1/graph.jl")
include("../phase 1/read_stsp.jl")
include("../phase 1/make_graph.jl")
include("../phase 2/comp.jl")
include("priority_item.jl")
include("queue.jl")

"""Fonction renvoyant un arbre de recouvrement minimal pour le graphe graph à l'aide de
l'algortihme de Prim."""
function prim(graph::Graph{T}) where T
    q = PriorityQueue{PriorityItem{Tuple{Node{T}, Node{T}}}}()
    #les items de priorité sont de la forme (nœud, parent)
    tree = Edge{T}[]
    s = nodes(graph)[1]
    push!(q, PriorityItem(0, (s, s)))
    number_of_nodes = nb_nodes(graph)
    number_of_edges = nb_edges(graph)
    graph_edges = graph.edges
    for i = 2 : number_of_nodes
        push!(q, PriorityItem(typemax(Int64), (nodes(graph)[i], nodes(graph)[i])))
    end
    while !is_empty(q)
        s = popfirst!(q)
        push!(tree, Edge(s.data, s.priority))
        for i = 1 : number_of_edges
            e = graph_edges[i]
            if e.nodes[1] == s.data[1]
                t = e.nodes[2]
                w = e.weight
                j = findfirst(x -> x.data[1] == t, q.items)
                if j != nothing && priority(q.items[j]) > w 
                #il faut vérifier que le nœud relié à s est encore dans la file
                    q.items[j] = PriorityItem(w, (t, s.data[1]))
                end
            elseif e.nodes[2] == s.data[1]
                t = e.nodes[1]
                w = e.weight
                j = findfirst(x -> x.data[1] == t, q.items)
                if j != nothing && priority(q.items[j]) > w
                    q.items[j] = PriorityItem(w, (t, s.data[1]))
                end
            end
        end
    end
    return tree, sum(x -> weight(x), tree)
end
