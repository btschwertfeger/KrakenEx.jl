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

    # wait before unsubscribe is done ...
    sleep(2)

    #== Unsubscribe from public and private websocket feeds ==#
    unsubscribe(client=ws_client, feed="ticker", products=["PI_XBTUSD"])
    # unsubscribe(client=ws_client, feed="ticker", products=["PF_SOLUSD"])
    # unsubscribe(client=ws_client, feed="fills")
    # unsubscribe(client=ws_client, feed="open_orders")
    # ...

    wait(con)
end

main()

end