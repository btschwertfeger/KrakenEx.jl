using KrakenEx: SpotBaseRESTAPI, FuturesBaseRESTAPI
import KrakenEx.SpotMarketModule as SpotMarket
import KrakenEx.FuturesMarketModule as FuturesMarket
using Test

#=
 Tests can only be performed on public endpoints, because
 valid API keys are requred for private requests.
=#

@testset "KrakenEx Spot REST Market Endpoints" begin

    client = SpotBaseRESTAPI()

    @test typeof(SpotMarket.get_server_time(client)) == Int64

    @test typeof(SpotMarket.get_assets(client, assets="BTC", aclass="currency")) == Dict{String,Any}

    @test typeof(SpotMarket.get_assets(client, assets=["BTC", "DOT"], aclass="currency")) == Dict{String,Any}

    @test typeof(SpotMarket.get_tradable_asset_pair(client, pair=["XBTUSD"])) == Dict{String,Any}

    @test typeof(SpotMarket.get_ticker(client, pair="XBTUSD")) == Dict{String,Any}

    @test typeof(SpotMarket.get_ohlc(client, pair="XBTUSD")) == Dict{String,Any}

    @test typeof(SpotMarket.get_ohlc(client, pair="XBTUSD", interval=60, since=1675066107)) == Dict{String,Any}

    @test typeof(SpotMarket.get_order_book(client, pair="XBTUSD", count=4)) == Dict{String,Any}

    @test typeof(SpotMarket.get_recent_trades(client, pair="XBTUSD", since=1675066107)) == Dict{String,Any}

    @test typeof(SpotMarket.get_recent_spreads(client, pair="XBTUSD", since=1675066107)) == Dict{String,Any}

    @test typeof(SpotMarket.get_system_status(client)) == Dict{String,Any}

    # ...
end

@testset "KrakenEx Futures REST Market Endpoints" begin

    client = FuturesBaseRESTAPI()

    @test typeof(FuturesMarket.get_ohlc(client,
        tick_type="trade",
        symbol="PI_XBTUSD",
        resolution="1m",
        from=1668989233,
        to=1668999233
    )) == Dict{String,Any}

    @test typeof(FuturesMarket.get_tick_types(client)) == Vector{Any}

    @test typeof(FuturesMarket.get_tradeable_products(
        client,
        tick_type="mark"
    )) == Vector{Any}

    @test typeof(FuturesMarket.get_resolutions(
        client,
        tradeable="PI_XBTUSD",
        tick_type="spot"
    )) == Vector{Any}

    @test typeof(FuturesMarket.get_fee_schedules(client)) == Dict{String,Any}

    @test typeof(FuturesMarket.get_orderbook(client, symbol="PI_XBTUSD")) == Dict{String,Any}

    @test typeof(FuturesMarket.get_tickers(client)) == Dict{String,Any}

    @test typeof(FuturesMarket.get_instruments(client)) == Dict{String,Any}

    @test typeof(FuturesMarket.get_instruments_status(client)) == Dict{String,Any}

    @test typeof(FuturesMarket.get_trade_history(client, symbol="PI_XBTUSD", lastTime="2020-08-27T17:03:33.196Z")) == Dict{String,Any}

    @test typeof(FuturesMarket.get_public_execution_events(client, tradeable="PI_XBTUSD", before=1675176107, since=1675066107, sort="asc")) == Dict{String,Any}

    @test typeof(FuturesMarket.get_public_order_events(client, tradeable="PI_XBTUSD", before=1675176107, since=1675066107, sort="desc")) == Dict{String,Any}

    @test typeof(FuturesMarket.get_public_mark_price_events(client, tradeable="PI_XBTUSD", before=1675176107, since=1675066107, sort="desc")) == Dict{String,Any}
end