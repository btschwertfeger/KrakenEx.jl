module spot_websoclet_exmaple
using HTTP

include("../src/KrakenEx.jl")
using .KrakenEx
using DotEnv


function main()
    DotEnv.config(path=".env")

    ws_client = SpotWebsocketClient(ENV["SPOT_API_KEY"], ENV["SPOT_SECRET_KEY"])
    x = false
    function cb(ws::HTTP.WebSockets.WebSocket, msg)
        println(msg)
        if !x
            subscribe(
                ws=ws,
                subscription=Dict{String,Any}("name" => "ticker"),
                pairs=["XBT/USD"]
            )
            x = true
        end
    end

    connect(ws_client, callback=cb)
end

main()

end