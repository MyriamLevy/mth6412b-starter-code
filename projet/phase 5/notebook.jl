### A Pluto.jl notebook ###
# v0.19.16

using Markdown
using InteractiveUtils

# ╔═╡ ec313840-ba42-4713-a4a3-bd6d83cfa766
md"""## Projet du voyageur de commerce : Phase 5"""

# ╔═╡ 706f9a6f-c122-491b-8a8c-e73808f36405
md"""Abdou Samad Dicko(2037205), Clélia Merel(2163025), Myriam Lévy(2225114)"""

# ╔═╡ 7faec73f-20ca-4641-ab63-b57ea3792bbc
md"""### Implémentation 
Cette partie correspond au fichier *tsp_image.jl*. 

Notre implémentation de la montée de Held et Karp renvoie une tournée sous forme de liste d'arêtes, il faut donc commencer par transformer cette tournée en une liste de nœuds, ce que fait la fonction *transform_tour*. Pour ne pas modifier la tournée originale, on commence par la copier puis on initie notre liste de nœuds : 

```julia
function transform_tour(tour::Vector{Edge{T}}) where T
    copy = tour[1 : length(tour)]
    start = copy[1].nodes[1]
    nodes_list = [start]
```

À chaque fois qu'on ajoute un nœud à la liste, on cherche l'arête qui le contient parmis celles restantes, on ajoute le second nœud de cette arête à la liste et on supprime l'arête : 

```julia
    for i = 1 : length(tour)
        indice = findfirst(x -> nodes_list[i] in x.nodes, copy)
        if copy[indice].nodes[1] == nodes_list[i]
            next = copy[indice].nodes[2]
        else
            next = copy[indice].nodes[1]
        end
        push!(nodes_list, next)
        deleteat!(copy,indice)
    end
```
Enfin, on renvoie la liste de nœuds qui correspond à la tournée :

```julia
    nodes_list
end
```

Il faut maintenant convertir cette liste de nœuds en une liste d'entiers, ce que fait la fonction *convert_tour*. La boucle s'arrête à l'avant-dernier indice de la liste pour que chaque sommet n'apparaisse qu'une fois : 

```julia
function convert_tour(tour::Vector{Node{T}}) where T
    tour_bis = Int64[]
    for i = 1 : length(tour) - 1
        push!(tour_bis, parse(Int, tour[i].name))
    end
    tour_bis
end
```

Notre dernière fonction cherche une tournée à l'aide de l'algorithme de montée puis crée le fichier .tour correspondant et renvoie également cette tournée sous forme de liste d'entiers : 

```julia
function make_tour(filename::String, tourname::String)
    graph = make_graph(filename)
    tour, weight = subgrad_opt_bis(graph)
    tour = transform_tour(tour)
    tour = convert_tour(tour)
    write_tour(tourname, tour, weight)
    return tour
end
```

Grâce à la fonction *reconstruct_picture*, nous avons maintenant tout ce qu'il faut pour reconstruire les images déchiquetées !
"""

# ╔═╡ 2914981e-1832-403a-aa44-ef11969843f4
md"""### Résultats
Les tournées obtenues se trouvent dans le dossier *tours* et les images dans le dossier *images reconstruites*. Ci-dessous, on peut comparer les images obtenues avec les originales. On voit que notre implémentation fonctionne très bien, à l'exception que les images sont coupées en deux à l'endroit qui correspond au passage par le nœud 0. On pourrait tenter de remédier à ce problème en forçant la tournée à commencer par ce nœud.
"""

# ╔═╡ 76767d20-6f35-11ed-00c8-a9b6c983afdd
md"""
|Originale | Déchiquetée   	| Reconstruite	| Longueur de la meilleure tournée	|
|---	|---	|---	|---	|
| ![Abstract light painting](https://raw.githubusercontent.com/MyriamLevy/mth6412b-starter-code/Phase-5/shredder-julia/images/original/abstract-light-painting.png)|![Abstract light painting](https://raw.githubusercontent.com/MyriamLevy/mth6412b-starter-code/Phase-5/shredder-julia/images/shuffled/abstract-light-painting.png)|![Abstract light painting](https://raw.githubusercontent.com/MyriamLevy/mth6412b-starter-code/Phase-5/projet/phase%205/images%20reconstruites/light.png)| 1,2315  	|
| ![Lower kananaskis lake](https://raw.githubusercontent.com/MyriamLevy/mth6412b-starter-code/Phase-5/shredder-julia/images/original/lower-kananaskis-lake.png)	|![Lower kananaskis lake](https://raw.githubusercontent.com/MyriamLevy/mth6412b-starter-code/Phase-5/shredder-julia/images/shuffled/lower-kananaskis-lake.png)	|![Lower kananaskis lake](https://raw.githubusercontent.com/MyriamLevy/mth6412b-starter-code/Phase-5/projet/phase%205/images%20reconstruites/lake.png)   	|   4,2266	|
| ![Niko's cat](https://raw.githubusercontent.com/MyriamLevy/mth6412b-starter-code/Phase-5/shredder-julia/images/original/nikos-cat.png)	|![Niko's cat](https://raw.githubusercontent.com/MyriamLevy/mth6412b-starter-code/Phase-5/shredder-julia/images/shuffled/nikos-cat.png)|![Niko's cat](https://raw.githubusercontent.com/MyriamLevy/mth6412b-starter-code/Phase-5/projet/phase%205/images%20reconstruites/cat.png)| 3,0367  	|
|![Pizza food wallpaper](https://raw.githubusercontent.com/MyriamLevy/mth6412b-starter-code/Phase-5/shredder-julia/images/original/pizza-food-wallpaper.png)	|![Pizza food wallpaper](https://raw.githubusercontent.com/MyriamLevy/mth6412b-starter-code/Phase-5/shredder-julia/images/shuffled/pizza-food-wallpaper.png)	|![Pizza food wallpaper](https://raw.githubusercontent.com/MyriamLevy/mth6412b-starter-code/Phase-5/projet/phase%205/images%20reconstruites/pizza.png)| 5,0413  	|
| ![The enchanted garden](https://raw.githubusercontent.com/MyriamLevy/mth6412b-starter-code/Phase-5/shredder-julia/images/original/the-enchanted-garden.png)	|![The enchanted garden](https://raw.githubusercontent.com/MyriamLevy/mth6412b-starter-code/Phase-5/shredder-julia/images/shuffled/the-enchanted-garden.png)|![The enchanted garden](https://raw.githubusercontent.com/MyriamLevy/mth6412b-starter-code/Phase-5/projet/phase%205/images%20reconstruites/garden.png)|  1,9914 	|
| ![Tokyo skytree aerial](https://raw.githubusercontent.com/MyriamLevy/mth6412b-starter-code/Phase-5/shredder-julia/images/original/tokyo-skytree-aerial.png)  	|![Tokyo skytree aerial](https://raw.githubusercontent.com/MyriamLevy/mth6412b-starter-code/Phase-5/shredder-julia/images/shuffled/tokyo-skytree-aerial.png)|![Tokyo skytree aerial](https://raw.githubusercontent.com/MyriamLevy/mth6412b-starter-code/Phase-5/projet/phase%205/images%20reconstruites/tokyo.png)  	|   1,3610	|


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
# ╟─ec313840-ba42-4713-a4a3-bd6d83cfa766
# ╟─706f9a6f-c122-491b-8a8c-e73808f36405
# ╟─7faec73f-20ca-4641-ab63-b57ea3792bbc
# ╟─2914981e-1832-403a-aa44-ef11969843f4
# ╟─76767d20-6f35-11ed-00c8-a9b6c983afdd
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
