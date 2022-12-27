
# todo: signature wrong error 
# custom exceptions

include("../src/KrakenEx.jl")
using .KrakenEx

using DotEnv

#===== G E N E R A L =====#
client = SpotBaseRESTAPI()
# println(client.BASE_URL)
# println(get_server_time(client))

DotEnv.config(path=".env")
private_client = SpotBaseRESTAPI(ENV["SPOT_API_KEY"], ENV["SPOT_SECRET_KEY"])

#====== M A R K E T ======#
# println(get_assets(client))
# println(get_tradable_asset_pair(client, pair=["XBTUSD", "DOTUSD"]))
# println(get_ticker(client, pair="DOTUSD"))
# println(get_ticker(client, pair=["DOTUSD", "XBTUSD"]))
# println(get_ohlc(client, pair="XBTUSD"))
# println(get_order_book(client, pair="XBTUSD"))
# println(get_recent_trades(client, pair="XBTUSD"))
# println(get_recend_spreads(client, pair="XBTUSD"))
# println(get_system_status(client))


#====== U S E R ======#
# println(get_account_balance(private_client))

# println(get_trade_balance(private_client))
# println(get_trade_balance(private_client, asset="DOT"))

# println(get_open_orders(private_client))
# println(get_open_orders(private_client, trades=true))

# println(get_closed_orders(private_client))
# println(get_closed_orders(private_client, trades=true))
# for closetime ∈ ["close", "open", "both"]
#     println(
#         get_closed_orders(
#             private_client,
#             trades=true,
#             start=1668431675,
#             end_=1668455555,
#             ofs=1,
#             closetime=closetime
#         )
#     )
# end

# println(get_orders_info(private_client, txid="OXBBSK-EUGDR-TDNIEQ"))
# println(
#     get_orders_info(
#         private_client,
#         txid="OXBBSK-EUGDR-TDNIEQ",
#         trades=true
#     )
# )
# println(
#     get_orders_info(
#         private_client,
#         txid=["OXBBSK-EUGDR-TDNIEQ", "O23GOI-WZDVD-XWGC3R"],
#         trades=true
#     )
# )

# for type ∈ ["all", "any position", "closed position", "closing position", "no position"]
#     println(get_trades_history(private_client, type=type, start=1668431675, trades=true))
#     println(get_trades_history(private_client, type=type, end_=1668431675, ofs=1, trades=false))
# end

# println(get_trades_info(private_client, txid="OQQYNL-FXCFA-FBFVD7"))

# println(get_open_positions(private_client))
# println(get_open_positions(private_client, txid="OQQYNL-FXCFA-FBFVD7"))
# println(get_open_positions(private_client, txid="OQQYNL-FXCFA-FBFVD7", docalcs=true))

# println(get_ledgers_info(private_client))
# println(get_ledgers_info(private_client, asset="DOT"))
# println(get_ledgers_info(private_client, asset="DOT,EUR"))
# println(get_ledgers_info(private_client, asset=["DOT", "EUR"]))
# for type ∈ [
#     "all", "deposit", "withdrawal",
#     "trade", "margin", "rollover",
#     "credit", "transfer", "settled",
#     "staking", "sale"
# ]
#     println(
#         get_ledgers_info(
#             private_client,
#             type=type,
#             aclass="currency",
#             start=1668431675,
#             end_=1668455555,
#             ofs=1
#         )
#     )
# end

# println(get_ledgers(private_client, id="LNYQGU-SUR5U-UXTOWM"))
# println(get_ledgers(private_client, id=["LNYQGU-SUR5U-UXTOWM", "LTCMN2-5DZHX-6CPRC4"], trades=false))

# println(get_trade_volume(private_client))
# println(get_trade_volume(private_client, pair="DOTUSD"))
# println(get_trade_volume(private_client, pair="DOTUSD", fee_info=false))

# TODO:
# println(request_export_report(private_client,))
# println(get_export_report_status(private_client,))
# println(retrieve_export(private_client,))
# println(delete_export_report(private_client,))

#===> T R A D E <===#
# println(create_order(private_client,))
# println(create_order_batch(private_client,))
# println(edit_order(private_client,))
# println(cancel_order(private_client,))
# println(cancel_all_orders(private_client,))
# println(cancel_all_orders_after_x(private_client,))
# println(cancel_order_batch(private_client,))

#===> F U N D I N G <===#
# println(get_deposit_methods(private_client,))
# println(get_deposit_address(private_client,))
# println(get_recend_deposits_status(private_client,))
# println(get_withdrawal_info(private_client,))
# println(get_recend_withdraw_status(private_client,))
# println(cancel_withdraw(private_client,))
# println(wallet_transfer(private_client,))

#===> S T A K I N G <===#
# println(stake_asset(private_client,))
# println(unstake_asset(private_client,))
# println(list_stakeable_assets(private_client,))
# println(get_pending_staking_transactions(private_client,))
# println(list_staking_transactions(private_client,))
