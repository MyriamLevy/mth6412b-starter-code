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
    p_tot = zeros(nb_nodes)
```
Puis on crée un premier *minimum 1-tree* et on calcule son poids et un vecteur contenant le degré de chaque nœud dans ce *minimum 1-tree*. Notre gradient est la différence entre ce vecteur et un vecteur de même taille ne contenant que des 2, c'est-à-dire le dégré de chaque nœud lorsque le *minimum 1-tree* est un tour. Le poids de ce premier *minimum 1-tree* est l'initialisation de notre borne inférieure sur le coût d'une tournée minimale : 

```julia
	tree = one_tree(graph)
    w = sum(x -> weight(x), tree)
    d = [length(findall(x -> graph.nodes[i] in x.nodes, tree)) for i = 1 : nb_nodes]
    deg_tour = ones(nb_nodes)*2
    v = d - deg_tour
```

Puis on rentre dans la boucle *while*. On fixe le maximum de passages à 100 si l'on n'a pas réussi à trouver un tour, c'est-à-dire si *v* n'est pas le vecteur nul. À chaque passage, on incrémente *k* de 1, on divise le pas par *k* et on met à jour le vecteur de modification des poids : 

```julia
	while v != zeros(nb_nodes) && k < 100 
        k = k + 1
        step = step/k
        p = step * v
		p_tot = p_tot + p
```
Puis on crée un nouveau *minimum 1-tree* dans le graphe modifié (on a seulement besoin d'ajouter le gradient car change_weight! modifie le graphe), on actualise notre borne inférieure en fonction du poids du *minimum 1-tree* et on calcule le nouveau gradient : 
```julia
		tree = one_tree(change_weight!(graph, p)) 
        w = max(w, sum(x -> weight(x), tree) - 2*sum(p_tot))
        d = [length(findall(x -> graph.nodes[i] in x.nodes, tree)) for i = 1 : 	nb_nodes]
        v = d - deg_tour
    end
```
Quand on sort de la boucle, si on a trouvé une tournée, on la renvoie ainsi que son poids. Sinon, on renvoie la borne inférieure : 

```julia
	if v == zeros(nb_nodes)
        return tree, sum(x -> weight(x), tree) - 2*sum(p_tot)
    else
        return w
    end
end
```

##### Seconde version
Dans la seconde version *subgrad\_opt_bis*, on fait évoluer le pas comme indiqué en page 26 du rapport. On commence par récupérer le nombre de nœuds du graphe et on initialise le nombre de passages dans une période, le pas, la période et le vecteur de modification des poids. Le booléen *first_period* est nécessaire car le comportement est différent pendant la première période :

```julia
function subgrad_opt_bis(graph::Graph{T}) where T
    nb_nodes = length(graph.nodes)
    k = 1
    step = 2
    period = floor(nb_nodes/2)
    first_period = true
    p_tot = zeros(nb_nodes)
```
Comme précédemment, on crée un premier *minimum 1-tree* et on calcule la borne inférieure et le gradient : 

```julia
	tree = one_tree(graph)
    w = sum(x -> weight(x), tree)
    d = [length(findall(x -> graph.nodes[i] in x.nodes, tree)) for i = 1 : nb_nodes]
    deg_tour = ones(nb_nodes)*2
    v = d - deg_tour
```
Puis on rentre dans la boucle *while*. Cette fois ci, les conditions d'arrêt sont trouver un tour ou avoir un pas ou une période nuls. On met à jour le vecteur de modification des poids et on crée un nouveau *minimum 1-tree* et on calcule son poids : 

```julia
	while step != 0 && period != 0 && v != zeros(nb_nodes)
		p = step * v
        p_tot = p_tot + p
        tree = one_tree(change_weight!(graph, p)) 
        w_bis = sum(x -> weight(x), tree) - 2*sum(p_tot)
