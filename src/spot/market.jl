
"""
    SpotMarketModule

Enables accessing Spot market endpoints using predefined methods.
"""
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
export get_recent_spreads
export get_system_status

#======= F U N C T I O N S ========#
"""
    get_server_time(client::SpotBaseRESTAPI)

Returns the server time of the Kraken Cryptocurrency Exchange API

# Examples
```julia-repl
julia> client = SpotBaseRESTAPI()
julia> println(get_server_time(client))
1673344450
```
"""
function get_server_time(client::SpotBaseRESTAPI)
    return request(client, "GET", "/public/Time")["unixtime"]
end

"""
    get_assets(client::SpotBaseRESTAPI; assets::Union{Vector{String},String,Nothing}=nothing, aclass::Union{String,Nothing}=nothing)

Kraken Docs: [https://docs.kraken.com/rest/#operation/getAssetInfo](https://docs.kraken.com/rest/#operation/getAssetInfo)

Returns a list of available Spot assets as well as additional descriptions.

Authenticated `client` not required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI()
julia> println(get_assets(client))
Dict{String, Any}(
    "MOVR" => Dict{String, Any}(
        "display_decimals" => 5,
        "decimals" => 10,
        "aclass" => "currency",
        "status" => "enabled",
        "altname" => "MOVR"
    ), "SXP" => Dict{String, Any}(
        "display_decimals" => 5,
        "decimals" => 10,
        "aclass" => "currency",
        "status" => "enabled",
        "altname" => "SXP"
    ), "PHA" => Dict{String, Any}(
        "display_decimals" => 5,
        "decimals" => 10,
        "aclass" => "currency",
        "status" => "enabled",
        "altname" => "PHA"
    ), ...
)
```
"""
function get_assets(
    client::SpotBaseRESTAPI;
    assets::Union{Vector{String},String,Nothing}=nothing,
    aclass::Union{String,Nothing}=nothing
)
    params = Dict{String,Any}()
    !isnothing(assets) ? params["asset"] = vector_to_string(assets) : nothing
    !isnothing(aclass) ? params["aclass"] = aclass : nothing
    return request(client, "GET", "/public/Assets"; data=params, auth=false)
end

"""
    get_tradable_asset_pair(client::SpotBaseRESTAPI; pair::Vector{String}, info::String="info")

Kraken Docs: [https://docs.kraken.com/rest/#operation/getTradableAssetPairs](https://docs.kraken.com/rest/#operation/getTradableAssetPairs)

Returns a list of available symbols (asset pairs) and additional informarion.

Authenticated `client` not required

# Examples
```julia-repl
julia> client = SpotBaseRESTAPI()
julia> println(get_tradable_asset_pair(client, pair=["XBTUSD"]))
Dict{String, Any}(
    "XXBTZUSD" => Dict{String, Any}(
        "margin_call" => 80,
        "leverage_sell" => Any[2, 3, 4, 5],
        "cost_decimals" => 5,
        "lot_multiplier" => 1,
        "long_position_limit" => 270,
        "short_position_limit" => 180,
        "fees_maker" => Any[
            Any[0, 0.16],
            Any[50000, 0.14],
            Any[100000, 0.12],
            Any[250000, 0.1],
            Any[500000, 0.08],
            Any[1000000, 0.06],
            Any[2500000, 0.04],
            Any[5000000, 0.02],
            Any[10000000, 0.0],
            Any[100000000, 0.0]
        ],
        "ordermin" => "0.0001",
        "aclass_base" => "currency",
        "fee_volume_currency" => "ZUSD",
        "status" => "online",
        "altname" => "XBTUSD",
        "aclass_quote" => "currency",
        "margin_stop" => 40,
        "fees" => Any[
            Any[0, 0.26],
            Any[50000, 0.24],
            Any[100000, 0.22],
            Any[250000, 0.2],
            Any[500000, 0.18],
            Any[1000000, 0.16],
            Any[2500000, 0.14],
            Any[5000000, 0.12],
            Any[10000000, 0.1],
            Any[100000000, 0.08]
        ],
        "quote" => "ZUSD",
        "base" => "XXBT",
        "lot" => "unit",
        "pair_decimals" => 1,
        "wsname" => "XBT/USD",
        "costmin" => "0.5",
        "tick_size" => "0.1",
        "lot_decimals" => 8,
        "leverage_buy" => Any[2, 3, 4, 5]
    )
)
```
"""
function get_tradable_asset_pair(client::SpotBaseRESTAPI; pair::Union{Vector{String},String}, info::String="info")
    params = Dict{String,Any}(
        "pair" => vector_to_string(pair),
        "info" => info
    )
    return request(client, "GET", "/public/AssetPairs"; data=params, auth=false)
