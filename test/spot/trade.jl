using KrakenEx: SpotBaseRESTAPI
import KrakenEx.SpotTradeModule as SpotTrade
import KrakenEx.ExceptionsModule as exc
using Test


client = SpotBaseRESTAPI(key=ENV["SPOT_API_KEY"], secret=ENV["SPOT_SECRET_KEY"])

@testset verbose = true "Create orders" begin
    @test_throws exc.KrakenPermissionDeniedError SpotTrade.create_order(
        client,
        ordertype="limit",
        price=12000,
        side="buy",
        volume=0.001,
        pair="XBTUSD",
        validate=true,
        userref=123456,
        oflags="fcib",
        timeinforce="GTC",
        displayvol=0.0001
    )
    @test_throws exc.KrakenPermissionDeniedError SpotTrade.create_order_batch(client,
        orders=[
            Dict{String,Any}(
                "close" => Dict{String,Any}(
                    "ordertype" => "stop-loss-limit",
                    "price" => 1000,
                    "price2" => 900
                ),
                "ordertype" => "limit",
                "price" => 40000,
                "timeinforce" => "GTC",
                "type" => "buy",
                "userref" => Int32(123),
                "volume" => 2
            ),
            Dict{String,Any}(
                "ordertype" => "limit",
                "price" => 42000,
                "starttm" => "1668455555",
                "timeinforce" => "GTC",
                "type" => "sell",
                "userref" => Int32(999),
                "volume" => 5
            ),
            Dict{String,Any}(
                "ordertype" => "market",
                "volume" => 2,
                "type" => "buy"
            ),
            Dict{String,Any}(
                "ordertype" => "limit",
                "price" => 43000,
                "starttm" => "1668455555",
                "timeinforce" => "GTC",
                "type" => "sell",
                "userref" => Int32(999),
                "volume" => 5
            )
        ],
        pair="XBTUSD",
        validate=true
    )
end
sleep(2)
@testset verbose = true "Modify orders" begin
    @test_throws exc.KrakenPermissionDeniedError SpotTrade.edit_order(client,
        txid="O2JLFP-VYFIW-35ZAAE",
        pair="XBTUSD",
        volume=4.2,
        price=17000
    )
end
sleep(2)
@testset verbose = true "Cancel orders" begin
    @test_throws exc.KrakenPermissionDeniedError SpotTrade.cancel_order(client, txid="O2JLFP-VYFIW-35ZAAE")
    @test_throws exc.KrakenPermissionDeniedError SpotTrade.cancel_all_orders(client)
    @test_throws exc.KrakenPermissionDeniedError SpotTrade.cancel_all_orders_after_x(client, timeout=60)
    @test_throws exc.KrakenPermissionDeniedError SpotTrade.cancel_order_batch(client, orders=["O2JLFP-VYFIW-35ZAAE", "O523KJ-DO4M2-KAT243"])
end
sleep(2)
