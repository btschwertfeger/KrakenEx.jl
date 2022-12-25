module KrakenEx

#= S P O T - E X P O R T S =#
export SpotBaseRESTAPI

#===> M A R K E T <===#
export get_server_time
export get_assets
export get_tradable_asset_pair
export get_ticker

#===> U S E R <===#

#===> T R A D E <===#

#===> F U N D I N G <===#

#===> S T A K I N G <===#


include("spot/spot_base_api.jl")
using .KrakenSpotBaseAPIModule

include("spot/market.jl")
using .KrakenSpotMarketModule

include("spot/user.jl")
using .KrakenSpotUserModule

include("spot/trade.jl")
using .KrakenSpotTradeModule

include("spot/funding.jl")
using .KrakenSpotFundingModule

include("spot/staking.jl")
using .KrakenSpotStakingModule

#====== F U T U R E S - E X P O R T S ======#


end
