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
export get_pnl_preference
export set_pnl_preference
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

https://docs.futures.kraken.com/#http-api-charts-ohlc-get-ohlc,
https://support.kraken.com/hc/en-us/articles/4403284627220-OHLC
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

https://docs.futures.kraken.com/#http-api-charts-ohlc-get-tick-types
"""
function get_tick_types(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/api/charts/v1/", auth=false)
end

"""
    get_tradeable_products(client::FuturesBaseRESTAPI; tick_type::String)

https://docs.futures.kraken.com/#http-api-charts-ohlc-get-tradeable-products
"""
function get_tradeable_products(client::FuturesBaseRESTAPI; tick_type::String)
    return request(client, "GET", "/api/charts/v1/$tick_type", auth=false)
end

"""
    get_resolutions(client::FuturesBaseRESTAPI; tick_type::String, tradeable::String)

https://docs.futures.kraken.com/#http-api-charts-ohlc-get-resolutions
"""
function get_resolutions(client::FuturesBaseRESTAPI; tick_type::String, tradeable::String)
    return request(client, "GET", "/api/charts/v1/$tick_type/$tradeable", auth=false)
end

"""
    get_fee_schedules(client::FuturesBaseRESTAPI)

https://docs.futures.kraken.com/#http-api-trading-v3-api-fee-schedules-get-fee-schedules
"""
function get_fee_schedules(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/feeschedules", auth=false)
end

"""
    get_fee_schedules_vol(client::FuturesBaseRESTAPI)

https://docs.futures.kraken.com/#http-api-trading-v3-api-fee-schedules-get-fee-schedule-volumes
"""
function get_fee_schedules_vol(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/feeschedules/volumes", auth=true)
end

"""
    get_orderbook(client::FuturesBaseRESTAPI; symbol::Union{String,Nothing}=nothing)

https://docs.futures.kraken.com/#http-api-trading-v3-api-market-data-get-orderbook,
https://support.kraken.com/hc/en-us/articles/360022839551-Order-Book
"""
function get_orderbook(client::FuturesBaseRESTAPI; symbol::Union{String})
    return request(client, "GET", "/derivatives/api/v3/orderbook", query_params=Dict{String,Any}(
            "symbol" => symbol
        ), auth=false)
end

"""
    get_tickers(client::FuturesBaseRESTAPI)

https://docs.futures.kraken.com/#http-api-trading-v3-api-market-data-get-tickers,
    https://support.kraken.com/hc/en-us/articles/360022839531-Tickers
"""
function get_tickers(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/tickers", auth=false)
end

"""
    get_instruments(client::FuturesBaseRESTAPI)

https://docs.futures.kraken.com/#http-api-trading-v3-api-instrument-details-get-instruments,
https://support.kraken.com/hc/en-us/articles/360022635672-Instruments
"""
function get_instruments(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/instruments", auth=false)
end

"""
    get_instruments_status(client::FuturesBaseRESTAPI; instrument::Union{String,Nothing}=nothing)

https://docs.futures.kraken.com/#http-api-trading-v3-api-instrument-details-get-instrument-status-list,
https://docs.futures.kraken.com/#http-api-trading-v3-api-instrument-details-get-instrument-status
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

https://docs.futures.kraken.com/#http-api-trading-v3-api-market-data-get-trade-history,
https://support.kraken.com/hc/en-us/articles/360022839511-History
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

https://docs.futures.kraken.com/#http-api-trading-v3-api-multi-collateral-get-the-leverage-setting-for-a-market
"""
function get_leverage_preference(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/leveragepreferences", auth=true)
end

"""
    set_leverage_preference(client::FuturesBaseRESTAPI; symbol::String, maxLeverage::Union{Float64,Nothing}=nothing)

https://docs.futures.kraken.com/#http-api-trading-v3-api-multi-collateral-set-the-leverage-setting-for-a-market
"""
function set_leverage_preference(client::FuturesBaseRESTAPI; symbol::String, maxLeverage::Union{Int,Float64,String,Nothing}=nothing)
    params::Dict{String,Any} = Dict{String,Any}("symbol" => symbol)
    isnothing(maxLeverage) ? nothing : params["maxLeverage"] = maxLeverage
    return request(client, "PUT", "/derivatives/api/v3/leveragepreferences", query_params=params, auth=true)
end

"""
    get_pnl_preference(client::FuturesBaseRESTAPI)

