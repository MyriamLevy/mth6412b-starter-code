include("comp.jl")

"""Fonction renvoyant un arbre de recouvrement minimal pour le graphe graph à l'aide de
l'algortihme de Kruskal."""
function kruskal(graph::Graph{T}) where T

    number_of_edges = length(edges(graph))
    number_of_nodes = length(nodes(graph))
    @test number_of_nodes > 0 #Vérifie que le graphe n'est pas vide

    A = sort(edges(graph), by = x -> weight(x)) #liste des arêtes triées par poids
    @test length(A) == number_of_edges #Vérifie que A contient le bon nombre d'arrêtes

    tree = [] #contiendra la liste des arêtes de l'arbre de recouvrement minimal
    liste_comp = [] #contiendra les composantes connexes du graphe

    #on initie liste_comp avec chaque noeud qui est une composante connexe
    for i = 1 : number_of_nodes
        n = nodes(graph)[i]
        push!(liste_comp, Comp(n, [(n, n)]))
    end

    @test length(liste_comp) == number_of_nodes #Vérifie qu'il y a bien initialement autant de composantes connexes que de noeuds

    for i = 1 : number_of_edges

        @test i == length(A) || weight(A[i]) <= weight(A[i+1]) #Vérifie que le poids de l'élément i de A est bien inférieur à celui du suivant si ce n'est pas le dernier
        n1, n2 = nodes(A[i])
        k1 = findfirst(x -> in_comp(x, n1), liste_comp) #indice de la composante connexe contenant n1
        k2 = findfirst(x -> in_comp(x, n2), liste_comp) #indice de la composante connexe contenant n2
        if k1 != k2 #si n1 et n2 ne sont pas dans la même composante connexe
            push!(tree, A[i])
            c1 = liste_comp[k1]
            c2 = liste_comp[k2]
            liste_comp[k1] = merge!(c1, c2)
            nouv_comp = liste_comp[k1] #Stocke la valeur de list_comp[k1] pour les tests unitaires car la ligne d'après peut décaler les indices
            deleteat!(liste_comp, k2)
            @test in_comp(nouv_comp,n1)
            @test in_comp(nouv_comp,n2) #Ces deux tests vérifient que n1 et n2 font bien parties de cette nouvelle composante connexe
        end
        @test sum(x -> length(x.children),liste_comp) == number_of_nodes #Vérifie que la liste de composantes connexes est bien une partition des noeuds du graphe
    end
    @test length(liste_comp) == 1 #Vérifie qu'on a une seule composante connexe à la fin
    @test length(tree) == number_of_nodes - 1 #Condition nécessaire pour qu'il s'agisse d'un arbre de recouvrement
    return tree, sum(x -> weight(x), tree)
end