function one_tree(graph::Graph{T}) where T
    nodes = graph.nodes
    edges = graph.edges
    root = nodes[1]
    indices = findall(x -> root in x.nodes, edges)
    root_edges = sort(edges[indices], by = x -> weight(x))
    tree_nodes = nodes[2 : nb_nodes(graph)]
    tree_edges = edges[1 : nb_edges(graph)]
    deleteat!(tree_edges, indices)
    tree_graph = Graph("tree_graph", tree_nodes, tree_edges)
    tree = kruskal(tree_graph)
    push!(tree, root_edges[1], root_edges[2])
    return tree
end

function alpha_nearness(graph::Graph{T}, edge::Edge{T}, tree::Vector{Edge{T}}) where T
    root = nodes[1]
    if edge in tree
        return 0
    elseif root in edge.nodes
        return edge.weight - tree[length(tree)].weight
    else