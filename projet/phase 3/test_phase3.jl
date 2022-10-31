using Test
include("union_rang.jl")
include("compr_chemins.jl")

@testset "Union via le rang" begin
    a = Node("a", 0)
    b = Node("b", 0)
    c = Node("c", 0)
    d = Node("d", 0)
    e = Node("e", 0)
    f = Node("f", 0)
    g = Node("g", 0)
    h = Node("h", 0)
    i = Node("i", 0)

    child_a = Child((a,a), 2)
    child_b = Child((b,a), 1)
    child_c = Child((c,a), 1)
    child_d = Child((d,b), 0)
    child_e = Child((e,e), 2)
    child_f = Child((f,e), 0)
    child_g = Child((g,e), 1)
    child_h = Child((h,e), 0)
    child_i = Child((i,g), 0)
    list_children = [child_a,child_b,child_c,child_d,child_e,child_f,child_g,child_h,child_i]
    comp_1 = Comp(a, [child_a, child_b, child_c, child_d])
    comp_2 = Comp(e, [child_e, child_f, child_g, child_h, child_i])

    root_1 = find_root(comp_1)
    root_2 = find_root(comp_2)
    children_1 = get_children(comp_1)
    children_2 = get_children(comp_2)
    len_1 = length(children_1)
    len_2 = length(children_2)


    @test root_1 == child_a
    @test root_2 == child_e
    @test get_nodes(root_1)[1] == get_root(comp_1)
    @test get_nodes(root_1)[2] == get_root(comp_1)
    @test get_nodes(root_2)[1] == get_root(comp_2)
    @test get_nodes(root_2)[2] == get_root(comp_2)

    rank_1 = get_rank(root_1)
    rank_2 = get_rank(root_2)
    comp = union_rank!(comp_1,comp_2)
    root = find_root(comp)
    rank = get_rank(root)
    children = get_children(comp)
    len = length(children)

    @test rank >= max(rank_1,rank_2)
    @test root == root_1 || root == root_2
    @test len == len_1 + len_2

    for child in children_1
        @test in_comp(comp,get_nodes(child)[1])
    end

    for child in children_2
        @test in_comp(comp,get_nodes(child)[1])
    end

end

@testset "Compression des chemins" begin
    a = Node("a", 0)
    b = Node("b", 0)
    c = Node("c", 0)
    d = Node("d", 0)
    e = Node("e", 0)
    f = Node("f", 0)
    g = Node("g", 0)
    h = Node("h", 0)
    i = Node("i", 0)

    child_a = Child((a,a), 2)
    child_b = Child((b,a), 1)
    child_c = Child((c,a), 1)
    child_d = Child((d,b), 0)
    child_e = Child((e,e), 2)
    child_f = Child((f,e), 0)
    child_g = Child((g,e), 1)
    child_h = Child((h,e), 0)
    child_i = Child((i,g), 0)
    list_children = [child_a,child_b,child_c,child_d,child_e,child_f,child_g,child_h,child_i]
    comp_1 = Comp(a, [child_a, child_b, child_c, child_d])
    comp_2 = Comp(e, [child_e, child_f, child_g, child_h, child_i])

    root_1 = find_root(comp_1)
    root_2 = find_root(comp_2)
    children_1 = get_children(comp_1)
    children_2 = get_children(comp_2)
    len_1 = length(children_1)
    len_2 = length(children_2)

    compr_1 = path_compr!(comp_1)
    compr_2 = path_compr!(comp_2)
    children_compr_1 = get_children(compr_1)
    children_compr_2 = get_children(compr_2)

    for child in children_1
        @test in_comp(compr_1,get_nodes(child)[1])
    end

    for child in children_2
        @test in_comp(compr_2,get_nodes(child)[1])
    end

    @test get_root(compr_1) == get_root(comp_1)
    @test get_root(compr_2) == get_root(comp_2)

    for child in children_compr_1
        @test get_rank(child) == 0 || get_nodes(child)[1] == get_nodes(child)[2]
        @test get_nodes(child)[2] == get_root(compr_1)
    end

    for child in children_compr_2
        @test get_rank(child) == 0 || get_nodes(child)[1] == get_nodes(child)[2]
        @test get_nodes(child)[2] == get_root(compr_2)
    end


    


end