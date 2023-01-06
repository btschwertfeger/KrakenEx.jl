module futures_websocket_example

using DotEnv

include("../src/KrakenEx.jl")
using .KrakenEx.FuturesWebsocketModule:
    FuturesWebSocketClient,
    connect,
    subscribe,
    unsubscribe

function main()

    DotEnv.config(path=".env")

    ws_client = FuturesWebSocketClient(ENV["FUTURES_API_KEY"], ENV["FUTURES_SECRET_KEY"])

    function on_message(msg::Union{Dict{String,Any},String})
        println(msg)
        # implement your strategy here....
    end

    con = @async connect(ws_client, callback=on_message, private=false)

    #== Subscribe to public and private websocket feeds ==#
    products::Vector{String} = ["PI_XBTUSD", "PF_SOLUSD"]
    subscribe(
        client=ws_client,
        feed="ticker",
        products=products
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
    wait(con)
end

main()

end