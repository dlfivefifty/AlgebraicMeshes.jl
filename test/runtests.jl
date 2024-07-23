using AlgebraicMeshes, DomainSets, StaticArrays, Test
using DomainSets: ×


@testset "rectangular mesh" begin
    rects = [(0..1) × (1..2) , (0..1) × (0..1), (1..2) × (0..1)]

    mesh = AlgebraicMesh(rects)

    @test SVector(0.1,0.2) ∈ mesh
    @test SVector(1.1,0.2) ∈ mesh
    @test SVector(0.1,1.2) ∈ mesh
    @test SVector(1.1,1.2) ∉ mesh
end

@testset "triangular mesh" begin
    tris = [
        
    
    (0..1) × (1..2) , (0..1) × (0..1), (1..2) × (0..1)]
end

include("test_makieext.jl")