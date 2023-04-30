
using Test

#==== S P O T ====#
@testset verbose = true "KrakenEx Spot REST User Endpoints" begin
    include(joinpath(@__DIR__, "spot", "user.jl"))
end

@testset verbose = true "KrakenEx Spot REST Market Endpoints" begin
    include(joinpath(@__DIR__, "spot", "market.jl"))
end

@testset verbose = true "KrakenEx Spot REST Trade Endpoints" begin
    include(joinpath(@__DIR__, "spot", "trade.jl"))
end

@testset verbose = true "KrakenEx Spot REST Funding Endpoints" begin
    include(joinpath(@__DIR__, "spot", "funding.jl"))
end

@testset verbose = true "KrakenEx Spot REST Staking Endpoints" begin
    include(joinpath(@__DIR__, "spot", "staking.jl"))
end

#==== F U T U R E S ====#
@testset verbose = true "KrakenEx Futures REST User Endpoints" begin
    include(joinpath(@__DIR__, "futures", "user.jl"))
end

@testset verbose = true "KrakenEx Futures REST Market Endpoints" begin
    include(joinpath(@__DIR__, "futures", "market.jl"))
end

@testset verbose = true "KrakenEx Futures REST Trade Endpoints" begin
    include(joinpath(@__DIR__, "futures", "trade.jl"))
end

@testset verbose = true "KrakenEx Futures REST Funding Endpoints" begin
    include(joinpath(@__DIR__, "futures", "funding.jl"))
end
