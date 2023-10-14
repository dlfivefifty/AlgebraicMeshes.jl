module AlgebraicMeshesMakieExt
using AlgebraicMeshes, Makie, StaticArrays
using DomainSets: leftendpoint, rightendpoint, Rectangle
import Base: convert

function convert(::Type{Vector{Point2f}}, r::Rectangle)
    (a,c) = leftendpoint(r)
    (b,d) = rightendpoint(r)
    Point2f[(a,c), (b,c), (b,d), (a,d)]
end

function convert(::Type{Rect}, r::Rectangle)
    (a,c) = leftendpoint(r)
    (b,d) = rightendpoint(r)
    Rect(a, c, b-a, d-c)
end

@recipe(AlgebraicMeshPlot, m) do scene
    Theme(
    )
end

Makie.plottype(a::AlgebraicMesh) = AlgebraicMeshPlot

function _algebraicmeshplot!(sc, m::AlgebraicMesh{d,T,<:NTuple{3,Any}}) where {T,d}
    poly!(sc, convert.(Rect, elements(m)))
    ed = edges(m)
    linesegments!(sc, reinterpret(eltype(eltype(ed)), ed))
    scatter!(sc, vertices(m))
    sc
end

function _algebraicmeshplot!(sc, m::AlgebraicMesh{d,T,<:NTuple{2,Any}}) where {T,d}
    el = elements(m)
    linesegments!(sc, reinterpret(eltype(eltype(el)), el))
    scatter!(sc, vertices(m))
    sc
end

function Makie.plot!(sc::AlgebraicMeshPlot)
    m = sc[:m][]
    _algebraicmeshplot!(sc, m)
end



end # module