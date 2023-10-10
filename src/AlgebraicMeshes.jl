module AlgebraicMeshes
using DomainSets, StaticArrays, LinearAlgebra
import Base: in, ==, hash, issubset, first, last
import DomainSets: cross, boundary, interior
export AlgebraicMesh, Segment, boundarycomponents, LineSegment, vertices, edges, elements, interiorvertices, interioredges, neighborhood

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

AlgebraicMesh(comp::Tuple{AbstractVector{<:SVector{d}},Vararg{Any}}) where d = AlgebraicMesh{d}(comp)

# assume 2D for now. Following constructors create closure 
AlgebraicMesh(elements::AbstractVector{<:Domain{SVector{d,T}}}) where {d,T} = AlgebraicMesh{d}(elements)
AlgebraicMesh(elements::AbstractVector{<:SVector{d,T}}) where {d,T} = AlgebraicMesh{d}(elements)
AlgebraicMesh{d}(elements::AbstractVector{E}) where {E,d} = AlgebraicMesh{d}(manifolddimension(E), elements)

function AlgebraicMesh{d}(::Val{2}, els::AbstractVector) where d
    edges = union(boundarycomponents.(els)...)
    vertices = union(boundarycomponents.(edges)...)
    AlgebraicMesh{d}((vertices,edges,els))
end

function AlgebraicMesh{d}(::Val{1}, els::AbstractVector) where d
    vertices = union!(vcat(boundarycomponents.(els)...))
    AlgebraicMesh{d}((vertices,els))
end
AlgebraicMesh{d}(::Val{0}, els::AbstractVector) where d = AlgebraicMesh{d}((els,))

vertices(m::AlgebraicMesh) = m.complex[1]
edges(m::AlgebraicMesh) = m.complex[2]
elements(m::AlgebraicMesh) = m.complex[end]

boundary(m::AlgebraicMesh) = AlgebraicMesh(filter(e -> count(t -> e ⊆ t, elements(m)) == 1, m.complex[end-1]))

"""
   interioredges(m)

returns all edges that are not in the boundary.
"""
interioredges(m::AlgebraicMesh) = filter(e -> count(t -> e ⊆ t, elements(m)) == 2, edges(m))

"""
   interiorvertices(m)

returns all verticies that are not in the boundary.
"""
function interiorvertices(m::AlgebraicMesh)
    b = vertices(boundary(m))
    filter(v -> v ∉ b, vertices(m))
end


"""
   interior(m)

returns a mesh with the boundary removed.
"""
interior(m::AlgebraicMesh{d,T,<:NTuple{3,Any}}) where {d,T} = AlgebraicMesh((interiorvertices(m), interioredges(m), elements(m)))
interior(m::AlgebraicMesh{d,T,<:NTuple{2,Any}}) where {d,T} = AlgebraicMesh((interiorvertices(m), elements(m)))

in(x, m::AlgebraicMesh) = any(d -> x in d, elements(m))

neighborhood(m::AlgebraicMesh, x) = AlgebraicMesh(map(c -> filter(e -> x ∈ e, c),   m.complex))

end # module AlgebraicMeshes
