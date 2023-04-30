using KrakenEx: FuturesBaseRESTAPI
import KrakenEx.FuturesMarketModule as FuturesMarket
using Test

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