manifolddimension(::Type{<:Rectangle}) = Val(2)

"""
    LineSegment(a, b)

is a line segment from two points in d-dimensions, without orientation.
"""
struct LineSegment{d,T} <: Domain{SVector{d,T}}
    a::SVector{d,T}
    b::SVector{d,T}
end

manifolddimension(::Type{<:LineSegment}) = Val(1)

cross(d::ClosedInterval, y::Number) = LineSegment(SVector(d.left,y), SVector(d.right,y))
cross(x::Number, d::ClosedInterval) = LineSegment(SVector(x, d.left), SVector(x, d.right))


==(l1::LineSegment, l2::LineSegment) = (l1.a == l2.a && l1.b == l2.b) || (l1.a == l2.b && l1.b == l2.a)
# TODO: good hash for 3D
hash(l::LineSegment) = hash((min(l.a[1],l.b[1]),max(l.a[1],l.b[1]),min(l.a[2],l.b[2]),max(l.a[2],l.b[2])))


boundarycomponents(d::LineSegment) = [d.a,d.b]

issubset(l::LineSegment, r::Rectangle) = l.a in r && l.b in r

# boundary(::Rectangle) in DomainSets.jl is too complicated...
# The following could be moved to DomainSets.jl in the future.
# Alternatively, `LineSegment` could be a type alias for an affine mapped
# unit interval.
function boundarycomponents(rect::Rectangle{<:SVector{2}})
	(a,c) = leftendpoint(rect)
	(b,d) = rightendpoint(rect)
    [LineSegment(SVector(a,c),SVector(b,c)), LineSegment(SVector(b,c),SVector(b,d)),
     LineSegment(SVector(b,d),SVector(a,d)), LineSegment(SVector(a,d),SVector(a,c))]
end