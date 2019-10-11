using Test, ConvolutionalOperatorLearning
using Random

# Load reference implementation
include(joinpath(@__DIR__,"Reference.jl"))

# Random gaussian images (2D)
@testset "Random gaussian images (2D)" begin
	rng = MersenneTwister(1)
	x = [randn(rng,128,128) for _ in 1:62]

	# 3 x 3 filters
	R = (3,3)
	H0 = generatefilters(:DCT,R,form=:matrix)

	λ, iters = 1e-4, 4
	for p in 0:2:8
		@testset "3 x 3 filters (p = $p)" begin
			refH, refHtrace, refobjtrace, refHdifftrace =
				Reference.CAOL(x,λ,H0[:,p+1:end],R,iters,1e-13)
			H, Htrace, objtrace, Hdifftrace =
				CAOL(x,λ,(H0[:,p+1:end],R),maxiters=iters,tol=1e-13,trace=true)

			@test H          == refH
			@test Htrace     == refHtrace
			@test objtrace   == refobjtrace
			@test Hdifftrace == refHdifftrace

			H = CAOL(x,λ,(H0[:,p+1:end],R),maxiters=iters,tol=1e-13)
			@test H == refH
		end
	end

	# 4 x 4 filters
	R = (4,4)
	H0 = generatefilters(:DCT,R,form=:matrix)

	λ, iters = 1e-4, 4
	for p in 0:5:15
		@testset "4 x 4 filters (p = $p)" begin
			refH, refHtrace, refobjtrace, refHdifftrace =
				Reference.CAOL(x,λ,H0[:,p+1:end],R,iters,1e-13)
			H, Htrace, objtrace, Hdifftrace =
				CAOL(x,λ,(H0[:,p+1:end],R),maxiters=iters,tol=1e-13,trace=true)

			@test H          == refH
			@test Htrace     == refHtrace
			@test objtrace   == refobjtrace
			@test Hdifftrace == refHdifftrace

			H = CAOL(x,λ,(H0[:,p+1:end],R),maxiters=iters,tol=1e-13)
			@test H == refH
		end
	end
end

# Random overlaid squares (2D)
@testset "Random overlaid squares (2D)" begin
	rng = MersenneTwister(1)
	square((x,y),w,n) = [y-w<i<y+w && x-w<j<x+w ? 1.0 : 0.0 for i in 1:n, j in 1:n]
	randsquare(rng,wrange,n,T) = square(
		rand(rng,1+first(wrange):n-first(wrange),2),
		rand(rng,wrange), n)
	x = [sum(randsquare(rng,30:40,128,1) for _ in 1:4) for _ in 1:62]

	# 3 x 3 filters
	R = (3,3)
	H0 = generatefilters(:DCT,R,form=:matrix)

	λ, iters = 1e-2, 4
	for p in 0:2:8
		@testset "3 x 3 filters (p = $p)" begin
			refH, refHtrace, refobjtrace, refHdifftrace =
				Reference.CAOL(x,λ,H0[:,p+1:end],R,iters,1e-13)
			H, Htrace, objtrace, Hdifftrace =
				CAOL(x,λ,(H0[:,p+1:end],R),maxiters=iters,tol=1e-13,trace=true)

			@test H          == refH
			@test Htrace     == refHtrace
			@test objtrace   == refobjtrace
			@test Hdifftrace == refHdifftrace

			H = CAOL(x,λ,(H0[:,p+1:end],R),maxiters=iters,tol=1e-13)
			@test H == refH
		end
	end

	# 4 x 4 filters
	R = (4,4)
	H0 = generatefilters(:DCT,R,form=:matrix)

	λ, iters = 1e-2, 4
	for p in 0:5:15
		@testset "4 x 4 filters (p = $p)" begin
			refH, refHtrace, refobjtrace, refHdifftrace =
				Reference.CAOL(x,λ,H0[:,p+1:end],R,iters,1e-13)
			H, Htrace, objtrace, Hdifftrace =
				CAOL(x,λ,(H0[:,p+1:end],R),maxiters=iters,tol=1e-13,trace=true)

			@test H          == refH
			@test Htrace     == refHtrace
			@test objtrace   == refobjtrace
			@test Hdifftrace == refHdifftrace

			H = CAOL(x,λ,(H0[:,p+1:end],R),maxiters=iters,tol=1e-13)
			@test H == refH
		end
	end
end

# need to test:
# + all signatures
# + termination condition (make sure all agree)
# + rectangular filters
# + 1d filters/data
# + 3d filters/data
# + filter/data dimension mismatch, e.g., 1d filter but 2d data
