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
    tree = prim(tree_graph)[1]
    push!(tree, root_edges[1], root_edges[2])
    return tree
end

function change_weight!(graph::Graph{T}, p::Vector{Float64}) where T
    nodes = graph.nodes
    edges = graph.edges
    for i = 1 : length(edges)
        n1, n2 = edges[i].nodes
        i1 = findfirst(x -> x==n1, nodes)
        i2 = findfirst(x -> x==n2, nodes)
        edges[i].weight = edges[i].weight + p[i1] + p[i2]
    end
    return graph
end

function subgrad_opt(graph::Graph{T}) where T
    k = 0
    nb_nodes = length(graph.nodes)
    step = 1
    p = zeros(nb_nodes)
    tree = one_tree(graph)
    w = sum(x -> weight(x), tree)
    d = [length(findall(x -> graph.nodes[i] in x.nodes, tree)) for i = 1 : nb_nodes]
    deg_tour = ones(nb_nodes)*2
    v = d - deg_tour
    while v != zeros(nb_nodes) && k < 1000
        k = k + 1
        step = step/k
        p = step * v
        tree = one_tree(change_weight!(graph, p))
        w = max(w, sum(x -> weight(x), tree) - 2*sum(p))
        d = [length(findall(x -> graph.nodes[i] in x.nodes, tree)) for i = 1 : nb_nodes]
        v = d - deg_tour
    end
    if v == zeros(nb_nodes)
        return tree, sum(x -> weight(x), tree)
    else
        return w
    end
end

function hk(filename::String)
    g = make_graph(filename)
    return subgrad_opt(g)
end

