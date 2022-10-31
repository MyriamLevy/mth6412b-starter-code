### A Pluto.jl notebook ###
# v0.19.11

using Markdown
using InteractiveUtils

# ╔═╡ 1bf9094d-82f5-40ae-ac55-a16e6bc5754f
let 
  include("node.jl")
  include("edge.jl")
  include("read_stsp.jl")
  include("make_graph.jl")
  include("graph.jl")
  println(0)
end

# ╔═╡ 775f23b8-3da3-11ed-1dab-2b8e6238fd87
md"""## Projet du voyageur de commerce : Phase 1"""

# ╔═╡ 042d77b3-a2cd-4c34-9386-c3bf50c01314
md"""Abdou Samad Dicko(2037205), Clélia Merel(2163025), Myriam Lévy(2225114)"""

# ╔═╡ 5cb5ba5e-c685-43f6-9cf5-fafcbaa501c2
md"""### Création du type *Edge*"""

# ╔═╡ 599b356c-bbf6-429e-ac27-0518a86c36a9
md"""On s'est appuyés sur la structure du type *Node* pour créer le type *Edge* : 

```julia
abstract type AbstractEdge{T} end

mutable struct Edge{T} <: AbstractEdge{T}
  nodes::Tuple{Node{T}, Node{T}}
  weight::Number
end
```
Récupérer les extrémités et le poids d'une arête : 
```julia
nodes(edge::AbstractEdge) = edge.nodes

weight(edge::AbstractEdge) = edge.weight
```
Afficher une arête : 
```julia
function show(edge::AbstractEdge)
  println("Edge ", nodes(edge), ", weight: ", weight(edge))
end
``` 
"""

# ╔═╡ 23ea2ccb-059b-4d33-b2bc-cc25827a5141
md"""### Extension du type *Graph*"""

# ╔═╡ 0837bde7-60c1-4243-af2f-b48f3267e9d5
md"""Ajout des arêtes au type *Graph* :
```julia
abstract type AbstractGraph{T} end

mutable struct Graph{T} <: AbstractGraph{T}
  name::String
  nodes::Vector{Node{T}}
  edges::Vector{Edge{T}}
end
```
Ajouter un nœud ou une arête au graphe : 
```julia
function add_node!(graph::Graph{T}, node::Node{T}) where T
  push!(graph.nodes, node)
  graph
end

function add_edge!(graph::Graph{T}, edge::Edge{T}) where T
  push!(graph.edges, edge)
  graph
end
```
Récupérer le nom, les nœuds, le nombre de nœuds ou les arêtes d'un graphe : 
```julia
name(graph::AbstractGraph) = graph.name

nodes(graph::AbstractGraph) = graph.nodes

nb_nodes(graph::AbstractGraph) = length(graph.nodes)

edges(graph::AbstractGraph) = graph.edges

nb_edges(graph::AbstractGraph) = length(graph.edges)
```
"""

# ╔═╡ de1a416c-38dd-4008-abb6-5fcc2318a703
md"""### Extension de la méthode *show*"""

# ╔═╡ 053ff6bd-47ce-42d3-86df-ba6822a33aaa
md"""
Afficher les nœuds d'un graphe, ses arrêtes ou les deux : 
```julia
function show_nodes(graph::Graph)
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes.")
  for node in nodes(graph)
    show(node)
  end
end

function show_edges(graph::Graph)
  println("Graph ", name(graph), " has ", nb_edges(graph), " edges.")
  for edge in edges(graph)
    show(edge)
  end
end

function show(graph::Graph)
  show_nodes(graph)
  show_edges(graph)
end
``` 
"""

# ╔═╡ 690bc9ef-640c-4f96-944f-7684b8311c6f
md"""### Extension de la fonction *read_edges()*"""

# ╔═╡ 094538a6-c9c9-4932-bc31-32a3b4697f2f
md""" Au debut de la fonction (ligne 99), on crée un vecteur vide qui contiendra les poids des arêtes :
```julia
edges_weight = []
```
Juste avant de récupérer une arête (ligne 136), on récupère son poids en le convertissant en entier : 
```julia
weight = parse(Int,data[j+1])
```
Enfin, on ajoute ce poids à la liste des poids (ligne 151) :
```julia
push!(edges_weight, weight)
```
La fonction renvoie la liste des arêtes et la liste de leurs poids respectifs :
```julia
return edges, edges_weight
```
"""

