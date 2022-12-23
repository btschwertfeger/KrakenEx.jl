module KrakenSpotMarketModule
using ..KrakenSpotBaseAPIModule

#======= Exports ========#
export get_server_time
export get_assets
export get_tradable_asset_pair


#======= F U N C T I O N S ========#

function get_server_time(client::SpotBaseRESTAPI)
    return request(client, "GET", "/public/Time")["unixtime"]
end

function get_assets(client::SpotBaseRESTAPI; assets=nothing, aclass=nothing)
    """https://docs.kraken.com/rest/#operation/getAssetInfo"""
    params = Dict{String, String}()
    if assets !== nothing 
        params["asset"] = vector_to_string(assets)
    end
    if  aclass !== nothing 
        params["aclass"] = aclass
    end
    return request(client, "GET", "/public/Assets"; data=params, auth=false)
end

function get_tradable_asset_pair(client::SpotBaseRESTAPI; pair::Vector{String}, info::String="info")
    """https://docs.kraken.com/rest/#operation/getTradableAssetPairs"""
    params = Dict{String, String}()
    params["pair"] = vector_to_string(pair)
    params["info"] = info
    println(params)
    return request(client, "GET", "/public/AssetPairs"; data=params, auth=false)
end

end