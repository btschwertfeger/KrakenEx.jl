```@meta
   CurrentModule = KrakenEx
```

```@contents
Pages = ["spot_examples.md"]
```

# Kraken Spot Trading Examples

## Spot REST Examples

```julia
using KrakenEx: SpotBaseRESTAPI

using KrakenEx.SpotMarketModule
using KrakenEx.SpotUserModule
using KrakenEx.SpotTradeModule
using KrakenEx.SpotFundingModule
using KrakenEx.SpotStakingModule
# you can also import all specific functions separate like shown in `/examples/spot_rest_examples.jl`

function main()
    key = "Kraken-public-key"
    secret = "Kraken-secret-key"

    client = SpotBaseRESTAPI() # public client
    private_client = SpotBaseRESTAPI(key,secret) # authenticated client

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
        # (dont forget that you can also access rest endpoints hier)
    end

    # the conn will create a public and a private websocket connection
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