# ╔═╡ 6229c1f9-99bd-4723-a338-8b6e46eb2ef8
md"""### Création de la fonction *make_graph()*"""

# ╔═╡ bc2380ce-df43-46b1-84c7-f636f117d9e9
md"""
La fonction *make_graph* prend en argument un fichier .tsp et renvoie l'objet de type *Graph* correspondant. 
On récupère d'abord les nœuds, les arêtes et les poids à l'aide de *read_nodes* et *read_edges* : 
```julia
function make_graph(filename::String)
    header = read_header(filename)
    nodes_brut = read_nodes(header, filename)
    edges_brut = read_edges(header, filename)[1]
    weights = read_edges(header, filename)[2]
```
On crée les vecteurs qui contiendront les nœuds et les arêtes de notre graphe après avoir identifié le type des données des nœuds : 
```julia
    T = typeof(nodes_brut[1]) 
    nodes=Vector{Node{T}}(undef, length(nodes_brut))
    edges=Vector{Edge{T}}(undef, length(edges_brut))
```
On remplit le vecteur des nœuds en faisant attention que *nodes_brut* est un dictionnaire : 
```julia
    j = 1
    for k in keys(nodes_brut)
        node = Node(string(k), nodes_brut[k])
        nodes[j] = node
        j = j + 1
    end
```
On remplit de même le vecteur des arêtes :
```julia
    for i = 1 : length(edges_brut)
        n1 = Node(string(edges_brut[i][1]), nodes_brut[edges_brut[i][1]])
        n2 = Node(string(edges_brut[i][2]), nodes_brut[edges_brut[i][2]])
        edge = Edge((n1, n2), weights[i])
        edges[i] = edge
    end
```
On crée le graphe et on le renvoie :
```julia
    graph = Graph(filename, nodes, edges)
    return graph
end
```
"""

# ╔═╡ 6898e60f-87ff-43cf-bc75-f6b7e2a26141
md"""### Programme principal"""

# ╔═╡ 22a11e30-65c1-40b3-ba81-17b8a20e1f87
md""" Pour l'instant la fonction *main* correspond à la fonction *make_graph* mais elle sera amenée à être complétée : 
"""

# ╔═╡ 8a7da04e-273f-41c7-af9b-8e61eef931a7
function main(filename::String)
    graph = make_graph(filename)
end

# ╔═╡ 6d55b966-5f10-4c02-b52d-225376a1aaa3
md"""On teste le programme principal sur plusieurs fichiers .tsp :"""

# ╔═╡ 376c3bd3-1fbc-4f64-bb45-b02ef233dc35
main("instances/stsp/bayg29.tsp")

# ╔═╡ f237e5f8-70bb-4f6d-8661-07295b7dfa20
main("instances/stsp/dantzig42.tsp")

# ╔═╡ 093c6595-10ce-4619-9baa-d99657d017db
main("instances/stsp/gr120.tsp")

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
# ╟─775f23b8-3da3-11ed-1dab-2b8e6238fd87
# ╟─042d77b3-a2cd-4c34-9386-c3bf50c01314
# ╠═1bf9094d-82f5-40ae-ac55-a16e6bc5754f
# ╟─5cb5ba5e-c685-43f6-9cf5-fafcbaa501c2
# ╟─599b356c-bbf6-429e-ac27-0518a86c36a9
# ╟─23ea2ccb-059b-4d33-b2bc-cc25827a5141
# ╟─0837bde7-60c1-4243-af2f-b48f3267e9d5
# ╟─de1a416c-38dd-4008-abb6-5fcc2318a703
# ╟─053ff6bd-47ce-42d3-86df-ba6822a33aaa
# ╟─690bc9ef-640c-4f96-944f-7684b8311c6f
# ╟─094538a6-c9c9-4932-bc31-32a3b4697f2f
# ╟─6229c1f9-99bd-4723-a338-8b6e46eb2ef8
# ╟─bc2380ce-df43-46b1-84c7-f636f117d9e9
# ╟─6898e60f-87ff-43cf-bc75-f6b7e2a26141
# ╟─22a11e30-65c1-40b3-ba81-17b8a20e1f87
# ╠═8a7da04e-273f-41c7-af9b-8e61eef931a7
# ╟─6d55b966-5f10-4c02-b52d-225376a1aaa3
# ╠═376c3bd3-1fbc-4f64-bb45-b02ef233dc35
# ╠═f237e5f8-70bb-4f6d-8661-07295b7dfa20
# ╠═093c6595-10ce-4619-9baa-d99657d017db
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
