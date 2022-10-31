function find_root(comp::Comp{T}) where T
    root = comp.children[1]
    i = 1
    l = length(comp.children)
    while root.nodes[2] != root.nodes[1] && i < l
        i = i+1
        root = comp.children[i]
    end
    return root
end

function union_rank!(comp1::Comp{T}, comp2::Comp{T}) where T
    root1 = find_root(comp1)
    root2 = find_root(comp2)
    rank1 = get_rank(root1)
    rank2 = get_rank(root2)
    if rank1 > rank2 
        merge!(comp1, comp2) #on peut utiliser notre fonction merge! qui ne modifie pas les rangs
        return comp1
    elseif rank2 > rank1
        merge!(comp2, comp1)
        return comp2
    else
        merge!(comp1, comp2)
        root1.rank = rank1 + 1
        return comp1
    end 
end

a = Node("a", 0)
b = Node("b", 0)
c = Node("c", 0)
d = Node("d", 0)
e = Node("e", 0)
f = Node("f", 0)
g = Node("g", 0)
h = Node("h", 0)
i = Node("i", 0)

child_a = Child((a,a), 2)
child_b = Child((b,a), 1)
child_c = Child((c,a), 1)
child_d = Child((d,b), 0)
child_e = Child((e,e), 2)
child_f = Child((f,e), 0)
child_g = Child((g,e), 1)
child_h = Child((h,e), 0)
child_i = Child((i,g), 0)

comp_1 = Comp(a, [child_a, child_b, child_c, child_d])
comp_2 = Comp(e, [child_e, child_f, child_g, child_h, child_i])

