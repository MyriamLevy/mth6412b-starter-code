using Test

"""Type abstrait dont d'autres types de composantes connexes dériveront."""
abstract type AbstractComp{T} end


""" C'est une structure de composante connexe qui prend deux arguments:
        root: qui répresente le noeud qui sert de racine à l'arbre
        children: est un vecteur qui contients des tuples avec trois éléments. Les deux premiers sont des noeuds de la forme(a,b) ou b est le noeud parent de a. Le troisième élément est le rang du noeud au sein de la composante connexe.
        """
mutable struct Comp{T}<:AbstractComp{T} 
    root::Node{T}
    children::Vector{Tuple{Node{T},Node{T},Int}}
end

"""Renvoie la racine de la composante connexe"""
get_root(comp::AbstractComp) = comp.root

"""Renvoie les noeuds de la composante connexe"""
get_children(comp::AbstractComp) = comp.children


"""Fonction permettant de fusionner deux composantes connexes comp1 et comp2.

Cette fonction modifie comp1 en lui ajoutant les noeuds de comp2.
comp2 se place "sous" comp1 et la racine de comp1 devient la racine de la composante connexe finale.
Ici, on ne se soucie pas du rang des éléments, aucun rang n'est modifié."""
function merge!(comp1::Comp{T}, comp2::Comp{T}) where T
    r1 = get_root(comp1)
    r2 = get_root(comp2)
    for i = 1 : length(comp2.children) 
        r = comp2.children[i]
        if r[1] != r2 #on ajoute tous les noeuds de comp2 à comp1 à l'exception de (r2, r2) car r1 sera la racine
           r[1][3]=r[1][3]+1
            push!(comp1.children, r)
        end
    end
    push!(comp1.children,(r2, r1,1) )
    return comp1
end

"""Fonction permettant de vérifier si le noeud node est dans la composante connexe comp.

La fonction parcourt la liste des enfants de comp."""
function in_comp(comp::Comp{T}, node::Node{T}) where T
    for i = 1 : length(get_children(comp))
        if get_nodes(get_children(comp)[i])[1] == node
            return true
        end
    end
    return false
end
