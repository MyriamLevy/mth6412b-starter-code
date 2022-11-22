include("../phase 3/prim.jl")
include("../phase 2/kruskal.jl")

"""Fonction construisant un 1-tree dans une graphe. Le premier nœud du graphe est le nœud spécial."""
function one_tree(graph::Graph{T}) where T
    nodes = graph.nodes
    edges = graph.edges
    root = nodes[1]
    indices = findall(x -> root in x.nodes, edges) 
    #on trouve toutes les arêtes contenant le premier nœud
    root_edges = sort(edges[indices], by = x -> weight(x)) 
    #on récupère ces arêtes et on les ordonne par poids croissant
    tree_nodes = nodes[2 : nb_nodes(graph)] #on ne modifie pas le graphe
    tree_edges = edges[1 : nb_edges(graph)] #on ne modifie pas le graphe 
    deleteat!(tree_edges, indices)
    tree_graph = Graph("tree_graph", tree_nodes, tree_edges)
    tree = prim(tree_graph)[1]
    push!(tree, root_edges[1], root_edges[2])
    return tree
end

"""Le vecteur p contient un nombre associé à chaque nœud du graphe. Le poids de 
chaque arête est modifié en y ajoutant le nombre associé à ses deux extrémités."""
function change_weight(graph::Graph{T}, p::Vector{Float64}) where T
    nodes = graph.nodes[1 : nb_nodes(graph)]
    edges = graph.edges[1 : nb_edges(graph)]
    for i = 1 : length(edges)
        n1, n2 = edges[i].nodes
        i1 = findfirst(x -> x==n1, nodes)
        i2 = findfirst(x -> x==n2, nodes)
        edges[i] = Edge(edges[i].nodes, edges[i].weight + p[i1] + p[i2])
    end
    return Graph("result", nodes, edges)
end

"""Fonction donnant une borne inférieure sur une tournée minimale dans un graphe et 
permettant éventuellement de trouver une telle tournée"""
function subgrad_opt(graph::Graph{T}) where T
    nb_nodes = length(graph.nodes)
    k = 0
    step = 1
    p = zeros(nb_nodes)
    tree = one_tree(graph)
    w = sum(x -> weight(x), tree)
    d = [length(findall(x -> graph.nodes[i] in x.nodes, tree)) for i = 1 : nb_nodes]
    #le vecteur d contient le degré de chaque nœud dans le 1-tree
    deg_tour = ones(nb_nodes)*2
    #deg_tour est ce vers quoi on veut que d converge
    v = d - deg_tour
    while v != zeros(nb_nodes) && k < 100 #si v ne contient que des 0 alors on a une tournée
        k = k + 1
        step = step/k
        p = p + step * v
        tree = one_tree(change_weight(graph, p)) 
        w = max(w, sum(x -> weight(x), tree) - 2*sum(p))
        d = [length(findall(x -> graph.nodes[i] in x.nodes, tree)) for i = 1 : nb_nodes]
        v = d - deg_tour
    end
    if v == zeros(nb_nodes)
        return tree, sum(x -> weight(x), tree) - 2*sum(p)
    else
        return w
    end
end

"""Fonction donnant une borne inférieure sur une tournée minimale dans un graphe et 
permettant éventuellement de trouver une telle tournée. La différence avec subgrad_opt
est le pas utilisé."""
function subgrad_opt_bis(graph::Graph{T}) where T
    nb_nodes = length(graph.nodes)
    k = 1
    step = 2
    period = floor(nb_nodes/2)
    first_period = true
    #le comportement dans la boucle while est différent à la première période
    p = zeros(nb_nodes)
    tree = one_tree(graph)
    w = sum(x -> weight(x), tree)
    d = [length(findall(x -> graph.nodes[i] in x.nodes, tree)) for i = 1 : nb_nodes]
    #le vecteur d contient le degré de chaque nœud dans le 1-tree
    deg_tour = ones(nb_nodes)*2
    #deg_tour est ce vers quoi on veut que d converge
    v = d - deg_tour
    while step != 0 && period != 0 && v != zeros(nb_nodes) #si v ne contient que des 0 alors on a une tournée
        p = p + step * v
        tree = one_tree(change_weight(graph, p)) 
        w_bis = sum(x -> weight(x), tree) - 2*sum(p)
        if w < w_bis
            w = w_bis
            if k == period
                period = 2*period
            end
        end
        if w_bis < w && first_period
            step = 1
        end
        if k == period
            first_period = false
            period = floor(period/2)
            step = step/2
            k = 0
        end
        k = k + 1
        d = [length(findall(x -> graph.nodes[i] in x.nodes, tree)) for i = 1 : nb_nodes]
        v = d - deg_tour
    end
    if v == zeros(nb_nodes)
        return tree, sum(x -> weight(x), tree) - 2*sum(p)
    else
        return w
    end
end

"""Première version de l'algortihme de montée pour un fichier .tsp"""
function hk(filename::String)
    g = make_graph(filename)
    return subgrad_opt(g)
end

"""Seconde version de l'algortihme de montée pour un fichier .tsp"""
function hk_bis(filename::String)
    g = make_graph(filename)
    return subgrad_opt_bis(g)
end

