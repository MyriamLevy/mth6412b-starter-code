
"""Crée un objet Graph à partir d'un fichier .tsp"""
function make_graph(filename::String)
    header = read_header(filename)
    nodes_brut = read_nodes(header, filename)
    edges_brut, weights = read_edges(header, filename)
    T = typeof(nodes_brut[1]) #Récupère le type T des nodes et des edges pour la bonne déclaration des vecteurs nodes et edges
    nodes=Vector{Node{T}}(undef, length(nodes_brut))
    edges=Vector{Edge{T}}(undef, length(edges_brut))
    j = 1
    #Lit les nodes dans le dictionnaire et les stocke dans la liste nodes
    for k in keys(nodes_brut)
        node = Node(string(k), nodes_brut[k])
        nodes[j] = node
        j = j + 1
    end

    #Lit les edges et les stocke dans la liste edges
    for i = 1 : length(edges_brut)
        n1 = nodes[findfirst(x -> name(x) == string(edges_brut[i][1]), nodes)]
        n2 = nodes[findfirst(x -> name(x) == string(edges_brut[i][2]), nodes)]
        edge = Edge((n1, n2), weights[i])
        edges[i] = edge
    end

    #Crée le graphe à partir de ces deux listes
    graph = Graph(filename, nodes, edges)
    return graph
end