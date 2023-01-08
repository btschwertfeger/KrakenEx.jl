module KrakenEx

include("utils.jl")

include("exceptions/exceptions.jl")
export SpotBaseRESTAPI

#===> S P O T - I M P O R T S <===#
include("spot/spot_base_api.jl")
using .SpotBaseAPIModule

include("spot/market.jl")
include("spot/user.jl")
include("spot/trade.jl")
include("spot/funding.jl")
include("spot/staking.jl")
include("spot/websocket.jl")

#====== F U T U R E S - I M P O R T S ======#
include("futures/futures_base_api.jl")
using .FuturesBaseAPIModule

include("futures/websocket.jl")
include("futures/market.jl")
include("futures/user.jl")
include("futures/trade.jl")
include("futures/funding.jl")

end
