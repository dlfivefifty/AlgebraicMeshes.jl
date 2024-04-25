using AlgebraicMeshes, DomainSets, StaticArrays, Test
using DomainSets: ×


@testset "basic tests" begin
    rects = [(0..1) × (1..2) , (0..1) × (0..1), (1..2) × (0..1)]

    mesh = AlgebraicMesh(rects)

    @test SVector(0.1,0.2) ∈ mesh
    @test SVector(1.1,0.2) ∈ mesh
    @test SVector(0.1,1.2) ∈ mesh
    @test SVector(1.1,1.2) ∉ mesh
end

include("test_makieext.jl")