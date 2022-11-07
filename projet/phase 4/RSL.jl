include("../phase 3/prim.jl")






"""Fonction récursive effectuant la visite d'un arbre en ordre préfixe en partant d'un sommet racine"""
function prefix_visit(tree::Vector{Edge{T}},s::Node{T}) where T
    subtree = Edge{T}[]
    children = Node{T}[]
    visit_order = Node{T}[]
    for x in tree
        if x.nodes[1] == s && x.nodes[2] != s
            push!(children, x.nodes[2])
        end
        if x.nodes[2] == s && x.nodes[1] != s
            push!(children, x.nodes[1])
        end
        if x.nodes[2] != s && x.nodes[1] != s
            push!(subtree,x) 
        end       
    end
    for child in children
        visit_order = vcat(visit_order,prefix_visit(subtree,child))
    end
    return visit_order  
end



"""implémentation de l'algorithme de Rosenkrantz, Stearns et Lewis"""
function RSL(graph::Graph{T}) where T
    tree, weight = prim(graph)
    root = nodes(graph)[1]
    tour = prefix_visit(tree,root)
end


#Création des noeuds
n_a = Node("a",1)
n_b = Node("b",1)
n_c = Node("c",1)
n_d = Node("d",1)
n_e = Node("e",1)
n_f = Node("f",1)
n_g = Node("g",1)
n_h = Node("h",1)
n_i = Node("i",1)
N_exemple= [n_a,n_b, n_c,n_d,n_e,n_f,n_g,n_h,n_i]
# Création des arêtes 
e_1= Edge((n_a,n_b),4)
e_2= Edge((n_a,n_h),8)
e_3= Edge((n_b,n_h),11)
e_4= Edge((n_c,n_b),8)
e_5= Edge((n_c,n_d),7)
e_6= Edge((n_c,n_i),2)
e_7= Edge((n_d,n_e),9)
e_8= Edge((n_d,n_f),14)
e_9= Edge((n_e,n_f),10)
e_10=Edge((n_f,n_g),2)
e_11= Edge((n_g,n_i),6)
e_12= Edge((n_g,n_h),1)
e_13= Edge((n_h,n_i),7)
e_14= Edge((n_c,n_f),4)
E_exemple=[e_1,e_2,e_3,e_4,e_5,e_6,e_7,e_8,e_9,e_10,e_11,e_12,e_13,e_14]

# Creation du graph
graph= Graph("Exemple",N_exemple,E_exemple)

tree, poids = prim(graph)
prefix_visit(tree,n_a)