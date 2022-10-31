### A Pluto.jl notebook ###
# v0.19.11

using Markdown
using InteractiveUtils

# ╔═╡ 7a4250c3-946d-4fdd-b762-e03aaee36a6d
include("main_phase2.jl")

# ╔═╡ 0adf514a-4e1a-11ed-3a00-856fd5050585
md"""## Projet du voyageur de commerce : Phase 2"""

# ╔═╡ 99956331-b417-48ae-833b-cb98784b4f27
md"""Abdou Samad Dicko(2037205), Clélia Merel(2163025), Myriam Lévy(2225114)"""

# ╔═╡ 96a61622-9d2e-4065-964a-251e342ce7ec
md"""### Création de la strcture *Comp*

Cette partie correspond au fichier *comp.jl*.

La structure *Comp* permet de représenter les composantes connexes d'un graphe. Elle contient deux attributs : une racine de type *Node* et une liste d'enfants sous forme de tuples de type (*Node*, *Node*) où le premier élément est un nœud de la composante connexe et le deuxième est son parent dans la composante connexe. La racine est dans cette liste et elle est son propre parent. Pour l'instant, on ne se sert pas de cette association parent-enfant dans nos fonctions mais elle permet par exemple de remonter jusqu'à la racine à partir de n'importe quel nœud enfant. 

```julia
abstract type AbstractComp{T} end

mutable struct Comp{T} <: AbstractComp{T}
    root::Node{T}
    children::Vector{Tuple{Node{T}, Node{T}}} 
end
```

Dans cette strcture on implémente les méthodes *root* et *children* qui renvoient respectivement la racine et la liste des nœuds enfant-parent de la composante connexe : 

```julia
root(comp::AbstractComp) = comp.root

children(comp::AbstractComp) = comp.children
```

On crée la fonction *merge!* qui permet de fusionner deux composantes connexes en modifiant la première et en gardant sa racine comme racine de la nouvelle composante connexe : 

```julia
function merge!(comp1::Comp{T}, comp2::Comp{T}) where T
    r1 = root(comp1)
    r2 = root(comp2)
    l1 = length(comp1.children)
    l2 = length(comp2.children)
    for i = 1 : length(comp2.children) 
        r = comp2.children[i]
        if r[1] != r2 
            push!(comp1.children, r)   
        end
    end
    push!(comp1.children, (r2, r1))
    @test length(comp1.children) == l1 + l2 #Vérifie que la fusion des deux composantes connexe contient bien le bon nombre de noeuds
    return comp1
end
```

Enfin, on crée la fonction *in_comp* qui vérifie si un nœud se trouve ou non dans une composante connexe et renvoie un booléen : 

```julia
function in_comp(comp::Comp{T}, node::Node{T}) where T
    for i = 1 : length(children(comp))
        if children(comp)[i][1] == node
            return true
        end
    end
    return false
end
```

"""

# ╔═╡ 77ddf67c-0c4a-49a0-8ec8-d428ebaef315
md"""### Implémentation de l'algorithme de Kruskal

Cette partie correspond au fichier *kruskal.jl*.

On commence par récupérer le nombre de nœuds et d'arêtes du graphe puis on trie la liste des arêtes par ordre croissant des poids : 

```julia
function kruskal(graph::Graph{T}) where T

    number_of_edges = length(edges(graph))
    number_of_nodes = length(nodes(graph))
    @test number_of_nodes > 0 #Vérifie que le graphe n'est pas vide

    A = sort(edges(graph), by = x -> weight(x))
    @test length(A) == number_of_edges #Vérifie que A contient le bon nombre d'arrêtes
```

On crée ensuite deux listes vides : *tree* qui contiendra les arêtes de l'arbre de recouvrement minimal et *liste_comp* qui contiendra les composantes connexes du graphe. On initie *liste_comp* avec tous les nœuds qui forment chacun une composante connexe : 

```julia
	tree = [] 
    liste_comp = [] 

    for i = 1 : number_of_nodes
        n = nodes(graph)[i]
        push!(liste_comp, Comp(n, [(n, n)]))
    end

    @test length(liste_comp) == number_of_nodes #Vérifie qu'il y a bien initialement autant de composantes connexes que de noeuds
```

On entre ensuite dans la boucle principale de l'algorithme : on parcourt la liste des arêtes triées et à chaque élément, si les deux nœuds de l'arête sont dans deux composantes connexes différentes, on ajoute l'arrête à *tree* et on fusionne les composantes connexes des deux nœuds ; sinon, on ne fait rien. 

```julia
	for i = 1 : number_of_edges

        @test i == length(A) || weight(A[i]) <= weight(A[i+1]) #Vérifie que le poids de l'élément i de A est bien inférieur à celui du suivant si ce n'est pas le dernier
        n1, n2 = nodes(A[i])
        k1 = findfirst(x -> in_comp(x, n1), liste_comp) 
        k2 = findfirst(x -> in_comp(x, n2), liste_comp) 
        if k1 != k2
            push!(tree, A[i])
            c1 = liste_comp[k1]
            c2 = liste_comp[k2]
            liste_comp[k1] = merge!(c1, c2)
            nouv_comp = liste_comp[k1] #Stocke la valeur de list_comp[k1] pour les tests unitaires car la ligne d'après peut décaler les indices
            deleteat!(liste_comp, k2)
            @test in_comp(nouv_comp,n1)
            @test in_comp(nouv_comp,n2) #Ces deux tests vérifient que n1 et n2 font bien parties de cette nouvelle composante connexe
        end
        @test sum(x -> length(x.children),liste_comp) == number_of_nodes #Vérifie que la liste de composantes connexes est bien une partition des noeuds du graphe
    end
```

Enfin, après deux autres tests unitaires, la fonction renvoie *tree* et le poids de l'arbre de recouvrement minimal : 

```julia
	@test length(liste_comp) == 1 #Vérifie qu'on a une seule composante connexe à la fin
    @test length(tree) == number_of_nodes - 1 #Condition nécessaire pour qu'il s'agisse d'un arbre de recouvrement
    return tree, sum(x -> weight(x), tree)
end
```
"""

