using KrakenEx: SpotBaseRESTAPI
import KrakenEx.SpotMarketModule as SpotMarket
using Test



client = SpotBaseRESTAPI()

@testset verbose = true "Asset information" begin
    @test typeof(SpotMarket.get_assets(client, assets="BTC", aclass="currency")) == Dict{String,Any}
    @test typeof(SpotMarket.get_assets(client, assets=["BTC", "DOT"], aclass="currency")) == Dict{String,Any}
    @test typeof(SpotMarket.get_tradable_asset_pair(client, pair=["XBTUSD"])) == Dict{String,Any}
end
sleep(1)

@testset verbose = true "Market data" begin
    @test typeof(SpotMarket.get_ticker(client, pair="XBTUSD")) == Dict{String,Any}
    @test typeof(SpotMarket.get_ohlc(client, pair="XBTUSD")) == Dict{String,Any}
    @test typeof(SpotMarket.get_ohlc(client, pair="XBTUSD", interval=60, since=1675066107)) == Dict{String,Any}
end
sleep(1)

@testset verbose = true "Public orderbook, trades and spreads" begin
    @test typeof(SpotMarket.get_order_book(client, pair="XBTUSD", count=4)) == Dict{String,Any}
    @test typeof(SpotMarket.get_recent_trades(client, pair="XBTUSD", since=1675066107)) == Dict{String,Any}
    @test typeof(SpotMarket.get_recent_spreads(client, pair="XBTUSD", since=1675066107)) == Dict{String,Any}
end
sleep(1)

@testset verbose = true "System status" begin
    @test typeof(SpotMarket.get_system_status(client)) == Dict{String,Any}
    @test typeof(SpotMarket.get_server_time(client)) == Int64
end
