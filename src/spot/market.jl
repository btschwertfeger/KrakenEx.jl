module SpotMarketModule
using ..SpotBaseAPIModule: SpotBaseRESTAPI, request
using ..Utils

#======= E X P O R T S ========#
export get_server_time
export get_assets
export get_tradable_asset_pair
export get_ticker
export get_ohlc
export get_order_book
export get_recent_trades
export get_recend_spreads
export get_system_status

#======= F U N C T I O N S ========#
"""
    get_server_time(client::SpotBaseRESTAPI)

Returns the server time of the Kraken Cryptocurrency Exchange API
"""
function get_server_time(client::SpotBaseRESTAPI)
    return request(client, "GET", "/public/Time")["unixtime"]
end

"""
    get_assets(client::SpotBaseRESTAPI; assets::Union{Vector{String},String,Nothing}=nothing, aclass::Union{String,Nothing}=nothing)

https://docs.kraken.com/rest/#operation/getAssetInfo
"""
function get_assets(client::SpotBaseRESTAPI; assets::Union{Vector{String},String,Nothing}=nothing, aclass::Union{String,Nothing}=nothing)
    params = Dict{String,Any}()
    !isnothing(assets) ? params["asset"] = vector_to_string(assets) : nothing
    !isnothing(aclass) ? params["aclass"] = aclass : nothing
    return request(client, "GET", "/public/Assets"; data=params, auth=false)
end

"""
    get_tradable_asset_pair(client::SpotBaseRESTAPI; pair::Vector{String}, info::String="info")

https://docs.kraken.com/rest/#operation/getTradableAssetPairs
"""
function get_tradable_asset_pair(client::SpotBaseRESTAPI; pair::Vector{String}, info::String="info")
    params = Dict{String,Any}(
        "pair" => vector_to_string(pair),
        "info" => info
    )
    return request(client, "GET", "/public/AssetPairs"; data=params, auth=false)
end

"""
    get_ticker(client::SpotBaseRESTAPI; pair::Union{Vector{String},String,Nothing}=nothing)

https://docs.kraken.com/rest/#operation/getTickerInformation
"""
function get_ticker(client::SpotBaseRESTAPI; pair::Union{Vector{String},String,Nothing}=nothing)
    params = Dict{String,Any}()
    !isnothing(pair) ? params["pair"] = vector_to_string(pair) : nothing
    return request(client, "GET", "/public/Ticker"; data=params, auth=false)
end

"""
    get_ohlc(client::SpotBaseRESTAPI; pair::String, interval::Union{String,Nothing}=nothing, since::Union{Int64,Nothing}=nothing)

https://docs.kraken.com/rest/#operation/getOHLCData
"""
function get_ohlc(client::SpotBaseRESTAPI; pair::String, interval::Union{String,Nothing}=nothing, since::Union{Int64,Nothing}=nothing)
    params = Dict{String,String}("pair" => pair)
    !isnothing(interval) ? params["interval"] = interval : nothing
    !isnothing(since) ? params["since"] = since : nothing
    return request(client, "GET", "/public/OHLC"; data=params, auth=false)
end

"""
    get_order_book(client::SpotBaseRESTAPI; pair::String, count::Union{Int64,Nothing}=nothing)

https://docs.kraken.com/rest/#operation/getOrderBook
"""
function get_order_book(client::SpotBaseRESTAPI; pair::String, count::Union{Int64,Nothing}=nothing)
    params = Dict{String,String}("pair" => pair)
    !isnothing(count) ? params["count"] = count : nothing
    return request(client, "GET", "/public/Depth"; data=params, auth=false)
end

"""
    get_recent_trades(client::SpotBaseRESTAPI; pair::String, since::Union{Int64,Nothing}=nothing)

https://docs.kraken.com/rest/#operation/getRecentTrades
"""
function get_recent_trades(client::SpotBaseRESTAPI; pair::String, since::Union{Int64,Nothing}=nothing)
    params = Dict{String,String}("pair" => pair)
    !isnothing(since) ? params["since"] = since : nothing
    return request(client, "GET", "/public/Trades"; data=params, auth=false)
end

"""
    get_recend_spreads(client::SpotBaseRESTAPI; pair::String, since::Union{Int64,Nothing}=nothing)

https://docs.kraken.com/rest/#operation/getRecentSpreads
"""
function get_recend_spreads(client::SpotBaseRESTAPI; pair::String, since::Union{Int64,Nothing}=nothing)
    params = Dict{String,String}("pair" => pair)
    !isnothing(since) ? params["since"] = since : nothing
    return request(client, "GET", "/public/Spread"; data=params, auth=false)
end

"""
    get_system_status(client::SpotBaseRESTAPI)

Returns the system status of the Kraken API
"""
function get_system_status(client::SpotBaseRESTAPI)
    return request(client, "GET", "/public/SystemStatus"; auth=false)
end
end