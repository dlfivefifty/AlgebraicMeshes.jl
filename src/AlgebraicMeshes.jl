module AlgebraicMeshes
using DomainSets, StaticArrays
import Base: in, ==, hash
import DomainSets: cross
export AlgebraicMesh, Segment, boundarycomponents, LineSegment, vertices, edges, elements

include("segments.jl")



"""
    Mesh

is a type representing a set of elements (either simplicial or otherwise),
alongside edges, etc.
"""
struct AlgebraicMesh{d,T,El<:Tuple} <: Domain{SVector{d,T}}
    complex::El # a tuple of all the components of dimension 0,…,d. In 2D this is (vertices,edges,elements)
end

AlgebraicMesh{d}(comp::Tuple{AbstractVector{<:AbstractVector{T}},Vararg{Any}}) where {d,T} = AlgebraicMesh{d,T,typeof(comp)}(comp)

# assume 2D for now
AlgebraicMesh(elements::Vector) = AlgebraicMesh{2}(elements)
function AlgebraicMesh{2}(elements::Vector)
    edges = union(boundarycomponents.(elements)...)
    vertices = union(boundarycomponents.(edges)...)
    AlgebraicMesh{2}((vertices,edges,elements))
end

vertices(m::AlgebraicMesh) = m.complex[1]
edges(m::AlgebraicMesh) = m.complex[2]
elements(m::AlgebraicMesh) = m.complex[3]

in(x, m::AlgebraicMesh) = any(d -> x in d, elements(m))

end # module AlgebraicMeshes
