### A Pluto.jl notebook ###
# v0.19.16

using Markdown
using InteractiveUtils

# ╔═╡ 994c62e6-6856-11ed-1af7-25740f95cd38
md"""## Projet du voyageur de commerce : Phase 4"""

# ╔═╡ 713a3af0-6856-40a0-8e2b-6400a99b75ca
md"""Abdou Samad Dicko(2037205), Clélia Merel(2163025), Myriam Lévy(2225114)"""

# ╔═╡ 48f99302-57a9-46cf-af99-f837c9b1e39d
md"""### Algorithme de Rosenkrantz, Stearns et Lewis
Cette partie correspond au fichier *RSL.jl*.
#### Visite en préordre d'un arbre

#### Implémentation de l'algortihme



"""

# ╔═╡ 230f3695-486d-4124-a993-fe4023c4147e
md"""### Algorithme de montée de Held et Karp
Cette partie correspond au fichier *HK.jl*.

#### Création d'un *minimum 1-tree*
La fonction *one_tree* crée un *minimum 1-tree* dans le graphe donné en argument. On commence par récupérer les arêtes et les nœuds du graphe et toutes les arêtes reliées au premier nœud. On ordonne ces arêtes par poids croissant car cela va nous servir par la suite :
```julia
function one_tree(graph::Graph{T}) where T
    nodes = graph.nodes
    edges = graph.edges
    root = nodes[1]
    indices = findall(x -> root in x.nodes, edges) 
    root_edges = sort(edges[indices], by = x -> weight(x))   
```
Puis on crée un nouveau graphe à partir de l'original dans lequel on a retiré le premier nœud et les arêtes qui y étaient reliées : 

```julia
	tree_nodes = nodes[2 : nb_nodes(graph)] 
    tree_edges = edges[1 : nb_edges(graph)]  
    deleteat!(tree_edges, indices)
    tree_graph = Graph("tree_graph", tree_nodes, tree_edges) 
```
Enfin, on crée un arbre de poids minimal dans ce nouveau graphe à l'aide de l'algorithme de Prim et on y ajoute les deux arêtes les plus légères reliées au premier nœud : 

```julia
 	tree = prim(tree_graph)[1]
    push!(tree, root_edges[1], root_edges[2])
    return tree
end
```

#### Transformation des coûts des arêtes
La fonction *change_weight!* permet de modifier le poids des arêtes d'un graphe pour l'algorithme de montée. Elle prend en argument un graphe et un vecteur contenant un nombre pour chaque nœud du graphe. Le poids de chaque arête du graphe est augmenté des deux nombres associés à ses deux extrémités. Cette fonction modifie le graphe donné en argument : 

```julia
function change_weight!(graph::Graph{T}, p::Vector{Float64}) where T
    nodes = graph.nodes
    edges = graph.edges
    for i = 1 : length(edges)
        n1, n2 = edges[i].nodes
        i1 = findfirst(x -> x==n1, nodes)
        i2 = findfirst(x -> x==n2, nodes)
        edges[i].weight = edges[i].weight + p[i1] + p[i2]
    end
    return graph
end
```

#### Implémentation de l'algorithme
##### Première version
La fonction *subgrad_opt* implémente l'algorithme de montée. On commence par récupérer le nombre de nœuds du graphe et on initialise le nombre d'étapes, le pas et le vecteur de modification des poids : 

```julia
function subgrad_opt(graph::Graph{T}) where T
    nb_nodes = length(graph.nodes)
    k = 0
    step = 1
    p = zeros(nb_nodes)
```
Puis on crée un premier *minimum 1-tree* et on calcule son poids et un vecteur contenant le degré de chaque nœud dans ce *minimum 1-tree*. Notre gradient est la différence entre ce vecteur et un vecteur de même taille ne contenant que des 2, c'est-à-dire le dégré de chaque nœud lorsque le *minimum 1-tree* est un tour. Le poids de ce premier *minimum 1-tree* est l'initialisation de notre borne inférieure sur le coût d'une tournée minimale : 

```julia
	tree = one_tree(graph)
    w = sum(x -> weight(x), tree)
    d = [length(findall(x -> graph.nodes[i] in x.nodes, tree)) for i = 1 : nb_nodes]
    deg_tour = ones(nb_nodes)*2
    v = d - deg_tour
```

Puis on rentre dans la boucle *while*. On fixe le maximum de passages à 100 si l'on n'a pas réussi à trouver un tour, c'est-à-dire si *v* n'est pas le vecteur nul. À chaque passage, on incrémente *k* de 1, on divise le pas par *k* et on met à jour le vecteur de modificationd des poids : 

```julia
	while v != zeros(nb_nodes) && k < 100 
        k = k + 1
        step = step/k
        p = step * v
```
Puis on crée un nouveau *minimum 1-tree* dans le graphe modifié, on actualise notre borne inférieure en fonction de son poids et on calcule le nouveau gradient : 
```julia
		tree = one_tree(change_weight!(graph, p)) 
        w = max(w, sum(x -> weight(x), tree) - 2*sum(p))
        d = [length(findall(x -> graph.nodes[i] in x.nodes, tree)) for i = 1 : 	nb_nodes]
        v = d - deg_tour
    end
```


##### Seconde version
"""

# ╔═╡ f6d7065e-f14b-44fe-bc01-4edad3b3ef6f
md"""### Erreur relative avec une tournée optimale en fonction des algorithmes

|  Fichier tsp | Solution optimale  | Solution HK  | Solution HK bis  |  Solution RSL Kruskal  | Solution RSL Prim  |  Erreur relative HK   |  Erreur relative HK bis  |  Erreur relative RSL Kruskal  | Erreur relative RSL Prim  |
|---|---|---|---|---|---|---|---|---|---|
| bayg29.tsp | 1610  |   |   |   |   |   |   |   |   |
| bays29.tsp  | 2020  |   |   |   |   |   |   |   |   |
| brazil58.tsp  | 25395  |   |   |   |   |   |   |   |   |
| brg180.tsp  | 1950  |   |   |   |   |   |   |   |   |
| dantzig42.tsp  |699 |   |   |   |   |   |   |   |   |
| fri26.tsp  | 937  |   |   |   |   |   |   |   |   |
| gr17.tsp  |2085 |   |   |   |   |   |   |   |   |
| gr21.tsp  | 2707  |   |   |   |   |   |   |   |   |
| gr24.tsp  |1272 |   |   |   |   |   |   |   |   |
| gr48.tsp  |5046 |   |   |   |   |   |   |   |   |
| gr120.tsp  |6942 |   |   |   |   |   |   |   |   |
| hk48.tsp  |11461 |   |   |   |   |   |   |   |   |
| pa561.tsp  |2763 |   |   |   |   |   |   |   |   |
| swiss42.tsp  |1273 |   |   |   |   |   |   |   |   |


"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.0"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╠═994c62e6-6856-11ed-1af7-25740f95cd38
# ╠═713a3af0-6856-40a0-8e2b-6400a99b75ca
# ╠═48f99302-57a9-46cf-af99-f837c9b1e39d
# ╠═230f3695-486d-4124-a993-fe4023c4147e
# ╠═f6d7065e-f14b-44fe-bc01-4edad3b3ef6f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
