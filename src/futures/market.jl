"""
    FuturesMarketModule

Enables accessing Futures market endpoints using predefined methods.
"""
module FuturesMarketModule
using ..FuturesBaseAPIModule: FuturesBaseRESTAPI, request

#======= E X P O R T S ========#
export get_ohlc
export get_tick_types
export get_tradeable_products
export get_resolutions
export get_fee_schedules
export get_fee_schedules_vol
export get_orderbook
export get_tickers
export get_instruments
export get_instruments_status
export get_trade_history
export get_leverage_preference
export set_leverage_preference
export get_pnl_currency_preference
export set_pnl_currency_preference
export get_execution_events
export get_public_execution_events
export get_public_order_events
export get_public_mark_price_events
export get_order_events
export get_trigger_events

#======= F U N C T I O N S ========#
"""
    get_ohlc(client::FuturesBaseRESTAPI;
        tick_type::String,
        symbol::String,
        resolution::Int64,
        from::Union{Int64,Nothing}=nothing,
        to::Union{Int64,Nothing}=nothing
    )

Kraken Docs: [https://docs.futures.kraken.com/#http-api-charts-ohlc-get-ohlc](https://docs.futures.kraken.com/#http-api-charts-ohlc-get-ohlc),
[https://support.kraken.com/hc/en-us/articles/4403284627220-OHLC](https://support.kraken.com/hc/en-us/articles/4403284627220-OHLC)

Authenticated `client` not required

# Arguments
- `symbol::String`: asset of interest
- `tick_type::String`: must be one of ["spot", "mark", "trade"]
- `resolution::String`: must be one of ["1m", "5m", "15m", "30m", "1h", "4h", "12h", "1d", "1w"]
- `from::Union{Int64,Nothing}=nothing`: timestamp of ohlc begin
- `to::Union{Int64,Nothing}=nothing`: timestamp of ohlc end 

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI()
julia> println(get_ohlc(client,
...        tick_type="trade",
...        symbol="PI_XBTUSD",
...        resolution="1m",
...        from=1668989233,
...        to=1668999233
...    ))
Dict{String, Any}(
    "more_candles" => true, 
    "candles" => Any[
        Dict{String, Any}(
            "high" => "16152.50000000000", 
            "volume" => 7674, 
            "time" => 1668989280000, 
            "open" => "16100.00000000000", 
            "low" => "16100.00000000000", 
            "close" => "16144.50000000000"
        ), 
        Dict{String, Any}(
            "high" => "16159.00000000000", 
            "volume" => 483, "time" => 1668989340000, 
            "open" => "16144.50000000000", 
            "low" => "16144.50000000000", 
            "close" => "16144.50000000000"
        ), ...
    ]
)
```
"""
function get_ohlc(client::FuturesBaseRESTAPI;
    tick_type::String,
    symbol::String,
    resolution::String,
    from::Union{String,Int64,Nothing}=nothing,
    to::Union{String,Int64,Nothing}=nothing
)
    ttypes = ["spot", "mark", "trade"]
    if tick_type ∉ ttypes
        error("`tick_type` must be one of $ttypes")
    end

    resolutions = ["1m", "5m", "15m", "30m", "1h", "4h", "12h", "1d", "1w"]
    if resolution ∉ resolutions
        error("`resolution`must be one of $resolutions")
    end

    params = Dict{String,Any}()
    isnothing(from) ? nothing : params["from"] = from
    isnothing(to) ? nothing : params["to"] = to

    return request(client, "GET", "/api/charts/v1/$tick_type/$symbol/$resolution", query_params=params, auth=false)

end

