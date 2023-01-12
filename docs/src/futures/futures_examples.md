```@meta
   CurrentModule = KrakenEx
```

# Kraken Futures Examples

```@contents
Pages = ["futures_examples.md"]
```

## Futures REST Examples

```julia
using KrakenEx: FuturesBaseRESTAPI

using KrakenEx.FuturesMarketModule
using KrakenEx.FuturesUserModule
using KrakenEx.FuturesTradeModule
using KrakenEx.FuturesFundingModule

function main()
    key = "Kraken-public-key"
    secret = "Kraken-secret-key"

    # private clients can also access public endpoints
    private_client = FuturesBaseRESTAPI(
        API_KEY=key,
        SECRET_KEY=secret
    )

    sandbox_client = FuturesBaseRESTAPI(
        API_KEY=key,
        SECRET_KEY=secret,
        DEMO=true
    )

    #==== User Endpoints ====#
    println(get_wallets(private_client))
    println(get_open_orders(private_client))
    log = get_account_log_csv(client)
    open("myAccountLog.csv", "w") do io
        write(io, log)
    end
    # ...

    #==== Market Endpoints ====#
    println(get_ohlc(private_client,
        tick_type="trade",
        symbol="PI_XBTUSD",
        resolution="1m",
        from=1668989233,
        to=1668999233
    ))
    # ...

    #==== Trade Endpoints ====#
    println(create_order(private_client,
        orderType="lmt",
        side="buy",
        size=1,
        limitPrice=4,
        symbol="pf_bchusd",
    ))

    println(create_batch_order(client, batchorder_list=[
        Dict{String,Any}(
            "order" => "send",
            "order_tag" => "1",
            "orderType" => "lmt",
            "symbol" => "PI_XBTUSD",
            "side" => "buy",
            "size" => 1,
            "limitPrice" => 1.00,
            "cliOrdId" => "my-another-client-id"
        ),
        Dict{String,Any}(
            "order" => "send",
            "order_tag" => "2",
            "orderType" => "stp",
            "symbol" => "PI_XBTUSD",
            "side" => "buy",
            "size" => 1,
            "limitPrice" => 2.00,
            "stopPrice" => 3.00,
        ),
        Dict{String,Any}(
            "order" => "send",
            "order_tag" => "2",
            "orderType" => "stp",
            "symbol" => "PI_XBTUSD",
            "side" => "buy",
            "size" => 1,
            "limitPrice" => 2.00,
            "stopPrice" => 3.00,
        ),
        Dict{String,Any}(
            "order" => "cancel",
            "order_id" => "e35d61dd-8a30-4d5f-a574-b5593ef0c050",
        ),
        Dict{String,Any}(
            "order" => "cancel",
            "cliOrdId" => "my_client_id1234"
        )
    ]))

    println(cancel_all_orders(private_client))
    # ...

    #==== Funding Endpoints ====#
    println(get_historical_funding_rates(private_client, symbol="PI_XBTUSD"))
    # ...
end

main()
```

---

## Futures WebSocket Example

```julia
using KrakenEx
using KrakenEx.FuturesWebsocketModule:
    FuturesWebSocketClient,
    connect,
    subscribe, unsubscribe

function main()
    key = "Kraken-public-key"
    secret = "Kraken-secret-key"
    ws_client = FuturesWebSocketClient(key, secret)

    function on_message(msg::Union{Dict{String,Any},String})
        println(msg)
        # implement your strategy here....

        #=
            Dont forget that you can also access public rest endpoints here.
            If the `ws_client` instance is authenticated, you can also
            use private endpoints:

        KrakenEx.FuturesMarketModule.cancel_order(
            ws_client.rest_client,
            txid="XXXXXX-XXXXXX-XXXXXX"
        )
        =#
    end

    #=
       `connect` can establish a private and a public connection at the same time.
       You can turn off either the private or the public connection
       using `private=false` or `public=false`.
    =#
    con = @async connect(ws_client, callback=on_message, private=true)

    #== Subscribe to public and private websocket feeds ==#

    # public feeds
    products::Vector{String} = ["PI_XBTUSD", "PF_SOLUSD"]
    subscribe(client=ws_client, feed="ticker", products=products)
    # subscribe(client=ws_client, feed="ticker", products=products)
    # subscribe(client=ws_client, feed="book", products=products)
    # subscribe(client=ws_client, feed="trade", products=products)
    # subscribe(client=ws_client, feed="ticker_lite", products=products)
    # subscribe(client=ws_client, feed="heartbeat")
    # ...

    # private feeds
    subscribe(client=ws_client, feed="fills")
    # subscribe(client=ws_client, feed="open_positions")
    subscribe(client=ws_client, feed="open_orders")
    # subscribe(client=ws_client, feed="open_orders_verbose")
    # subscribe(client=ws_client, feed="deposits_withdrawals")
    # subscribe(client=ws_client, feed="account_balances_and_margins")
    # subscribe(client=ws_client, feed="balances")
    # subscribe(client=ws_client, feed="account_log")
    # subscribe(client=ws_client, feed="notifications_auth")
    # ...

    # wait before unsubscribe is done ...
    sleep(2)

    #== Unsubscribe from public and private websocket feeds ==#
    unsubscribe(client=ws_client, feed="ticker", products=["PF_SOLUSD"])
    # unsubscribe(client=ws_client, feed="ticker", products=["PF_XBTUSD"])
    # unsubscribe(client=ws_client, feed="fills")
    # unsubscribe(client=ws_client, feed="open_orders")
    # ...

    # to cancel a connection you can use:
    # ws_client.cancel_private_connection = true
    # ws_client.cancel_public_connection = true
    # ...

    wait(con)
end

main()
```
