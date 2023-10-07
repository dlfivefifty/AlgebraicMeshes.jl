module AlgebraicMeshesMakieExt
using AlgebraicMeshes, Makie
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

function Makie.plot!(sc::AlgebraicMeshPlot)
    m = sc[:m][]
    poly!(sc, convert.(Rect, elements(m)))
    linesegments!(sc, reinterpret(SVector{2,Int}, edges(m)))
    scatter!(sc, vertices(m))
    sc
end



end # module