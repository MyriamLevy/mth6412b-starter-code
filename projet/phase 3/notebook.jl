### A Pluto.jl notebook ###
# v0.19.11

using Markdown
using InteractiveUtils

# ╔═╡ 3fd47618-5938-11ed-322f-4f2c6fb83f27
md"""## Projet du voyageur de commerce : Phase 2"""

# ╔═╡ ecb53564-1f4f-4415-8743-ea0656e9efa8
md"""Abdou Samad Dicko(2037205), Clélia Merel(2163025), Myriam Lévy(2225114)"""

# ╔═╡ a6dad034-da4f-48c8-8046-c6f9988c034e
md"""### Union via le rang
#### Question sur le rang
##### Montrer que le rang d'un nœud est toujours inférieur à $|S| - 1$
Montrons que cette propriété est vraie pour $|S| = 1$ puis qu'elle est préservée par l'union via le rang.
- Si $|S| = 1$, il n'y a qu'un seul nœud dans l'arbre donc son rang vaut $0$ et $0 \le 1 - 1 = 0$ donc la propriété est vraie.
- Soient $n$ et $m$ deux entiers supérieurs ou égaux à $1$ et $G$ et $G'$ deux arbres tels que $|S| = n$ et $|S'| = m$. On suppose que la propriété est vraie pour les nœuds de $G$ et $G'$. Soit $G''$ l'arbre obtenu en procédant à l'union via le rang de $G$ et $G'$. $|S''| = n + m$ et d'après l'algorithme de l'union via le rang et l'hypothèse de récurrence, le rang d'un nœud de $G''$ et au plus égal à $max(n-1, m-1) + 1 = max(n, m) \le n + m - 1$ car $n, m \ge 1$. Donc la propriété est vraie pour $G''$. 
Ainsi, quel que soit $|S|$, le rang d'un nœud est toujours inférieur à $|S| - 1$.

##### Montrer que le rang d'un nœud est toujours inférieur à $\lfloor log_2(|S|) \rfloor$
Montrons que cette propriété est vraie pour $|S| = 1$ puis qu'elle est préservée par l'union via le rang.
- Si $|S| = 1$, il n'y a qu'un seul nœud dans l'arbre donc son rang vaut $0$ et $0 \le log_2(1) = 0$ donc la propriété est vraie.
- Soient $n$ et $m$ deux entiers supérieurs ou égaux à $1$ et G et G' deux arbres tels que $|S| = n$ et $|S'| = m$. On suppose que la propriété est vraie pour les nœuds de $G$ et $G'$. Soit G'' l'arbre obtenu en procédant à l'union via le rang de $G$ et $G'$. Si $n \ne m$, on a $|S''| = n + m$ et d'après l'algorithme de l'union via le rang et l'hypothèse de récurrence, le rang d'un nœud de $G''$ et au plus égal à $max(\lfloor log_2(n) \rfloor, \lfloor log_2(m) \rfloor) \le \lfloor log_2(n + m) \rfloor$. Si $n = m$, on a $|S''| = 2n$ et d'après l'algorithme de l'union via le rang et l'hypothèse de récurrence, le rang d'un nœud de $G''$ et au plus égal à $\lfloor log_2(n) \rfloor + 1 = \lfloor log_2(n) \rfloor + \lfloor log_2(2) \rfloor \le \lfloor log_2(n) + log_2(2) \rfloor = \lfloor log_2(2n) \rfloor$. Donc la propriété est vraie pour $G''$. 
Ainsi, quel que soit $|S|$, le rang d'un nœud est toujours inférieur à $\lfloor log_2(|S|) \rfloor$.

#### Modification de la structure *Comp*
Cette partie correspond au fichier *comp.jl* du dossier *phase 2*.

On a créé une nouvelle structure pour les éléments d'une composante connexe appelée *Child*. Elle contient deux attributs : *nodes* qui est un tuple (enfant, parent) comme précédemment et *rank* qui est le rang qui va nous servir pour l'union par le rang : 

```julia
abstract type AbstractChild{T} end

mutable struct Child{T} <: AbstractChild{T}
    nodes::Tuple{Node{T}, Node{T}} 
    rank::Int
end
```

Cette structure est accompagnée de deux méthodes : 

```julia
get_rank(child::AbstractChild) = child.rank 

get_nodes(child::AbstractChild) = child.nodes
```

La structure *Comp* est donc maintenant : 
```julia
mutable struct Comp{T} <: AbstractComp{T}
    root::Node{T}
    children::Vector{Child{T}} 
end
```

Les fonctions *merge!* et *kruskal* ont été modifées pour tenir compte de ce nouvel attribut mais elles ne s'en servent pas particulièrement :
- *merge!* réunit deux composantes connexes en préservant les rangs de tous les *Child*, le nouveau *Child* attribuant comme parent de la deuxième racine la première racine a le même rang que la deuxième racine (lignes 53 et 56 de *comp.jl*)
- *kruskal* crée des composantes connexes avec des *Child* de rang 0 et ne modifie jamais le rang (ligne 18 de *kruskal.jl*)

#### Implémentation de l'heuristique
Cette partie correspond au fichier *union_rang.jl*

On crée une fonction *find_root* qui permet de retrouver la racine d'une composante connexe sans utiliser son attribut *root*. De cette façon, on obtient l'élément avec son rang : 

```julia
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
```

Notre fonction *union_rank!* commence par récupérer la racine et son rang pour les deux composantes connexes à réunir : 

```julia
function union_rank!(comp1::Comp{T}, comp2::Comp{T}) where T
    root1 = find_root(comp1)
    root2 = find_root(comp2)
    rank1 = get_rank(root1)
    rank2 = get_rank(root2)
```

Si la première racine est de plus haut rang que la deuxième alors on insère la deuxième composante sous la première sans modifier les rangs grâce à la fonction *merge!* qui fait exactement cela (on rappelle que *merge!* modifie son premier argument en lui ajoutant le deuxième): 
```julia	
	if rank1 > rank2 
        merge!(comp1, comp2) 
        return comp1
```

Si c'est la deuxième racine qui a le plus haut rang, on fait la même chose mais dans l'autre sens : 

```julia
	elseif rank2 > rank1
        merge!(comp2, comp1)
        return comp2
```

Enfin si les deux rang sont égaux, on utilise à nouveau *merge!* puis on incrémente de 1 le rang de la racine de la nouvelle composante connexe : 

```julia
	else
        merge!(comp1, comp2)
        root1.rank = rank1 + 1
        return comp1
    end 
end
```
"""

