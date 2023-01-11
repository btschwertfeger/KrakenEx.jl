module spot_websocket_example

using DotEnv

include("../src/KrakenEx.jl")
using .KrakenEx.SpotWebSocketModule:
    SpotWebSocketClient,
    connect,
    subscribe, unsubscribe

function main()

    DotEnv.config(path=".env")

    ws_client = SpotWebSocketClient(ENV["SPOT_API_KEY"], ENV["SPOT_SECRET_KEY"])

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

end