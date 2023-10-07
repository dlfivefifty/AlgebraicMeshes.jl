using AlgebraicMeshes, DomainSets, StaticArrays, Test
using DomainSets: ×


rects = [(0..1) × (1..2) , (0..1) × (0..1), (1..2) × (0..1)]

mesh = AlgebraicMesh(rects)

@test SVector(0.1,0.2) ∈ mesh
@test SVector(1.1,0.2) ∈ mesh
@test SVector(0.1,1.2) ∈ mesh
@test SVector(1.1,1.2) ∉ mesh
