```@meta
   CurrentModule = KrakenEx
```

# Kraken Spot Examples

```@contents
Pages = ["spot_examples.md"]
```

## Spot REST Examples

```julia
using KrakenEx: SpotBaseRESTAPI

using KrakenEx.SpotMarketModule
using KrakenEx.SpotUserModule
using KrakenEx.SpotTradeModule
using KrakenEx.SpotFundingModule
using KrakenEx.SpotStakingModule
#= you can also import specific functions
e.g.:
using KrakenEx.SpotMarketModule: get_ohlc, get_assets
=#

function main()
    # public client
    client = SpotBaseRESTAPI()

    # authenticated client
    private_client = SpotBaseRESTAPI(
        key="Kraken-public-key",
        secret="Kraken-secret-key"
    )

    #===== User Endpoints =====#
    println(get_account_balance(private_client))
    println(get_open_orders(private_client))
    # ...

    #===== Market Endpoints =====#
    println(get_assets(client))
    println(get_tradable_asset_pair(client, pair=["XBTUSD", "DOTUSD"]))
    println(get_ticker(client, pair="DOTUSD"))
    # ...

    #===== Trade Endpoints =====#
    println(
        create_order(
            private_client,
            ordertype="limit",
            side="buy",
            volume=1,
            pair="XBTUSD",
            price="10",
            oflags="post",
            validate=true
        )
    )
    # ...

    #===== Funding Endpoints =====#
    println(get_deposit_methods(private_client, asset="DOT"))
    println(get_deposit_address(private_client, asset="DOT", method="Polkadot"))
    # ...

    #===== Staking Endpoints =====#
    println(list_stakeable_assets(private_client))
    println(stake_asset(
        private_client, asset="DOT", amount=20000, method="polkadot-staked"
    ))
    # ...
end

main()
```

---

## Spot WebSocket Example

```julia

using KrakenEx
using KrakenEx.SpotWebSocketModule:
    SpotWebSocketClient,
    connect,
    subscribe, unsubscribe

function main()
    key = "Kraken-public-key"
    secret = "Kraken-secret-key"

    ws_client = SpotWebSocketClient(key, secret)

    function on_message(msg::Union{Dict{String,Any},String})
        println(msg)
        # implement your strategy here....

        #=
            Dont forget that you can also access public rest endpoints here.
            If the `ws_client` instance is authenticated, you can also
            use private endpoints:

        KrakenEx.SpotMarketModule.cancel_order(
            ws_client.rest_client,
            txid="XXXXXX-XXXXXX-XXXXXX"
        )
        =#
    end

    # create a public and a private websocket connection
    # specify `private=false` or `public=false` to use only one feed
    con = @async connect(ws_client, callback=on_message, private=true)

    #== Subscribe to public and private websocket feeds ==#
    subscribe(
        client=ws_client,
        subscription=Dict{String,Any}("name" => "ticker"),
        pairs=["XBT/USD", "DOT/USD"]
    )

    subscribe(
        client=ws_client,
        subscription=Dict{String,Any}("name" => "ownTrades")
    )

    # wait before unsubscribe is done ...
    sleep(2)

    #== Unsubscribe from public and private websocket feeds ==#
    # unsubscribe(
    #     client=ws_client,
    #     subscription=Dict{String,Any}("name" => "ticker"),
    #     pairs=["XBT/USD", "DOT/USD"]
    # )
    # unsubscribe(
    #     client=ws_client,
    #     subscription=Dict{String,Any}("name" => "ownTrades")
    # )

    # to cancel a connection you can use:
    # ws_client.cancel_private_connection = true
    # ws_client.cancel_public_connection = true

    wait(con)
end

main()
```
