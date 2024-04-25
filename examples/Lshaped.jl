using AlgebraicMeshes, DomainSets

rects = [(0..1) × (1..2) , (0..1) × (0..1), (1..2) × (0..1)]
mesh = AlgebraicMesh(rects)
plot(mesh)