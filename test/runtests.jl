
using Test

#==== S P O T ====#
include(joinpath(@__DIR__, "spot", "market.jl"))
include(joinpath(@__DIR__, "spot", "user.jl"))

#==== F U T U R E S ====#
include(joinpath(@__DIR__, "futures", "market.jl"))

