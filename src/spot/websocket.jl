module KrakenSpotWebsocketModule
using HTTP
using JSON: json
using ..KrakenSpotBaseAPIModule

export SpotWebsocketClient
export connect
export subscribe

struct SpotWebsocketClient
    public_client::SpotBaseRESTAPI
    private_client::Union{SpotBaseRESTAPI,Nothing}
    public_url::String
    private_url::String

    SpotWebsocketClient() = new(
        SpotBaseRESTAPI(),
        nothing,
        "ws.kraken.com",
        "ws-auth.kraken.com"
    )
    SpotWebsocketClient(key::String, secret::String) = new(
        SpotBaseRESTAPI(),
        SpotBaseRESTAPI(key, secret),
        "ws.kraken.com",
        "ws-auth.kraken.com"
    )
end

function send_message(ws::HTTP.WebSockets.WebSocket, message::Dict{String,Any})
    WebSockets.send(ws, json(message))
end

function subscribe(; ws::HTTP.WebSockets.WebSocket, subscription::Dict{String,Any}, pairs::Union{Vector{String},Nothing})
    subscriptions = []

    if !isnothing(pairs)
        for pair ∈ pairs
            push!(subscriptions, Dict{String,Any}(
                "event" => "subscribe",
                "subscription" => subscription,
                "pair" => [pair]
            ))
        end
    else
        push!(subscriptions, subscription)
    end

    [send_message(ws, payload) for payload in subscriptions]
end

function connect(client::SpotWebsocketClient; callback, private::Bool=false)
    private ? url = client.private_url : url = client.public_url

    WebSockets.open("https://" * url) do ws
        for msg in ws
            callback(ws, msg)
        end
    end
end
end