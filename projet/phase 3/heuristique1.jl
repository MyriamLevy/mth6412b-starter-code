# code Heuristique1
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

function union_rank!(comp1::Comp{T}, comp2::Comp{T}) where T
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