end

"""
    get_ticker(client::SpotBaseRESTAPI; pair::Union{Vector{String},String,Nothing}=nothing)

Kraken Docs: [https://docs.kraken.com/rest/#operation/getTickerInformation](https://docs.kraken.com/rest/#operation/getTickerInformation)

Returns the actual ticker of a given `pair` (asset pair/symbol).

Authenticated `client` not required

# Examples
```julia-repl
julia> client = SpotBaseRESTAPI()
julia> println(get_ticker(client, pair="DOTUSD"))
Dict{String, Any}(
    "DOTUSD" => Dict{String, Any}(
        "v" => Any["73347.09060256", "831710.16212826"],
        "c" => Any["4.91490", "145.01800000"],
        "o" => "4.88630", "t" => Any[635, 3486],
        "b" => Any["4.91220", "265", "265.000"],
        "l" => Any["4.82900", "4.82900"],
        "a" => Any["4.91290", "82", "82.000"],
        "p" => Any["4.89699", "4.97257"],
        "h" => Any["4.93300", "5.07400"]
    )
)
```
"""
function get_ticker(client::SpotBaseRESTAPI; pair::Union{Vector{String},String,Nothing}=nothing)
    params = Dict{String,Any}()
    !isnothing(pair) ? params["pair"] = vector_to_string(pair) : nothing
    return request(client, "GET", "/public/Ticker"; data=params, auth=false)
end

"""
    get_ohlc(client::SpotBaseRESTAPI; pair::String, interval::Union{String,Nothing}=nothing, since::Union{Int64,Nothing}=nothing)

Kraken Docs: [https://docs.kraken.com/rest/#operation/getOHLCData](https://docs.kraken.com/rest/#operation/getOHLCData)

Returns information about the open, high, low, close, vwap, and volume of a given `pair`.

Authenticated `client` not required

# Examples
```julia-repl
julia> client = SpotBaseRESTAPI()
julia> get_ohlc(client, pair="XBTUSD")
Dict{String, Any}(
    "XXBTZUSD" => Any[
        Any[1673301660, "17176.5", "17176.5", "17176.4", "17176.5", "17176.4", "0.00499447", 3],
        Any[1673301720, "17176.5", "17176.5", "17167.2", "17168.1", "17168.3", "3.57307618", 45],
        Any[1673301780, "17168.0", "17168.1", "17167.9", "17168.1", "17167.9", "0.10257254", 16],
        Any[1673301840, "17168.0", "17176.5", "17168.0", "17176.5", "17176.2", "1.06103454", 19],
        Any[1673301900, "17176.4", "17176.5", "17176.4", "17176.5", "17176.4", "0.20158908", 4],
        Any[1673301960, "17176.5", "17176.5", "17176.4", "17176.5", "17176.4", "0.04299818", 7],
        ...
    ]
)
```
"""
function get_ohlc(client::SpotBaseRESTAPI; pair::String, interval::Union{String,Nothing}=nothing, since::Union{Int64,Nothing}=nothing)
    params = Dict{String,String}("pair" => pair)
    !isnothing(interval) ? params["interval"] = interval : nothing
    !isnothing(since) ? params["since"] = since : nothing
    return request(client, "GET", "/public/OHLC"; data=params, auth=false)
end

"""
    get_order_book(client::SpotBaseRESTAPI; pair::String, count::Union{Int64,Nothing}=nothing)

Kraken Docs: [https://docs.kraken.com/rest/#operation/getOrderBook](https://docs.kraken.com/rest/#operation/getOrderBook)

Returns the current asks and bids (orderbook) of a given currency `pair`.

Authenticated `client` not required

# Examples
```julia-repl
julia> client = SpotBaseRESTAPI()
julia> get_order_book(client, pair="XBTUSD")
Dict{String, Any}(
    "XXBTZUSD" => Dict{String, Any}(
        "asks" => Any[
            Any["17249.60000", "0.750", 1673344930], Any["17249.80000", "0.038", 1673344927],
            Any["17249.90000", "0.067", 1673344930], Any["17250.10000", "0.001", 1673344930],
            Any["17250.50000", "4.348", 1673344903], Any["17251.10000", "0.053", 1673344928],
            Any["17251.30000", "1.157", 1673344928], Any["17251.50000", "0.807", 1673344930],
            Any["17252.40000", "0.369", 1673344921], Any["17252.60000", "0.250", 1673344857],
            ...
        ],
        "bids" => Any[
            Any["17249.50000", "0.001", 1673344924],
            Any["17249.40000", "0.001", 1673344916],
            Any["17249.30000", "0.001", 1673344930],
            Any["17249.20000", "0.001", 1673344927],
            Any["17249.10000", "0.001", 1673344930],
            ...
        ]
    )
)
```
"""
function get_order_book(client::SpotBaseRESTAPI; pair::String, count::Union{Int64,Nothing}=nothing)
    params = Dict{String,String}("pair" => pair)
    !isnothing(count) ? params["count"] = count : nothing
    return request(client, "GET", "/public/Depth"; data=params, auth=false)
