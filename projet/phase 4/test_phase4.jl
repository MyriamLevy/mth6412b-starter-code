using Test
include("RSL.jl")


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
#graph = make_graph("/Users/alayacare/Documents/Documents - Clélia/PolyMtl/MTH6412/mth6412b-starter-code/instances/stsp/gr21.tsp")
#println(RSL(graph,1))