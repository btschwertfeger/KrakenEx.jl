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
export get_closed_orders
export get_orders_info
export get_trades_history
export get_trades_info
export get_open_positions
export get_ledgers_info
export get_ledgers
export get_trade_volume
export request_export_report
export get_export_report_status
export retrieve_export
export delete_export_report

#===> T R A D E <===#
export create_order
export create_order_batch
export edit_order
export cancel_order
export cancel_all_orders
export cancel_all_orders_after_x
export cancel_order_batch

#===> F U N D I N G <===#
export get_deposit_methods
export get_deposit_address
export get_recend_deposits_status
export get_withdrawal_info
export get_recend_withdraw_status
export cancel_withdraw
export wallet_transfer

#===> S T A K I N G <===#
export stake_asset
export unstake_asset
export list_stakeable_assets
export get_pending_staking_transactions
export list_staking_transactions

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
