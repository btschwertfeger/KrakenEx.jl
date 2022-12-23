include("../kraken/spot/spot_base_api.jl")
using .KrakenSpotBaseAPIModule

include("../kraken/spot/market.jl")
using .KrakenSpotMarketModule



client = SpotBaseRESTAPI()
println(typeof(client))
println(client.BASE_URL)
println(get_assets(client))