# ╔═╡ 1aaeebf9-7bc0-44de-b564-3a149ebbdd74
md"""### Compression des chemins
Cette partie correspond au fichier *compr_chemins.jl*.

Notre fonction *path_compr!* commence par récupérer la racine de la composante connexe :

```julia
function path_compr!(comp::Comp{T}) where T
    root = comp.root
```

Puis on parcourt la liste des nœuds de la composante en distinguant deux cas : 
- si le nœud est la racine, c'est-à-dire qu'il est son propre parent, on met son rang à 1 et on ne fait rien d'autre
- sinon, on attribue à ce nœud la racine comme parent et on met son rang à 0 

```julia
	l = length(comp.children)
	for i = 1 : l 
        child = comp.children[i].nodes[1]
        if child == root
            comp.children[i].rank = 1
        else
        comp.children[i] = Child((child, root), 0)
        end
    end
    return comp
end
```

On rappelle que l'association (enfant, parent) pour les nœuds d'une composante connexe d'un graphe ne correspond pas nécessairement à une arête existante dans le graphe d'origine, il s'agit simplement d'un outil de construction.
"""

# ╔═╡ 51485498-d252-4881-9b65-0dda76d3b305
md"""### Algorithme de Prim
Cette partie correspond au fichier *prim.jl*.

On a d'abord récupéré les fichiers *queue.jl* et *priority_item.jl* du Pr. Orban qui implémentent une structure de file de priorité. La fonction *popfirst!* du fichier *queue.jl* a été modifiée à la ligne 43 pour qu'elle renvoie l'item donc la valeur numérique de la priorité est la plus petite car c'est ce qui correspond pour nous à la priorité la plus importante puisqu'elle représente une arête de poids minimal. 

La fonction prim commence par créer la file de priorité qui contiendra les tuples (nœud, parent) et la liste qui contiendra l'arbre. On choisit arbitrairement le premier nœud du graphe pour commencer notre arbre en lui attribuant une priorité égale à $0$. Initialement, tous les nœuds sont leur propre parent et à l'exception du premier, ils ont la valeur numérique de priorité la plus élevée possible : 
```julia
function prim(graph::Graph{T}) where T
    q = PriorityQueue{PriorityItem{Tuple{Node{T}, Node{T}}}}()
    tree = Edge{T}[]
    s = nodes(graph)[1]
    push!(q, PriorityItem(0, (s, s)))
    number_of_nodes = nb_nodes(graph)
    number_of_edges = nb_edges(graph)
    graph_edges = graph.edges
    for i = 2 : number_of_nodes
        push!(q, PriorityItem(typemax(Int64), (nodes(graph)[i], nodes(graph)[i])))
    end
```
Tant que la file n'est pas vide, on sort l'élement de plus haute priorité et on l'ajoute à l'arbre. Puis on parcourt la liste des arêtes et si une arête relie cet élément à un nœud qui n'est pas encore dans l'arbre avec une arête plus légère que celle qui le reliait précédemment à l'arbre, alors le parent de ce nœud devient l'élément qu'on a sorti et sa priorité le poids de cette arête : 
```julia
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
```
Enfin, la fonction renvoie l'arbre et son poids : 
```julia
	return tree, sum(x -> weight(x), tree)
end
```
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
# ╟─3fd47618-5938-11ed-322f-4f2c6fb83f27
# ╟─ecb53564-1f4f-4415-8743-ea0656e9efa8
# ╟─a6dad034-da4f-48c8-8046-c6f9988c034e
# ╠═1aaeebf9-7bc0-44de-b564-3a149ebbdd74
# ╠═51485498-d252-4881-9b65-0dda76d3b305
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
