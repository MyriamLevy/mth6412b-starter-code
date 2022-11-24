"""Fonction permettant de trouver la racine d'une composante connexe en parcourant 
la liste des nœuds qui la composent."""
function find_root(comp::Comp{T}) where T
    root = comp.children[1]
    i = 1
    l = length(comp.children)
    while root[2] != root[1] && i < l
        i = i+1
        root = comp.children[i]
    end
    return root
end

"""Fonction implémentant l'union via le rang des composantes connexes comp1 et comp2.
La fonction modifie l'une des deux composantes en lui ajoutant la deuxième et renvoie
la composante modifiée."""
function union_rank!(comp1::Comp{T}, comp2::Comp{T}) where T
    rank1 = get_rank(comp1)
    rank2 = get_rank(comp2)
    if rank1 > rank2 
        merge!(comp1, comp2) #on peut utiliser notre fonction merge! qui ne modifie pas les rangs
        return comp1
    elseif rank2 > rank1
        merge!(comp2, comp1)
        return comp2
    else
        merge!(comp1, comp2)
        comp1.rank = rank1 + 1
        return comp1
    end 
end

