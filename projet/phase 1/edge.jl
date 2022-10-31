"""Type abstrait dont d'autres types d'arêtes dériveront."""
abstract type AbstractEdge{T} end

"""Type représentant les arêtes d'un graphe."""
mutable struct Edge{T} <: AbstractEdge{T}
  nodes::Tuple{Node{T}, Node{T}}
  weight::Number
end

"""Renvoie les extrémités d'une arête."""
nodes(edge::AbstractEdge) = edge.nodes

"""Renvoie le poids d'une arête."""
weight(edge::AbstractEdge) = edge.weight

"""Affiche une arête."""
function show(edge::AbstractEdge)
  println("Edge ", nodes(edge), ", weight: ", weight(edge))
end