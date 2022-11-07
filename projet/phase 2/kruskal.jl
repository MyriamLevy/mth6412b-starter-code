include("comp.jl")

"""Fonction renvoyant un arbre de recouvrement minimal pour le graphe graph à l'aide de
l'algortihme de Kruskal."""
function kruskal(graph::Graph{T}) where T

    number_of_nodes = length(nodes(graph))

    A = sort(edges(graph), by = x -> weight(x)) #liste des arêtes triées par poids

    tree = Edge{T}[] #contiendra la liste des arêtes de l'arbre de recouvrement minimal
    liste_comp = Comp{T}[] #contiendra les composantes connexes du graphe

    #on initie liste_comp avec chaque noeud qui est une composante connexe
    #on ne se soucie pas du rang des nœuds, il reste à 0 pour tout le monde
    for i = 1 : number_of_nodes
        n = nodes(graph)[i]
        push!(liste_comp, Comp(0, n, [(n, n)]))
    end

    i = 1
    while length(liste_comp) > 1
        n1, n2 = nodes(A[i])
        k1 = findfirst(x -> in_comp(x, n1), liste_comp) #indice de la composante connexe contenant n1
        k2 = findfirst(x -> in_comp(x, n2), liste_comp) #indice de la composante connexe contenant n2
        if k1 != k2 #si n1 et n2 ne sont pas dans la même composante connexe
            push!(tree, A[i])
            c1 = liste_comp[k1]
            c2 = liste_comp[k2]
            liste_comp[k1] = merge!(c1, c2)
            deleteat!(liste_comp, k2)
        end
        i = i + 1
    end
    return tree, sum(x -> weight(x), tree)
end