end

"""
    get_recent_trades(client::SpotBaseRESTAPI; pair::String, since::Union{Int64,Nothing}=nothing)

Kraken Docs: [https://docs.kraken.com/rest/#operation/getRecentTrades](https://docs.kraken.com/rest/#operation/getRecentTrades)

Returns the recent trades of a given `symbol` (currency pair).

Authenticated `client` not required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI()
julia> println(get_recent_trades(client, pair="XBTUSD"))
Dict{String, Any}(
    "XXBTZUSD" => Any[
        Any["17265.50000", "0.00515323", 1.673362549987055e9, "b", "l", "", 54454372],
        Any["17265.50000", "0.01203124", 1.6733625510070226e9, "b", "l", "", 54454373],
        Any["17266.80000", "0.08087410", 1.673362551007105e9, "b", "l", "", 54454374],
        Any["17266.90000", "0.56059466", 1.6733625510071838e9, "b", "l", "", 54454375],
        Any["17267.00000", "0.00900000", 1.6733625512079215e9, "b", "l", "", 54454376],
        Any["17267.00000", "0.00610000", 1.6733625522878373e9, "b", "l", "", 54454377],
        Any["17267.00000", "0.00208447", 1.6733625534015026e9, "b", "l", "", 54454378],
        Any["17268.50000", "0.01211553", 1.6733625534015663e9, "b", "l", "", 54454379],
        Any["17268.50000", "0.00506894", 1.6733625536050434e9, "b", "l", "", 54454380],
        ...
    ],
    "last" => "1673363844906015910"
)
```
"""
function get_recent_trades(client::SpotBaseRESTAPI; pair::String, since::Union{Int64,Nothing}=nothing)
    params = Dict{String,String}("pair" => pair)
    !isnothing(since) ? params["since"] = since : nothing
    return request(client, "GET", "/public/Trades"; data=params, auth=false)
end

"""
    get_recent_spreads(client::SpotBaseRESTAPI; pair::String, since::Union{Int64,Nothing}=nothing)

Kraken Docs: [https://docs.kraken.com/rest/#operation/getRecentSpreads](https://docs.kraken.com/rest/#operation/getRecentSpreads)

Returns the recent spreads of a currency `pair` (symbol).

Authenticated `client` not required

# Examples
```julia-repl
julia> client = SpotBaseRESTAPI()
julia> println(get_recent_spreads(client, pair="XBTUSD"))
Dict{String, Any}(
    "XXBTZUSD" => Any[
        Any[1673363656, "17346.40000", "17348.20000"],
        Any[1673363657, "17346.40000", "17347.90000"],
        Any[1673363657, "17346.80000", "17347.90000"],
        Any[1673363660, "17346.80000", "17347.60000"],
        Any[1673363660, "17346.40000", "17347.60000"],
        Any[1673363660, "17346.50000", "17347.60000"],
        ...
    ],
    "last" => 1673363958)
```
"""
function get_recent_spreads(client::SpotBaseRESTAPI; pair::String, since::Union{Int64,Nothing}=nothing)
    params = Dict{String,String}("pair" => pair)
    !isnothing(since) ? params["since"] = since : nothing
    return request(client, "GET", "/public/Spread"; data=params, auth=false)
end

"""
    get_system_status(client::SpotBaseRESTAPI)

Returns the system status of the Kraken API

Authenticated `client` not required

# Examples
```julia-repl
julia> client = SpotBaseRESTAPI()
julia> println(get_system_status(client))
Dict{String, Any}("status" => "online", "timestamp" => "2023-01-10T15:20:20Z")
```
"""
function get_system_status(client::SpotBaseRESTAPI)
    return request(client, "GET", "/public/SystemStatus"; auth=false)
end
end