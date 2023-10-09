module AlgebraicMeshes
using DomainSets, StaticArrays
import Base: in, ==, hash, issubset
import DomainSets: cross, boundary, interior
export AlgebraicMesh, Segment, boundarycomponents, LineSegment, vertices, edges, elements, interioredges

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
AlgebraicMesh{d}(elements::AbstractVector{E}) where {E,d} = AlgebraicMesh{d}(manifolddimension(E), elements)

function AlgebraicMesh{d}(::Val{2}, elements::AbstractVector) where d
    edges = union(boundarycomponents.(elements)...)
    vertices = union(boundarycomponents.(edges)...)
    AlgebraicMesh{d}((vertices,edges,elements))
end

function AlgebraicMesh{d}(::Val{1}, elements::AbstractVector) where d
    vertices = union(boundarycomponents.(elements)...)
    AlgebraicMesh{d}((vertices,elements))
end

vertices(m::AlgebraicMesh) = m.complex[1]
edges(m::AlgebraicMesh) = m.complex[2]
elements(m::AlgebraicMesh) = m.complex[end]

boundary(m::AlgebraicMesh) = AlgebraicMesh(filter(e -> count(t -> e ⊆ t, elements(m)) == 1, edges(m)))

"""
   interioredges(m)

returns all edges that are not in the boundary.
"""
interioredges(m::AlgebraicMesh) = AlgebraicMesh(filter(e -> count(t -> e ⊆ t, elements(m)) == 2, edges(m)))

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
interior(m::AlgebraicMesh) = AlgebraicMesh((interiorvertices(m), interioredges(m), elements(m)))

in(x, m::AlgebraicMesh) = any(d -> x in d, elements(m))

end # module AlgebraicMeshes
