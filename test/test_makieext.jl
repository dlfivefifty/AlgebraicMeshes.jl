using AlgebraicMeshes, Makie


@testset "AlgebraicMeshMakieExt" begin
    rects = [(0..1) × (1..2) , (0..1) × (0..1), (1..2) × (0..1)]
    m = AlgebraicMesh(rects)
    fig = plot(m)
    @test fig isa Makie.FigureAxisPlot
end
