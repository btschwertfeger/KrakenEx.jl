module spot_websoclet_exmaple

include("../src/KrakenEx.jl")
using .KrakenEx
using DotEnv


function main()
    DotEnv.config(path=".env")

    ws_client = SpotWebsocketClient(ENV["SPOT_API_KEY"], ENV["SPOT_SECRET_KEY"])

    function on_message(msg::Union{Dict{String,Any},String})
        println(msg)
    end

    con = @async connect(ws_client, callback=on_message)

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