"""
    get_tick_types(client::FuturesBaseRESTAPI)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-charts-ohlc-get-tick-types](https://docs.futures.kraken.com/#http-api-charts-ohlc-get-tick-types)

Returns the available tick types.

Authenticated `client` not required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI()
julia> println(get_tick_types(client))
Any["mark", "spot", "trade"]
```
"""
function get_tick_types(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/api/charts/v1/", auth=false)
end

"""
    get_tradeable_products(client::FuturesBaseRESTAPI; tick_type::String)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-charts-ohlc-get-tradeable-products](https://docs.futures.kraken.com/#http-api-charts-ohlc-get-tradeable-products)

Returns a list of available products for trading.

Authenticated `client` not required

# Attributes
- `tick_type::String`: must be one of ["spot", "mark", "trade"]

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI()
julia> println(get_tradeable_products(client, tick_type="mark"))
Any[
    "FI_ETHUSD_210924", "PF_LUNA2USD", "FI_LTCUSD_221230", "PF_UNIUSD",
    "FI_XBTUSD_230331", "FI_BCHUSD_211126", "PI_ETHUSD", "FI_ETHUSD_220527",
    ...
]
```
"""
function get_tradeable_products(client::FuturesBaseRESTAPI; tick_type::String)
    return request(client, "GET", "/api/charts/v1/$tick_type", auth=false)
end

"""
    get_resolutions(client::FuturesBaseRESTAPI; tick_type::String, tradeable::String)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-charts-ohlc-get-resolutions](https://docs.futures.kraken.com/#http-api-charts-ohlc-get-resolutions)

Returns the list of available resolutions.

Authenticated `client` not required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI()
julia>  println(get_resolutions(client, tradeable="PI_XBTUSD", tick_type="spot"))
Any["1d", "5m", "15m", "30m", "4h", "1m", "1h", "1w", "12h"]
```
"""
function get_resolutions(client::FuturesBaseRESTAPI; tick_type::String, tradeable::String)
    return request(client, "GET", "/api/charts/v1/$tick_type/$tradeable", auth=false)
end

"""
    get_fee_schedules(client::FuturesBaseRESTAPI)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-fee-schedules-get-fee-schedules](https://docs.futures.kraken.com/#http-api-trading-v3-api-fee-schedules-get-fee-schedules)

Returns the list of maker and taker fees per asset.

Authenticated `client` not required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI()
julia> println(get_fee_schedules(client))
Dict{String, Any}(
    "feeSchedules" => Any[
        Dict{String, Any}(
            "name" => "KF USD Multi-Collateral Fees", 
            "tiers" => Any[
                Dict{String, Any}(
                    "makerFee" => 0.02, 
                    "takerFee" => 0.05, 
                    "usdVolume" => 0.0
                ), 
                Dict{String, Any}(
                    "makerFee" => 0.015, 
                    "takerFee" => 0.04, 
                    "usdVolume" => 100000.0
                ), 
                Dict{String, Any}(
                    "makerFee" => 0.0125, 
                    "takerFee" => 0.03, 
                    "usdVolume" => 1.0e6
                ), ...
            ], 
            "uid" => "your-user-id"
        )
    ], 
    "serverTime" => "2023-01-10T17:59:20.057Z", 
    "result" => "success"
)
```
"""
function get_fee_schedules(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/feeschedules", auth=false)
end

"""
    get_fee_schedules_vol(client::FuturesBaseRESTAPI)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-fee-schedules-get-fee-schedule-volumes](https://docs.futures.kraken.com/#http-api-trading-v3-api-fee-schedules-get-fee-schedule-volumes)

Authenticated `client` required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> println(get_fee_schedules_vol(client))
Dict{String, Any}(
    "serverTime" => "2023-01-10T18:01:27.478Z", 
    "volumesByFeeSchedule" => Dict{String, Any}(
        "7fc4d7c0-464f-4029-a9bb-55856d0c5247" => 0,
        "d46c2190-81e3-4370-a333-424f24387829" => 0
    ), 
    "result" => "success"
)
```
"""
function get_fee_schedules_vol(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/feeschedules/volumes", auth=true)
end

"""
    get_orderbook(client::FuturesBaseRESTAPI; symbol::Union{String,Nothing}=nothing)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-market-data-get-orderbook](https://docs.futures.kraken.com/#http-api-trading-v3-api-market-data-get-orderbook),
[https://support.kraken.com/hc/en-us/articles/360022839551-Order-Book](https://support.kraken.com/hc/en-us/articles/360022839551-Order-Book)

Returns the current orderbook including asks and bids of given `symbol`.

Authenticated `client` not required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI()
julia> println(get_orderbook(client, symbol="PI_XBTUSD"))
Dict{String, Any}(
    "orderBook" => Dict{String, Any}(
        "asks" => Any[
            Any[17335.5, 328], Any[17339.5, 1721], Any[17340, 1770], 
            Any[17341.5, 2736], Any[17343, 10379], Any[17344, 3000], 
            Any[17344.5, 10366], Any[17346, 22052], Any[17346.5, 39912], 
            Any[17347.5, 19052], Any[17348.5, 6000], Any[17349, 19052], 
            ...
        ],
        "bids" => Any[
            ...
        ]
    ),
    "result": "success",
    "serverTime": "2020-08-27T17:03:33.196Z"
)
```
"""
function get_orderbook(client::FuturesBaseRESTAPI; symbol::Union{String})
    return request(client, "GET", "/derivatives/api/v3/orderbook", query_params=Dict{String,Any}(
            "symbol" => symbol
        ), auth=false)
end

"""
    get_tickers(client::FuturesBaseRESTAPI)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-market-data-get-tickers](https://docs.futures.kraken.com/#http-api-trading-v3-api-market-data-get-tickers),
[https://support.kraken.com/hc/en-us/articles/360022839531-Tickers](https://support.kraken.com/hc/en-us/articles/360022839531-Tickers)

Returns the available ticker for all available Futures symbols.
    
Authenticated `client` not required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI()
julia> println(get_tickers(client))
Dict{String, Any}(
    "serverTime" => "2023-01-10T18:04:18.210Z", 
    "tickers" => Any[
        Dict{String, Any}(
            "fundingRate" => 3.6841376588881e-5, 
            "lastSize" => 2.6, "bid" => 35.48, 
            "fundingRatePrediction" => -0.000541681480000012, 
            "lastTime" => "2023-01-10T11:42:04.518Z", 
            "pair" => "COMP:USD", 
            "bidSize" => 14, 
            "volumeQuote" => 331.9023, 
            "last" => 35.419, 
            "suspended" => false, 
            "askSize" => 17, 
            "postOnly" => false, 
            "symbol" => "pf_compusd", 
            "openInterest" => 617.5, 
            "markPrice" => 35.527, 
            "ask" => 35.575, 
            "tag" => "perpetual", 
            "vol24h" => 9.3, 
            "open24h" => 36, 
            "indexPrice" => 35.524
        ), Dict{String, Any}(
            "lastSize" => 250, 
            "bid" => 80.27, 
            "lastTime" => "2023-01-10T18:03:31.516Z", 
            "pair" => "LTC:USD", 
            ...
        ), ...
    ]
)
```
"""
function get_tickers(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/tickers", auth=false)
end

"""
    get_instruments(client::FuturesBaseRESTAPI)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-instrument-details-get-instruments](https://docs.futures.kraken.com/#http-api-trading-v3-api-instrument-details-get-instruments),
[https://support.kraken.com/hc/en-us/articles/360022635672-Instruments](https://support.kraken.com/hc/en-us/articles/360022635672-Instruments)

Lists available instruments (tradeable products) and additional information.

Authenticated `client` not required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI()
julia> println(get_instruments(client))
Dict{String,Any}(
    "result" => "success",
    "instruments" => Any[Dict{String,Any}(
        "symbol" => "pi_xbtusd",
        "type" => "futures_inverse",
        "underlying" => "rr_xbtusd",
        "tickSize" => 0.5,
        "contractSize" => 1,
        "tradeable" => true,
        "minimumTradeSize" => 1,
        "impactMidSize" => 1,
        "maxPositionSize" => 1000000,
        "openingDate" => "2022-01-01T00:00:00.000Z",
        "marginLevels" => Any[
            Dict{String,Any}("contracts" => 0, "initialMargin" => 0.02, "maintenanceMargin" => 0.01),
            Dict{String,Any}("contracts" => 500000, "initialMargin" => 0.04, "maintenanceMargin" => 0.02)
            ...
        ]
        "fundingRateCoefficient" => 8,
        "maxRelativeFundingRate" => 0.001,
        "isin" => "GB00J62YGL67",
        "contractValueTradePrecision" => 0,
        "postOnly" => false,
        "retailMarginLevels" => Any[
            Dict{String,Any}("contracts" => 0, "initialMargin" => 0.5, "maintenanceMargin" => 0.25)
        ],
        "category" => "",
        "tags" => []
    ), ...]
)
```
"""
function get_instruments(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/instruments", auth=false)
end

"""
    get_instruments_status(client::FuturesBaseRESTAPI; instrument::Union{String,Nothing}=nothing)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-instrument-details-get-instrument-status-list](https://docs.futures.kraken.com/#http-api-trading-v3-api-instrument-details-get-instrument-status-list), 
[https://docs.futures.kraken.com/#http-api-trading-v3-api-instrument-details-get-instrument-status](https://docs.futures.kraken.com/#http-api-trading-v3-api-instrument-details-get-instrument-status)

Returns the status of given `instrument`.

Authenticated `client` not required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI()
julia> println(get_instruments_status(client, instrument="PI_XBTUSD"))
Dict{String, Any}(
    "tradeable" => "PI_XBTUSD", 
    "experiencingDislocation" => false, 
    "extremeVolatilityInitialMarginMultiplier" => 1, 
    "priceDislocationDirection" => nothing, 
    "serverTime" => "2023-01-10T18:08:20.613Z", 
    "experiencingExtremeVolatility" => false, 
    "result" => "success"
)
```
"""
function get_instruments_status(client::FuturesBaseRESTAPI; instrument::Union{String,Nothing}=nothing)
    isnothing(instrument) ? url = "/derivatives/api/v3/instruments/status" : url = "/derivatives/api/v3/instruments/$instrument/status"
    return request(client, "GET", url, auth=false)
end

"""
    get_trade_history(client::FuturesBaseRESTAPI;
        symbol::Union{String,Nothing}=nothing,
        lastTime::Union{String,Nothing}=nothing
    )

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-market-data-get-trade-history](https://docs.futures.kraken.com/#http-api-trading-v3-api-market-data-get-trade-history),
[https://support.kraken.com/hc/en-us/articles/360022839511-History](https://support.kraken.com/hc/en-us/articles/360022839511-History)

Lists historical trades of this user.

Authenticated `client` not required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> println(get_trade_history(client, symbol="PI_XBTUSD"))
Dict{String, Any}(
    "history" => Any[
        Dict{String, Any}(
            "price" => 17308.5, 
            "time" => "2023-01-10T16:58:58.667Z", 
            "side" => "sell", 
            "uid" => "15e8ea9f-6ccf-4545-b29f-18b9e8f93949", 
            "size" => 1730, 
            "type" => "fill", 
            "trade_id" => 100
        ), Dict{String, Any}(
            "price" => 17289.5, 
            "time" => "2023-01-10T17:01:13.391Z", 
            "side" => "buy", 
            "uid" => "1475a325-0d14-46bd-9fb7-0deab5746e1c", 
            "size" => 4524, 
            "type" => "fill", 
            "trade_id" => 99
        ), ...
    ],
    "result": "success",
    "serverTime": "2022-08-27T17:03:33.196Z"
)
```
"""
function get_trade_history(client::FuturesBaseRESTAPI;
    symbol::Union{String,Nothing}=nothing,
    lastTime::Union{String,Nothing}=nothing
)
    params::Dict{String,Any} = Dict{String,Any}()
    isnothing(symbol) ? nothing : params["symbol"] = symbol
    isnothing(lastTime) ? nothing : params["lastTime"] = lastTime

    if length(params) == 0
        error("`get_trade_history`: Either symbol or lastTime must be specified!")
    end
    return request(client, "GET", "/derivatives/api/v3/history", query_params=params, auth=false)
end

"""
    get_leverage_preference(client::FuturesBaseRESTAPI)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-multi-collateral-get-the-leverage-setting-for-a-market](https://docs.futures.kraken.com/#http-api-trading-v3-api-multi-collateral-get-the-leverage-setting-for-a-market)

Shows the user-specific leverage preference.

Authenticated `client` required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> println(get_leverage_preference(client))
Dict{String,Any}(
    "result" => "success",
    "serverTime": "2022-06-28T15:01:12.762Z",
    "leveragePreferences": Any[Dict{String,Any}(
        "symbol" => "PF_XBTUSD",
        "maxLeverage" => 10.0
    )]
)
```
"""
function get_leverage_preference(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/leveragepreferences", auth=true)
end

"""
    set_leverage_preference(client::FuturesBaseRESTAPI; symbol::String, maxLeverage::Union{Float64,Nothing}=nothing)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-multi-collateral-set-the-leverage-setting-for-a-market](https://docs.futures.kraken.com/#http-api-trading-v3-api-multi-collateral-set-the-leverage-setting-for-a-market)

Enables setting the leverage preference.

Authenticated `client` required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> println(set_leverage_preference(client, symbol="PI_XBTUSD", maxLeverage=1))
Dict{String,Any}(
    "result" => "success",
    "serverTime" => "2022-06-28T14:48:58.711Z"
)
```
"""
function set_leverage_preference(client::FuturesBaseRESTAPI; symbol::String, maxLeverage::Union{Int,Float64,String,Nothing}=nothing)
    params::Dict{String,Any} = Dict{String,Any}("symbol" => symbol)
    isnothing(maxLeverage) ? nothing : params["maxLeverage"] = maxLeverage
    return request(client, "PUT", "/derivatives/api/v3/leveragepreferences", query_params=params, auth=true)
end

"""
    get_pnl_preference(client::FuturesBaseRESTAPI)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-multi-collateral-get-pnl-currency-preference-for-a-market](https://docs.futures.kraken.com/#http-api-trading-v3-api-multi-collateral-get-pnl-currency-preference-for-a-market)

Returns the current asset-specific pnl preference.

Authenticated `client` required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> println(get_pnl_currency_preference(client))
Dict{String,Any{(
    "result" => "success",
    "serverTime" => "2022-06-28T15:04:06.710Z",
    "preferences" => Any[Dict{String,Any}(
        "symbol" => "PF_XBTUSD",
        "pnlCurrency" => "BTC"
    )]
)
```
"""
function get_pnl_currency_preference(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/pnlpreferences", auth=true)
end

"""
    set_pnl_currency_preference(client::FuturesBaseRESTAPI; symbol::String, pnlPreference::String)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-multi-collateral-set-pnl-currency-preference-for-a-market](https://docs.futures.kraken.com/#http-api-trading-v3-api-multi-collateral-set-pnl-currency-preference-for-a-market)

Enables editing the current asset-specific pnl preference.

Authenticated `client` required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> println(set_pnl_currency_preference(client, symbol="PI_XBTUSD", pnlPreference="XBT"))
Dict{String,Any}(
    "result" => "success",
    "serverTime" => "2022-06-28T14:48:58.711Z"
)
```
"""
function set_pnl_currency_preference(client::FuturesBaseRESTAPI; symbol::String, pnlPreference::String)
    return request(client, "PUT", "/derivatives/api/v3/pnlpreferences", query_params=Dict{String,Any}(
            "symbol" => symbol,
            "pnlPreference" => pnlPreference
        ), auth=true)
end

"""
    _get_historical_events(
        client::FuturesBaseRESTAPI;
        endpoint::String,
        before::Union{Int,String,Nothing}=nothing,
        continuation_token::Union{String,Nothing}=nothing,
        since::Union{Int,String,Nothing}=nothing,
        sort::Union{String,Nothing}=nothing,
        tradeable::Union{String,Nothing}=nothing,
        auth::Bool=true
    )

"""
function _get_historical_events(
    client::FuturesBaseRESTAPI;
    endpoint::String,
    before::Union{Int,String,Nothing}=nothing,
    continuation_token::Union{String,Nothing}=nothing,
    since::Union{Int,String,Nothing}=nothing,
    sort::Union{String,Nothing}=nothing,
    tradeable::Union{String,Nothing}=nothing,
    auth::Bool=true
)
    params::Dict{String,Any} = Dict{String,Any}()
    isnothing(before) ? nothing : params["before"] = before
    isnothing(continuation_token) ? nothing : params["continuation_token"] = continuation_token
    isnothing(since) ? nothing : params["since"] = since
    isnothing(sort) ? nothing : params["sort"] = sort
    isnothing(tradeable) ? nothing : params["tradeable"] = tradeable

    return request(client, "GET", endpoint, query_params=params, auth=auth)
end

"""
    get_execution_events(
        client::FuturesBaseRESTAPI;
        before::Union{Int,String,Nothing}=nothing,
        continuation_token::Union{String,Nothing}=nothing,
        since::Union{Int,String,Nothing}=nothing,
        sort::Union{String,Nothing}=nothing,
        tradeable::Union{String,Nothing}=nothing
    )

Kraken Docs: [https://docs.futures.kraken.com/#http-api-history-market-history-get-execution-events](https://docs.futures.kraken.com/#http-api-history-market-history-get-execution-events)



Authenticated `client` required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> println(get_execution_events(client))
Dict{String, Any}(
    "accountUid" => "12f9bd01-d65c-4f83-9a3e-bb9464f88a35", 
    "elements" => Any[], "len" => 0
)
```
"""
function get_execution_events(
    client::FuturesBaseRESTAPI;
    before::Union{Int,String,Nothing}=nothing,
    continuation_token::Union{String,Nothing}=nothing,
    since::Union{Int,String,Nothing}=nothing,
    sort::Union{String,Nothing}=nothing,
    tradeable::Union{String,Nothing}=nothing
)
    return _get_historical_events(
        client,
        endpoint="/api/history/v2/executions",
        before=before,
        continuation_token=continuation_token,
        since=since,
        sort=sort,
        tradeable=tradeable,
        auth=true
    )
end

"""
    get_public_execution_events(
        client::FuturesBaseRESTAPI;
        tradeable::String,
        before::Union{Int,String,Nothing}=nothing,
        continuation_token::Union{String,Nothing}=nothing,
        since::Union{Int,String,Nothing}=nothing,
        sort::Union{String,Nothing}=nothing
    )

Kraken Docs: [https://docs.futures.kraken.com/#http-api-history-market-history-get-public-execution-events](https://docs.futures.kraken.com/#http-api-history-market-history-get-public-execution-events),
[https://support.kraken.com/hc/en-us/articles/4401755685268-Market-History-Executions](https://support.kraken.com/hc/en-us/articles/4401755685268-Market-History-Executions)

Authenticated `client` not required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI()
julia> println(get_public_execution_events(client, tradeable="PI_XBTUSD"))
Dict{String, Any}(
    "continuationToken" => "MTY3MzM0NDAyMzMyNy83ODc0OTY5NjI4NQ==", 
    "elements" => Any[Dict{String, Any}(
        "event" => Dict{String, Any}(
            "Execution" => Dict{String, Any}(
                "execution" => Dict{String, Any}(
                    "takerOrder" => Dict{String, Any}(
                        "tradeable" => "PI_XBTUSD", 
                        "orderType" => "IoC", 
                        "reduceOnly" => false, 
                        "uid" => "b77f469e-7548-4ab5-a921-98bab50dbbb7", 
                        "lastUpdateTimestamp" => 1673374561273, 
                        "direction" => "Buy", 
                        "timestamp" => 1673374561273, 
                        "quantity" => "8999.00000000", 
                        "limitPrice" => "17352.50000000"
                    ), 
                    "markPrice" => "17338.91438972669", 
                    "price" => "17352.5", 
                    "limitFilled" => false, 
                    "uid" => "dd6b4ad4-a985-4428-8689-11e7f7fe5d4c", 
                    "makerOrder" => Dict{String, Any}(
                        "tradeable" => "PI_XBTUSD", 
                        "orderType" => "Post", 
                        "reduceOnly" => false, 
                        "uid" => "82e8ff43-4dc7-4670-8f46-6a523c077ba8", 
                        "lastUpdateTimestamp" => 1673374561257, 
                        "direction" => "Sell", 
                        "timestamp" => 1673374559677, 
                        "quantity" => "27907.00000000", 
                        "limitPrice" => "17352.5"
                    ), 
                    "timestamp" => 1673374561273, 
                    "usdValue" => "8999.00", 
                    "quantity" => "8999.00000000"
                ), 
                "takerReducedQuantity" => ""
            )
        ),
        "uid" => "63b6a497-b554-4af5-81bd-787f7e2bf1c7", 
        "timestamp" => 1673374561273
    ), ...]
)
```
"""
function get_public_execution_events(
    client::FuturesBaseRESTAPI;
    tradeable::String,
    before::Union{Int,String,Nothing}=nothing,
    continuation_token::Union{String,Nothing}=nothing,
    since::Union{Int,String,Nothing}=nothing,
    sort::Union{String,Nothing}=nothing
)
    return _get_historical_events(
        client,
        endpoint="/api/history/v2/market/$tradeable/executions",
        before=before,
        continuation_token=continuation_token,
        since=since,
        sort=sort,
        auth=false
    )
end

"""
    get_public_order_events(
        client::FuturesBaseRESTAPI;
        tradeable::String,
        before::Union{Int,String,Nothing}=nothing,
        continuation_token::Union{String,Nothing}=nothing,
        since::Union{Int,String,Nothing}=nothing,
        sort::Union{String,Nothing}=nothing
    )

Kraken Docs: [https://docs.futures.kraken.com/#http-api-history-market-history-get-public-order-events](https://docs.futures.kraken.com/#http-api-history-market-history-get-public-order-events),
[https://support.kraken.com/hc/en-us/articles/4401755906452-Market-History-Orders](https://support.kraken.com/hc/en-us/articles/4401755906452-Market-History-Orders)

Authenticated `client` not required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI()
julia> println(get_public_order_events(client, tradeable="PI_XBTUSD"))
Dict{String, Any}(
    "continuationToken" => "MTY3MzM3NDczMjg2MC83ODc4OTc0NDU2OA==", 
    "elements" => Any[
        Dict{String, Any}(
            event" => Dict{String, Any}(
                "OrderPlaced" => Dict{String, Any}(
                    "reducedQuantity" => "", 
                    "order" => Dict{String, Any}(
                        "tradeable" => "PI_XBTUSD", 
                        "orderType" => "Post",
                        "reduceOnly" => false, 
                        "uid" => "68fb6c2e-5f85-44b9-a6f2-aae9ac6cd0c5", 
                        "lastUpdateTimestamp" => 1673374745391, 
                        "direction" => "Buy", 
                        "timestamp" => 1673374745391,
                        "quantity" => "118", 
                        "limitPrice" => "17167.0"
                    ), 
                    "reason" => "new_user_order"
                )
            ), 
            "uid" => "58733df7-f573-4ddd-96c5-bf4978b6568d", 
            "timestamp" => 1673374745391
        ), Dict{String, Any}(
            "event" => Dict{String, Any}(
                "OrderUpdated" => Dict{String, Any}(
                    "reducedQuantity" => "0", 
                    "oldOrder" => Dict{String, Any}(
                        "tradeable" => "PI_XBTUSD", 
                        "orderType" => "Post", 
                        "reduceOnly" => false, 
                        "uid" => "54de25df-f2e4-49d1-8281-c6a867fa2e8e", 
                        "lastUpdateTimestamp" => 1673374745228, 
                        "direction" => "Sell", 
                        "timestamp" => 1673352860129, 
                        "quantity" => "300000", 
                        "limitPrice" => "17381.0"
                    ), 
                    "newOrder" => Dict{String, Any}(
                        "tradeable" => "PI_XBTUSD", 
                        "orderType" => "Post", 
                        "reduceOnly" => false, 
                        "uid" => "54de25df-f2e4-49d1-8281-c6a867fa2e8e", 
                        "lastUpdateTimestamp" => 1673374745384, 
                        "direction" => "Sell", 
                        "timestamp" => 1673352860129, 
                        "quantity" => "300000", 
                        "limitPrice" => "17383.0"
                    ), 
                    "reason" => "edited_by user"
                )
            ), 
            "uid" => "f741b4a5-44d6-45a7-b287-77eba4a167b7", 
            "timestamp" => 1673374745384
        ), ...
    ]
)    
```
"""
function get_public_order_events(
    client::FuturesBaseRESTAPI;
    tradeable::String,
    before::Union{Int,String,Nothing}=nothing,
    continuation_token::Union{String,Nothing}=nothing,
    since::Union{Int,String,Nothing}=nothing,
    sort::Union{String,Nothing}=nothing
)
    return _get_historical_events(
        client,
        endpoint="/api/history/v2/market/$tradeable/orders",
        before=before,
        continuation_token=continuation_token,
        since=since,
        sort=sort,
        auth=false
    )
end

"""
    get_public_mark_price_events(
        client::FuturesBaseRESTAPI;
        tradeable::String,
        before::Union{Int,String,Nothing}=nothing,
        continuation_token::Union{String,Nothing}=nothing,
        since::Union{Int,String,Nothing}=nothing,
        sort::Union{String,Nothing}=nothing
    )

Kraken Docs: [https://docs.futures.kraken.com/#http-api-history-market-history-get-public-mark-price-events](https://docs.futures.kraken.com/#http-api-history-market-history-get-public-mark-price-events),
[https://support.kraken.com/hc/en-us/articles/4401748276116-Market-History-Mark-Price](https://support.kraken.com/hc/en-us/articles/4401748276116-Market-History-Mark-Price)

Authenticated `client` not required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI()
julia> println(get_public_mark_price_events(client, tradeable="PI_XBTUSD"))
Dict{String, Any}(
    "continuationToken" => "MTY3MzM3NDg4NjM4MC83ODc4OTkxMDM4Nw==", 
    "elements" => Any[Dict{String, Any}(
        "event" => Dict{String, Any}(
            "OrderUpdated" => Dict{String, Any}(
                "reducedQuantity" => "0", 
                "oldOrder" => Dict{String, Any}(
                    "tradeable" => "PI_XBTUSD", 
                    "orderType" => "Post", 
                    "reduceOnly" => false, 
                    "uid" => "28e2dc51-e473-4621-ad30-88d289e2258e", 
                    "lastUpdateTimestamp" => 1673374894474, 
                    "direction" => "Sell", 
                    "timestamp" => 1673354694830, 
                    "quantity" => "6000", 
                    "limitPrice" => "17384.0"
                ), 
                "newOrder" => Dict{String, Any}(
                    "tradeable" => "PI_XBTUSD", 
                    "orderType" => "Post", 
                    "reduceOnly" => false,
                    "uid" => "28e2dc51-e473-4621-ad30-88d289e2258e", 
                    "lastUpdateTimestamp" => 1673374894696, 
                    "direction" => "Sell", 
                    "timestamp" => 1673354694830, 
                    "quantity" => "6000", 
                    "limitPrice" => "17376.0"
                ), "reason" => "edited_by user"
            )
        ), 
        "uid" => "fc6fd47a-303b-45fc-a187-d6345b664560", 
        "timestamp" => 1673374894696
    ), ...]
)
```
"""
function get_public_mark_price_events(
    client::FuturesBaseRESTAPI;
    tradeable::String,
    before::Union{Int,String,Nothing}=nothing,
    continuation_token::Union{String,Nothing}=nothing,
    since::Union{Int,String,Nothing}=nothing,
    sort::Union{String,Nothing}=nothing
)
    return _get_historical_events(
        client,
        endpoint="/api/history/v2/market/$tradeable/orders",
        before=before,
        continuation_token=continuation_token,
        since=since,
        sort=sort,
        auth=false
    )
end

"""
    get_order_events(
        client::FuturesBaseRESTAPI;
        before::Union{Int,String,Nothing}=nothing,
        continuation_token::Union{String,Nothing}=nothing,
        since::Union{Int,String,Nothing}=nothing,
        sort::Union{String,Nothing}=nothing,
        tradeable::Union{String,Nothing}=nothing
    )

Kraken Docs: [https://docs.futures.kraken.com/#http-api-history-market-history-get-order-events](https://docs.futures.kraken.com/#http-api-history-market-history-get-order-events)

Authenticated `client` required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> println(get_order_events(
...        client, 
...        tradeable="PI_XBTUSD", 
...        sort="asc", 
...        before="1668989233"
...    ))
Dict{String, Any}(
    "accountUid" => "72f9bd80-d65c-4f73-9a3e-cb9464e88c35", 
    "elements" => Any[
        Dict{String, Any}(
            "event" => Dict{String, Any}(
                "OrderRejected" => Dict{String, Any}(
                    "algoId" => "", 
                    "order" => Dict{String, Any}(
                        "tradeable" => "PI_XBTUSD", 
                        "lastUpdateTimestamp" => 1669116246449, 
                        "filled" => "0", 
                        "clientId" => "my_another_client_id", 
                        "quantity" => "1", 
                        "reduceOnly" => false, 
                        "uid" => "d124183a-8c25-421b-8c75-450fb0b0efd3", 
                        "direction" => "Buy", 
                        "orderType" => "Limit", 
                        "accountUid" => "72f9bd80-d65c-4f73-9a3e-cb9464e88c35", 
                        "timestamp" => 1669116246449, 
                        "limitPrice" => "1.0"
                    ), 
                    "reason" => "new_user_order", 
                    "orderError" => "insufficient_margin"
                )
            ), 
            "uid" => "69a24b12-3a5b-470c-bac8-c65600b595d0", 
            "timestamp" => 1669116246449
        )
    ], 
    "len" => 1
)
```
"""
function get_order_events(
    client::FuturesBaseRESTAPI;
    before::Union{Int,String,Nothing}=nothing,
    continuation_token::Union{String,Nothing}=nothing,
    since::Union{Int,Nothing}=nothing,
    sort::Union{String,Nothing}=nothing,
    tradeable::Union{String,Nothing}=nothing
)
    return _get_historical_events(
        client,
        endpoint="/api/history/v2/orders",
        before=before,
        continuation_token=continuation_token,
        since=since,
        sort=sort,
        tradeable=tradeable,
        auth=true
    )
end

"""
    get_trigger_events(
        client::FuturesBaseRESTAPI;
        before::Union{Int,String,Nothing}=nothing,
        continuation_token::Union{String,Nothing}=nothing,
        since::Union{Int,String,Nothing}=nothing,
        sort::Union{String,Nothing}=nothing,
        tradeable::Union{String,Nothing}=nothing
    )

Kraken Docs: [https://docs.futures.kraken.com/#http-api-history-market-history-get-trigger-events](https://docs.futures.kraken.com/#http-api-history-market-history-get-trigger-events)

Authenticated `client` required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> println(get_trigger_events(
...        client, 
...        tradeable="PI_XBTUSD", 
...        sort="desc", 
...        before="1668989233"
...    ))
Dict{String, Any}(
    "accountUid" => "12f2b283-af1a-a173-aaae-ce9a64e122abc1", 
    "elements" => Any[], 
    "len" => 0
)
```
"""
function get_trigger_events(
    client::FuturesBaseRESTAPI;
    before::Union{Int,String,Nothing}=nothing,
    continuation_token::Union{String,Nothing}=nothing,
    since::Union{Int,String,Nothing}=nothing,
    sort::Union{String,Nothing}=nothing,
    tradeable::Union{String,Nothing}=nothing
)
    return _get_historical_events(
        client,
        endpoint="/api/history/v2/triggers",
        before=before,
        continuation_token=continuation_token,
        since=since,
        sort=sort,
        tradeable=tradeable,
        auth=true
    )
end

end
