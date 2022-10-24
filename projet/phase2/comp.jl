using Test

"""Type abstrait dont d'autres types de composantes connexes dériveront."""
abstract type AbstractComp{T} end

"""Type représentant les composantes connexes d'un graphe.

root est le noeud-racine de la composante et les autres noeuds de la composante, 
ainsi que le noeud-racine, sont dans children. 
Chaque noeud est couplé à son parent. root est couplé à lui-même."""
mutable struct Comp{T} <: AbstractComp{T}
    root::Node{T}
    children::Vector{Tuple{Node{T}, Node{T}}} #chaque enfant est un tuple de la forme (enfant, parent)
end

"""Renvoie la racine de la composante connexe"""
get_root(comp::AbstractComp) = comp.root

"""Renvoie les noeuds de la composante connexe"""
get_children(comp::AbstractComp) = comp.children

"""Fonction permettant de fusionner deux composantes connexes comp1 et comp2.

Cette fonction modifie comp1 en lui ajoutant les noeuds de comp2.
comp2 se place "sous" comp1 et la racine de comp1 devient la racine de la composante connexe finale."""
function merge!(comp1::Comp{T}, comp2::Comp{T}) where T
    r1 = get_root(comp1)
    r2 = get_root(comp2)
    l1 = length(comp1.children)
    l2 = length(comp2.children)
    for i = 1 : length(comp2.children) 
        r = comp2.children[i]
        if r[1] != r2 #on ajoute tous les noeuds de comp2 à comp1 à l'exception de (r2, r2) car r1 sera la racine
            push!(comp1.children, r)
        end
    end
    push!(comp1.children, (r2, r1))
    return comp1
end

"""Fonction permettant de vérifier si le noeud node est dans la composante connexe comp.

La fonction parcourt la liste des enfants de comp."""
function in_comp(comp::Comp{T}, node::Node{T}) where T
    for i = 1 : length(get_children(comp))
        if get_children(comp)[i][1] == node
            return true
        end
    end
    return false
end
