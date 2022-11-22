include("../phase 2/kruskal.jl")
include("../phase 3/prim.jl")
include("RSL.jl")
include("HK.jl")


@testset "RSL" begin
    #Création des noeuds
    n_a = Node("a",1)
    n_b = Node("b",1)
    n_c = Node("c",1)
    n_d = Node("d",1)
    n_e = Node("e",1)
    n_f = Node("f",1)
    N_exemple= [n_a,n_b, n_c,n_d,n_e,n_f]
    #Création des arêtes 
    e_1= Edge((n_a,n_b),4)
    e_2= Edge((n_a,n_c),8)
    e_3= Edge((n_b,n_d),11)
    e_4= Edge((n_c,n_b),8)
    e_5= Edge((n_c,n_d),7)
    e_6= Edge((n_c,n_e),2)
    e_7= Edge((n_d,n_e),9)
    e_8= Edge((n_d,n_f),14)
    e_9= Edge((n_e,n_f),10)
    e_10=Edge((n_f,n_b),2)
    e_11= Edge((n_a,n_f),6)
    e_12= Edge((n_a,n_d),1)
    e_13= Edge((n_e,n_a),7)
    e_14= Edge((n_c,n_f),4)
    e_15= Edge((n_e,n_b),4)
    E_exemple=[e_1,e_2,e_3,e_4,e_5,e_6,e_7,e_8,e_9,e_10,e_11,e_12,e_13,e_14,e_15]


    # Creation du graph
    graph= Graph("Exemple",N_exemple,E_exemple)
    tree,weight = kruskal(graph)
    @test length(tree) == 5
    @test weight == 13
    tour,len = RSL(graph,5, "kruskal")
    @test len >= subgrad_opt(graph)
    
end

println(subgrad_opt(graph))
println(subgrad_opt_bis(graph))
println(RSL(graph,1,"kruskal"))
println(RSL(graph,1,"prim"))
println(RSL(graph,4,"kruskal"))
println(RSL(graph,4,"prim"))

