""" C'est une structure de composante connexe qui prend deux arguments:
        root: qui répresente le noeud qui sert de racine à l'arbre
        children: est un vecteur qui contients des tuples avec trois éléments. Les deux premiers sont des noeuds de la forme(a,b) ou b est le noeud parent de a. Le troisième élément est le rang du noeud au sein de la composante connexe.
        """
mutable struct Comp_ranked{T}<:AbstractComp{T} 
    root::Node{T}
    children::Vector{Tuple{Node{T},Node{T},Int}}
end

"""Renvoie la racine de la composante connexe"""
get_root(comp::AbstractComp) = Comp_ranked.root

"""Renvoie les noeuds de la composante connexe"""
get_children(comp::AbstractComp) = Comp_ranked.children

# # code Heuristique1
# """ Il s'agit d'une fonction qui permet de créer une nouvelle structure de type comp_ranked à partir de la structure comp dévelloper précédenment dans la phase 2.
# """
# function convert_comp!(comp::Comp{T})# peut-etre pas necessaire, on pourrait juste modifier directement comp
#     #-----Création de structure comp avec un rang: comp--->Comp_ranked
#     comp_childs=get_children(comp)
#     x=[]
#     for i=1:length(comp_childs)
#         push!(x,(comp_childs[i](1),comp_childs[i](2),0))
#     end
#     comp_childs=x
#     comp_rkd=Comp_ranked(comp.root,comp_childs)
# # Les noeuds sont tous de rang 0.
#     return comp_rkd
# end

function find_children(parent::Node{T},comp_children::Vector{Tuple{Node{T},Node{T},Int}})
   idx=[]
    for i=1:length(comp_children)
        if parent==comp_children[i][2]
            push!(idx,i)
        end
    end
    return idx
end

function find_parent(children::Node{T},comp_children::Vector{Tuple{Node{T},Node{T},Int}})
     for i=1:length(comp_children)
         if children==comp_children[i][1]
             return i
             break
         end
     end
 end

 function height(comp::Comp_ranked)
    heighest=comp.children[1][3]
    for i=1:length(comp.children)
        if comp.children[i][3]>highest
            heighest=comp.children[i][3]
        end
    end
    return heighest
 end


function ranked_comp!(parent::Node{T},comp::Comp_ranked)
    idx=find_children(parent,comp.children)
    j=find_parent(comp.children[idx[1]][1],comp.children)
        for i=1:length(idx)
            comp.children[i][3]=comp.children[j][3]+1
            ranked_comp!(comp.children[i][1],comp)
        end
    return comp
end

function h1!(comp1::Comp{T},comp2::Comp{T})
    comp1_rkd=ranked_comp!(comp1.root,comp1)
    comp2_rkd=ranked_comp!(comp2.root,comp2)
    height_comp1=height(comp1_rkd)
    height_comp2=height(comp2_rkd)

    if height_comp1==height_comp2 || height_comp1>height_comp2 #on choisit la racine de comp1 comme parent de comp2
        new_comp=merge!(comp1_rkd,comp2_rkd)
     elseif height_comp2>height_comp1 #on choisit la racine de comp2 comme parent de comp1
        new_comp=merge!(comp2_rkd,comp1_rkd)
    end
    return new_comp
end
