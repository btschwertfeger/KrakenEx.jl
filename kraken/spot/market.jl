module KrakenSpotMarketModule
using ..KrakenSpotBaseAPIModule

#======= Exports ========#
export get_assets

#======= F U N C T I O N S ========#

function get_assets(client::SpotBaseRESTAPI; assets=nothing, aclass=nothing)
    """https://docs.kraken.com/rest/#operation/getAssetInfo"""
    params = Dict{String, String}()
    if assets !== nothing 
        params["asset"] = array_to_string(assets)
    end
    if  aclass !== nothing 
        params["aclass"] = aclass
    end
    return request(client, "GET", "/public/Assets"; data=params, auth=false)

end

end