

include("../src/KrakenEx.jl")
using .KrakenEx

#===== G E N E R A L =====#
client = SpotBaseRESTAPI()
# println(typeof(client))
# println(client.BASE_URL)
# println(get_server_time(client))

#====== M A R K E T ======#
# println(get_assets(client))
# println(get_tradable_asset_pair(client, pair=["XBTUSD", "DOTUSD"]))
# println(get_ticker(client, pair="DOTUSD"))
# println(get_ticker(client, pair=["DOTUSD", "XBTUSD"]))