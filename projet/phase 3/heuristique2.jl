#code Heuristique2
function path_compr!(comp::Comp{T}) where T
    root = comp.root
    l = length(comp.children)
    for i = 1 : l 
        child = comp.children[i][1]
        if child == root
            comp.children[i].rank = 1
        else
        comp.children[i] = Child((child, root), 0)
        end
    end
    return comp
end
        