module KrakenEx

#= U T I L S =#
include("utils.jl")

#= S P O T - E X P O R T S =#
export SpotBaseRESTAPI

#===> M A R K E T <===#
export get_server_time
export get_assets
export get_tradable_asset_pair
export get_ticker
export get_ohlc
export get_order_book
export get_recent_trades
export get_recend_spreads
export get_system_status

#===> U S E R <===#
export get_account_balance
export get_trade_balance
export get_open_orders

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
