function transform_tour(tour::Vector{Edge{T}}) where T
    copy = tour[1 : length(tour)]
    start = copy[1].nodes[1]
    nodes_list = [start]
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
    nodes_list
end

function convert_tour(tour::Vector{Node{T}}) where T
    tour_bis = []
    for i = 1 : length(tour)
        push!(tour_bis, parse(Int, tour[i].name))
    end
    tour_bis
end