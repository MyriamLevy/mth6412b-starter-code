#Test Unitaires
include("../phase1/node.jl")
include("../phase1/edge.jl")
include("../phase1/graph.jl")
include("../phase1/read_stsp.jl")
include("../phase1/make_graph.jl")
include("kruskal.jl")
include("comp.jl")
include("main_phase2.jl")

#-------------------------Test Fonction merge--------------------------
# Création des composantes connexes C1 et C2
#Création des noeuds
a = Node("a",1)
b = Node("b",1)
c = Node("c",1)
d = Node("d",1)
e = Node("e",1)
f = Node("f",1)
g = Node("g",1)

C1=Comp(a,[(a,a),(b,a),(c,a),(d,c)])
C2=Comp(e,[(e,e),(f,e),(g,e)])
C3=merge!(C1,C2)

@test length(get_children(C3))==7 # Pour verifier le nombres d'arete que nous sommes devrions avoir

#Test Fonction in_comp
@test in_comp(C3,g)== true

#Test Fonction kruskal avec exemble cours
Kr= test_cours()
@test Kr[2]==37
#sum_Kr= sum(x -> weight(x),Kr)
