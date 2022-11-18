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

function is_tour(graph::Graph{T}, tree::Vector{Edge{T}}) where T
    for i = 1 : length(graph.nodes)
        if length(findall(x -> graph.nodes[i] in x, tree)) > 2
            return false
        end
    end
    return true 
end

function change_weight(graph::Graph{T}, p::Vector{Float64}) where T
    nodes = graph.nodes
    edges = graph.edges
    for i = 1 : length(edges)
        n1, n2 = edges[i].nodes
        i1 = findfirst(n1, nodes)
        i2 = findfirst(n2, nodes)
        edges[i].weight = edges[i].weight + p[i1] + p[i2]
    end
    return Graph(graph.name, nodes, edges)
end

function subgrad_opt(graph::Graph{T}) where T
    k = 0
    nb_nodes = length(graph.nodes)
    step = 1
    p = zeros(nb_nodes)
    tree = one_tree(graph)
    w = sum(x -> weight(x), tree)
    d = [length(findall(x -> graph.nodes[i] in x, tree)) for i = 1 : nb_nodes]
    deg_tour = ones(nb_nodes)*2
    v = d - deg_tour
    while v != zeros(nb_nodes) && k < 100
        k = k + 1
        step = step/k
        p = p + step * v
        tree = one_tree(change_weight(graph, p))
        w = max(w, sum(x -> weight(x), tree) - 2*sum(p))
        d = [length(findall(x -> graph.nodes[i] in x, tree)) for i = 1 : nb_nodes]
        v = d - deg_tour
    end
end


#function alpha_nearness(graph::Graph{T}, edge::Edge{T}, tree::Vector{Edge{T}}) where T
    #root = nodes[1]
    #if edge in tree
        #return 0
    #elseif root in edge.nodes
       # return edge.weight - tree[length(tree)].weight
    #else