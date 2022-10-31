#prim
include("../phase1/node.jl")
include("../phase1/edge.jl")
include("../phase1/graph.jl")
include("../phase1/read_stsp.jl")
include("../phase1/make_graph.jl")

function prim(graph::Graph{T}) where T
    q = PriorityQueue{PriorityItem{Tuple{Node{T}, Node{T}}}}()
    tree = Edge{T}[]
    #les items de priorité sont de la forme (nœud, parent)
    s = nodes(graph)[1]
    push!(q, PriorityItem(0, (s, s)))
    number_of_nodes = nb_nodes(graph)
    number_of_edges = nb_edges(graph)
    graph_edges = graph.edges
    for i = 2 : number_of_nodes
        push!(q, PriorityItem(typemax(Int64), (nodes(graph)[i], nodes(graph)[i])))
    end
    while !is_empty(q)
        s = popfirst!(q)
        push!(tree, Edge(s.data, s.priority))
        for i = 1 : number_of_edges
            e = graph_edges[i]
            if e.nodes[1] == s.data[1]
                t = e.nodes[2]
                w = e.weight
                j = findfirst(x -> x.data[1] == t, q.items)
                if j != nothing && priority(q.items[j]) > w
                    q.items[j] = PriorityItem(w, (t, s.data[1]))
                end
            elseif e.nodes[2] == s.data[1]
                t = e.nodes[1]
                w = e.weight
                j = findfirst(x -> x.data[1] == t, q.items)
                if j != nothing && priority(q.items[j]) > w
                    q.items[j] = PriorityItem(w, (t, s.data[1]))
                end
            end
        end
    end
    return tree, sum(x -> weight(x), tree)
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

