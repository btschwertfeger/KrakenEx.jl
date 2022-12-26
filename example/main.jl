

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
# todo: signature wrong error 
# custom exceptions

# println(get_trade_balance(private_client))
# println(get_trade_balance(private_client, asset="DOT"))
# println(get_open_orders(private_client))
println(get_open_orders(private_client, trades=true))