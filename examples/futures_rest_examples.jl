module futures_rest_exmaples

using DotEnv

include("../src/KrakenEx.jl")
using .KrakenEx: FuturesBaseRESTAPI

using .KrakenEx.FuturesMarketModule:
    get_ohlc,
    get_tick_types,
    get_tradeable_products,
    get_resolutions,
    get_fee_schedules,
    get_fee_schedules_vol,
    get_orderbook,
    get_tickers,
    get_instruments,
    get_instruments_status,
    get_trade_history,
    get_historical_funding_rates,
    get_leverage_preference,
    set_leverage_preference,
    get_pnl_preference,
    set_pnl_preference,
    get_execution_events,
    get_public_execution_events,
    get_public_order_events,
    get_public_mark_price_events,
    get_order_events,
    get_trigger_events

function market_endpoints(
    client::FuturesBaseRESTAPI,
    private_client::FuturesBaseRESTAPI
)
    # println(get_ohlc(client,
    #     tick_type="trade",
    #     symbol="PI_XBTUSD",
    #     resolution="1m",
    #     from=1668989233,
    #     to=1668999233
    # ))

    # println(get_tick_types(client))

    # println(get_tradeable_products(client, tick_type="mark")) # mark, spot, trade

    # println(get_resolutions(
    #     client, 
    #     tradeable="PI_XBTUSD", 
    #     tick_type="spot"
    # ))

    # println(get_fee_schedules(client))
    # println(get_fee_schedules_vol(private_client))

    # println(get_orderbook(client, symbol="PI_XBTUSD"))

    # println(get_tickers(client))

    # println(get_instruments(client))
    # println(get_instruments_status(client))
    # println(get_instruments_status(client, instrument="PI_XBTUSD"))

    # println(get_trade_history(client, symbol="PI_XBTUSD"))
    # println(get_trade_history(client, lastTime=string(1668989233)))

    # println(get_historical_funding_rates(client, symbol="PI_XBTUSD"))

    # todo: forbidden?
    # println(get_leverage_preference(private_client)) 
    # todo: forbidden?
    # println(set_leverage_preference(private_client, symbol="PI_XBTUSD", maxLeverage=1))

    # reset leverage setting
    # todo: forbidden?
    # println(set_leverage_preference(private_client, symbol="PI_XBTUSD"))

    # println(get_pnl_preference(private_client))
    # todo: Dict{String, Any}("error" => "nonceDuplicate: 1672858785696", "serverTime" => "2023-01-04T18:59:53.498Z", "result" => "error")
    # println(set_pnl_preference(private_client, symbol="PI_XBTUSD", pnlPreference="XBT"))

    # println(get_execution_events(private_client))
    # println(get_public_execution_events(client, tradeable="PI_XBTUSD"))
    # println(get_public_order_events(client, tradeable="PI_XBTUSD"))

    # println(get_public_mark_price_events(client, tradeable="PI_XBTUSD"))

    # println(get_order_events(private_client))    
    # println(get_order_events(private_client, tradeable="PI_XBTUSD", sort="asc", before="1668989233"))
    # println(get_trigger_events(private_client))
    # println(get_trigger_events(private_client, tradeable="PI_XBTUSD", sort="desc", before="1668989233"))

end

function main()
    #===== G E N E R A L =====#
    DotEnv.config(path=".env")

    client = FuturesBaseRESTAPI()
    private_client = FuturesBaseRESTAPI(
        ENV["FUTURES_API_KEY"],
        ENV["FUTURES_SECRET_KEY"]
    )
    market_endpoints(client, private_client)

end

main()

end