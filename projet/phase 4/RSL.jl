include("../phase 3/prim.jl")
include("../phase 2/kruskal.jl")

"""Fonction récursive effectuant la visite d'un arbre en ordre préfixe en partant d'un sommet racine"""
function prefix_visit(tree::Vector{Edge{T}},s::Node{T}) where T
    subtree = Edge{T}[]
    children = Node{T}[]
    visit_order = Node{T}[]
    for x in tree
        if x.nodes[1] == s 
            push!(children, x.nodes[2])
        elseif x.nodes[2] == s 
            push!(children, x.nodes[1])
        else
            push!(subtree,x) 
        end       
    end
    push!(visit_order,s)
    for child in children
        visit_order = vcat(visit_order,prefix_visit(subtree,child))
    end
    return visit_order  
end

"""implémentation de l'algorithme de Rosenkrantz, Stearns et Lewis"""
function RSL(graph::Graph{T}, root_index::Int64, tree_algo::String) where T
    if tree_algo == "kruskal"
        tree = kruskal(graph)[1]
    end
    if tree_algo == "prim"
        tree = prim(graph)[1]
    end
    root = nodes(graph)[root_index]
    tour = prefix_visit(tree,root)
    push!(tour,tour[1])
    weight = 0
    for i = 1 : length(tour)-1
        index = findfirst(x -> nodes(x)==(tour[i],tour[i+1]) || nodes(x)==(tour[i+1],tour[i]),edges(graph))
        edge = edges(graph)[index]
        weight += edge.weight
    end
    return tour,weight
end
# Creation du graph
graph = make_graph("/Users/alayacare/Documents/Documents - Clélia/PolyMtl/MTH6412/mth6412b-starter-code/instances/stsp/gr120.tsp")
RSL(graph,1,"prim")