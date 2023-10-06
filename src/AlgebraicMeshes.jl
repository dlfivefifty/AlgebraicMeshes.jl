module AlgebraicMeshes
using DomainSets, StaticArrays
import Base: in
import DomainSets: cross
export Mesh, Segment

include("segments.jl")



"""
    Mesh

is a type representing a set of elements (either simplicial or otherwise),
alongside edges, etc.
"""
struct Mesh{d,T,El<:Tuple} <: Domain{SVector{d,T}}
    complex::El # a tuple of all the components of dimension d,d-1,…,1,0. In 2D this is (elements,vertices,edges)
end

elements(m::Mesh) = m.complex[1]
edges(m::Mesh) = m.complex[2]
vertices(m::Mesh) = m.complex[3]

in(x, m::Mesh) = any(in(x), elements(m))

end # module AlgebraicMeshes