# ╔═╡ 8e19ba46-a371-4af9-ac28-bb9c74c5c9b7
md"""### Programme principal

Le fichier *main_phase2.jl* implémente les fonctions *test_cours* et *main_2*.
"""

# ╔═╡ 028d80fd-8425-4a32-b30d-7f12faa48188
md"""La première permet de tester notre fonction *kruskal* sur l'exemple des notes de cours. L'arbre qu'on obtient est bien le même que dans les notes de cours et on peut voir que les arêtes ont été ajoutées dans le même ordre que lorsqu'on a fait l'algorithme à la main.
"""

# ╔═╡ 33c466ae-1824-43e1-811f-cf3f2655c72b
test_cours()

# ╔═╡ f4f427b2-b473-4d99-9e7c-100f60b99622
md"""La fonction *main_2* prend en argument le nom d'un fichier .tsp, crée un objet de type *Graph* à partir de celui-ci, et lui applique l'algorithme de Kruskal. On peut la tester sur plusieurs fichiers.
"""

# ╔═╡ 8496a6cd-f600-460f-bf11-8a1d9b9a2d9a
main_2("../../instances/stsp/bayg29.tsp")

# ╔═╡ 10e95760-387f-4231-b1ce-20304c6720cb
main_2("../../instances/stsp/bays29.tsp")

# ╔═╡ 251c2c38-5e27-407e-8a4b-374460a8aa5c
main_2("../../instances/stsp/dantzig42.tsp")

# ╔═╡ df369b46-647f-402c-bd8d-e1e7201004d4
main_2("../../instances/stsp/gr120.tsp")

# ╔═╡ e04d1394-7bd8-4a87-bd0e-14bd5b46d1de
md"""Ces quatre instances passent bien tous les tests, notre implémentation de l'algorithme de Kruskal semble donc fonctionner."""

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
# ╠═0adf514a-4e1a-11ed-3a00-856fd5050585
# ╠═99956331-b417-48ae-833b-cb98784b4f27
# ╠═96a61622-9d2e-4065-964a-251e342ce7ec
# ╟─77ddf67c-0c4a-49a0-8ec8-d428ebaef315
# ╟─8e19ba46-a371-4af9-ac28-bb9c74c5c9b7
# ╠═7a4250c3-946d-4fdd-b762-e03aaee36a6d
# ╟─028d80fd-8425-4a32-b30d-7f12faa48188
# ╠═33c466ae-1824-43e1-811f-cf3f2655c72b
# ╟─f4f427b2-b473-4d99-9e7c-100f60b99622
# ╠═8496a6cd-f600-460f-bf11-8a1d9b9a2d9a
# ╠═10e95760-387f-4231-b1ce-20304c6720cb
# ╠═251c2c38-5e27-407e-8a4b-374460a8aa5c
# ╠═df369b46-647f-402c-bd8d-e1e7201004d4
# ╠═e04d1394-7bd8-4a87-bd0e-14bd5b46d1de
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
