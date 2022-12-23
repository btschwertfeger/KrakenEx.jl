include("../kraken/spot/spot_base_api.jl")
using .KrakenSpotBaseAPIModule

include("../kraken/spot/market.jl")
using .KrakenSpotMarketModule



client = SpotBaseRESTAPI()
# println(typeof(client))
# println(client.BASE_URL)
# println(get_server_time(client))

#====== M A R K E T ======#
# println(get_assets(client))
# println(get_tradable_asset_pair(client, pair=["XBTUSD", "DOTUSD"]))
