using KrakenEx: FuturesBaseRESTAPI
import KrakenEx.FuturesTradeModule as FuturesTrade
using Test


client = FuturesBaseRESTAPI(key=ENV["FUTURES_SANDBOX_KEY"], secret=ENV["FUTURES_SANDBOX_SECRET"], DEMO=true)

@testset verbose = true "Retrieve information" begin
    @test typeof(FuturesTrade.get_fills(client)) == Dict{String,Any}
    # todo: fix authenticationerror when some strange character in string
    # @test typeof(FuturesTrade.get_fills(client, lastFillTime="2020-07-22T13:44:24.311Z"))==Dict{String,Any}
    @test typeof(FuturesTrade.get_orders_status(client, orderIds=["O2JLFP-VYFIW-35ZAAE", "O523KJ-DO4M2-KAT243"])) == Dict{String,Any}
end

@testset verbose = true "Create and modify orders" begin
    @test_throws exc.KrakenNotFoundError FuturesTrade.create_batch_order(client,
        batchorder_list=[
            Dict{String,Any}(
                "order" => "send",
                "order_tag" => "1",
                "orderType" => "lmt",
                "symbol" => "PI_XBTUSD",
                "side" => "buy",
                "size" => 0.00001,
                "limitPrice" => 1200.0,
                "cliOrdId" => "my-another-client-id",
                "validate" => string(true)
            ),
            Dict{String,Any}(
                "order" => "send",
                "order_tag" => "2",
                "orderType" => "stp",
                "symbol" => "PI_XBTUSD",
                "side" => "buy",
                "size" => 0.00001,
                "limitPrice" => 1100.0,
                "stopPrice" => 1090.0,
                "validate" => string(true)
            ),
            Dict{String,Any}(
                "order" => "send",
                "order_tag" => "3",
                "orderType" => "stp",
                "symbol" => "PI_XBTUSD",
                "side" => "buy",
                "size" => 0.0003,
                "limitPrice" => 1100.0,
                "stopPrice" => 1900.0,
                "validate" => string(true)
            ),
            Dict{String,Any}(
                "order" => "cancel",
                "order_id" => "f35a61dd-8a30-4d5f-a574-b5593ef0c050",
            ),
            Dict{String,Any}(
                "order" => "cancel",
                "cliOrdId" => "my_client_id1234"
            )
        ])
    @test typeof(FuturesTrade.edit_order(client, orderId="O523KJ-DO4M2-KAT243", size=2, limitPrice=10)) == Dict{String,Any}
    @test typeof(FuturesTrade.create_order(client, orderType="lmt",
        side="buy",
        size=0.0001,
        limitPrice=100.0,
        symbol="PI_XBTUSD",
    )) == Dict{String,Any}
end
sleep(5)

@testset verbose = true "Cancel orders" begin
    @test typeof(FuturesTrade.cancel_all_orders(client, symbol="PI_XBTUSD")) == Dict{String,Any}
    @test typeof(FuturesTrade.dead_mans_switch(client, timeout=0)) == Dict{String,Any}
    @test typeof(FuturesTrade.cancel_order(client, order_id="O523KJ-DO4M2-KAT243")) == Dict{String,Any}
end