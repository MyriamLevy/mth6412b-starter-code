"""Fonction qui fait de la racine d'une composante connexe le parent direct de chaque nœud"""
function path_compr!(comp::Comp{T}) where T
    root = comp.root
    l = length(comp.children)
    for i = 1 : l 
        child = comp.children[i][1]
        if child != root
            comp.children[i] = (child, root)
        end
    end
    comp.rank = 1
    return comp
end
        