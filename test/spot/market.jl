using KrakenEx: SpotBaseRESTAPI
import KrakenEx.SpotMarketModule as SpotMarket
using Test


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
end