```

En fonction de la valeur de ce nouveau poids par rapport à la borne inférieure et de l'étape à laquelle on se trouve dans la période, on modifie la borne inférieure, la période ou le pas : 

```julia
		if w < w_bis
            w = w_bis
            if k == period
                period = 2*period
            end
        end
        if w_bis < w && first_period
            step = 1
        end
        if k == period
            first_period = false
            period = floor(period/2)
            step = step/2
            k = 0
        end
```

Enfin, on incrémente *k* de 1 et on actualise le gradient : 

```julia
		k = k + 1
        d = [length(findall(x -> graph.nodes[i] in x.nodes, tree)) for i = 1 : nb_nodes]
        v = d - deg_tour
    end
```
La fonction se termine comme la première version : 

```julia
	if v == zeros(nb_nodes)
        return tree, sum(x -> weight(x), tree) - 2*sum(p_tot)
    else
        return w
    end
end
```

Les fonctions *hk* et *hk_bis* permettent d'appliquer respectivement *subgrad_opt* et *subgrad\_opt_bis* à des fichiers .tsp.
"""

# ╔═╡ 265397e5-ae47-49f7-a794-2578404aadc9
md"""### Erreur relative avec une tournée optimale en fonction des algorithmes"""

# ╔═╡ f6d7065e-f14b-44fe-bc01-4edad3b3ef6f
md"""

|  Fichier tsp | Solution optimale  | Solution HK  | Solution HK bis  |  Solution RSL Kruskal  | Solution RSL Prim  |  Erreur relative HK   |  Erreur relative HK bis  |  Erreur relative RSL Kruskal  | Erreur relative RSL Prim  |
|---|---|---|---|---|---|---|---|---|---|
| bayg29.tsp | 1610  |  1413,99  | 1599,50  | 2178  | 2178  | 12,2%  | 0,7%  | 35,3%  | 35,3%  |
| bays29.tsp  | 2020  | 1621,19  | 1938,39  |2621 | 2553  | 19,7%  | 4,0%  | 29,8%  | 26,4%  |
| dantzig42.tsp  |699 | 619,27  | 657,37  |  951  | 940  | 11,4%  | 6,0%  | 36,1%  | 34,5%  |
| fri26.tsp  | 937  | 762,90  | 858,50  |1112   | 1112  | 18,6%  | 8,4%  | 18,7%  | 18,7%  |
| gr17.tsp  |2085 | 1433,03  | 1892,62  | 2352  | 2352  | 31,3%  | 9,2%  | 12,8%  | 12,8%  |
| gr21.tsp  | 2707  | 2173,03  | 2581,67  | 3803  | 3728  | 19,7%  | 30,1%  | 13,1%  | 13,1%  |
| gr24.tsp  |1272 | 1036,27  | 1192,15  | 1607  | 1607  | 18,5%  | 6,3%  | 26,3%  | 26,3%  |
| gr48.tsp  |5046 | 4120,58  | 4819,08  | 6897  | 6897  | 18,3%  | 4,5%  | 36,7%  | 36,7%  |
| swiss42.tsp  |1273 | 1104,27  | 1244,74  | 1641  | 1641  | 13,3%  | 2,2%  | 28,9  |28,9%|



"""

# ╔═╡ 088f7f19-fa89-4fb1-8812-cd38d43dc94f
md"""Comme attendu, l'algorithme de RSL trouve une solution dont le poids est inférieur au double de celui de la tournée optimale. 
La seconde version de l'algorithme de montée est plus efficace que la première et, à une exception près, elle donne une bonne borne inférieure."""

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
# ╟─994c62e6-6856-11ed-1af7-25740f95cd38
# ╟─713a3af0-6856-40a0-8e2b-6400a99b75ca
# ╟─48f99302-57a9-46cf-af99-f837c9b1e39d
# ╟─230f3695-486d-4124-a993-fe4023c4147e
# ╟─265397e5-ae47-49f7-a794-2578404aadc9
# ╟─f6d7065e-f14b-44fe-bc01-4edad3b3ef6f
# ╟─088f7f19-fa89-4fb1-8812-cd38d43dc94f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
