#main
include("RSL.jl")
include("HK.jl")

function main(address::String)
    hk_result=hk(address)
    hk_bis_result=hk_bis(address)
    graph=make_graph(address)
    rsl_result_kruskal=RSL(graph,1,"kruskal")[2]
    rsl_result_prim=RSL(graph,1,"prim")[2]

    println("La solution optimale pour la méthode de HK est : $hk_result \n")
    println("La solution optimale pour la méthode de HK_bis est : $hk_bis_result \n")
    println("La solution optimale pour la méthode de RSL avec kruskal est : $rsl_result_kruskal\n")
    println("La solution optimale pour la méthode de RSL avec prim est : $rsl_result_prim \n")

end