https://docs.futures.kraken.com/#http-api-trading-v3-api-multi-collateral-get-pnl-currency-preference-for-a-market
"""
function get_pnl_preference(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/pnlpreferences", auth=true)
end

"""
    set_pnl_preference(client::FuturesBaseRESTAPI; symbol::String, pnlPreference::String)

https://docs.futures.kraken.com/#http-api-trading-v3-api-multi-collateral-set-pnl-currency-preference-for-a-market
"""
function set_pnl_preference(client::FuturesBaseRESTAPI; symbol::String, pnlPreference::String)
    return request(client, "PUT", "/derivatives/api/v3/pnlpreferences", query_params=Dict{String,Any}(
            "symbol" => symbol,
            "pnlPreference" => pnlPreference
        ), auth=true)
end

"""
    _get_historical_events(client::FuturesBaseRESTAPI;
        endpoint::String,
        before::Union{Int,String,Nothing}=nothing,
        continuation_token::Union{String,Nothing}=nothing,
        since::Union{Int,String,Nothing}=nothing,
        sort::Union{String,Nothing}=nothing,
        tradeable::Union{String,Nothing}=nothing,
        auth::Bool=true
    )

"""
function _get_historical_events(client::FuturesBaseRESTAPI;
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
    get_execution_events(client::FuturesBaseRESTAPI;
        before::Union{Int,String,Nothing}=nothing,
        continuation_token::Union{String,Nothing}=nothing,
        since::Union{Int,String,Nothing}=nothing,
        sort::Union{String,Nothing}=nothing,
        tradeable::Union{String,Nothing}=nothing
    )

https://docs.futures.kraken.com/#http-api-history-market-history-get-execution-events
"""
function get_execution_events(client::FuturesBaseRESTAPI;
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
    get_public_execution_events(client::FuturesBaseRESTAPI;
        tradeable::String,
        before::Union{Int,String,Nothing}=nothing,
        continuation_token::Union{String,Nothing}=nothing,
        since::Union{Int,String,Nothing}=nothing,
        sort::Union{String,Nothing}=nothing
    )


https://docs.futures.kraken.com/#http-api-history-market-history-get-public-execution-events,
https://support.kraken.com/hc/en-us/articles/4401755685268-Market-History-Executions
"""
function get_public_execution_events(client::FuturesBaseRESTAPI;
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
    get_public_order_events(client::FuturesBaseRESTAPI;
        tradeable::String,
        before::Union{Int,String,Nothing}=nothing,
        continuation_token::Union{String,Nothing}=nothing,
        since::Union{Int,String,Nothing}=nothing,
        sort::Union{String,Nothing}=nothing
    )

https://docs.futures.kraken.com/#http-api-history-market-history-get-public-order-events,
https://support.kraken.com/hc/en-us/articles/4401755906452-Market-History-Orders
"""
function get_public_order_events(client::FuturesBaseRESTAPI;
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
    get_public_mark_price_events(client::FuturesBaseRESTAPI;
        tradeable::String,
        before::Union{Int,String,Nothing}=nothing,
        continuation_token::Union{String,Nothing}=nothing,
        since::Union{Int,String,Nothing}=nothing,
        sort::Union{String,Nothing}=nothing
    )

https://docs.futures.kraken.com/#http-api-history-market-history-get-public-mark-price-events,
https://support.kraken.com/hc/en-us/articles/4401748276116-Market-History-Mark-Price
"""
function get_public_mark_price_events(client::FuturesBaseRESTAPI;
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
    get_order_events(client::FuturesBaseRESTAPI;
        before::Union{Int,String,Nothing}=nothing,
        continuation_token::Union{String,Nothing}=nothing,
        since::Union{Int,String,Nothing}=nothing,
        sort::Union{String,Nothing}=nothing,
        tradeable::Union{String,Nothing}=nothing
    )

https://docs.futures.kraken.com/#http-api-history-market-history-get-order-events
"""
function get_order_events(client::FuturesBaseRESTAPI;
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
    get_trigger_events(client::FuturesBaseRESTAPI;
        before::Union{Int,String,Nothing}=nothing,
        continuation_token::Union{String,Nothing}=nothing,
        since::Union{Int,String,Nothing}=nothing,
        sort::Union{String,Nothing}=nothing,
        tradeable::Union{String,Nothing}=nothing
    )

https://docs.futures.kraken.com/#http-api-history-market-history-get-trigger-events
"""
function get_trigger_events(client::FuturesBaseRESTAPI;
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
