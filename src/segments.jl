struct Segment{d,T} <: Domain{SVector{d,T}}
    a::SVector{d,T}
    b::SVector{d,T}
end

cross(d::ClosedInterval, y::Number) = Segment(SVector(d.left,y), SVector(d.right,y))
cross(x::Number, d::ClosedInterval) = Segment(SVector(x, d.left), SVector(x, d.right))