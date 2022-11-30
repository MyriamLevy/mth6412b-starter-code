include("tsp_image.jl")

function main(tsp_name::String, tour_name::String, shuffled_image_name::String, reconstructed_image_name::String)
    make_tour(tsp_name, tour_name)
    reconstruct_picture(tour_name, shuffled_image_name, reconstructed_image_name)
end