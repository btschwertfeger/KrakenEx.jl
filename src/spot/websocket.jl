module KrakenSpotWebsocketModule
using HTTP
using Dates: now, Second
using JSON: json, parse

using ..KrakenSpotBaseAPIModule
using ..KrakenSpotUserModule: get_websockets_token

#= E X P O R T S =#
export SpotWebsocketClient
export connect
export subscribe, unsubscribe

mutable struct SpotWebsocketClient
    public_client::SpotBaseRESTAPI
    private_client::Union{SpotBaseRESTAPI,Nothing}
    private_ws_token::Union{String,Nothing}
    public_url::String
    private_url::String

    active_subscriptions::Vector{Dict{String,Any}}
    pending_subscriptions::Vector{Dict{String,Any}}

    SpotWebsocketClient() = new(
        SpotBaseRESTAPI(),
        nothing,
        nothing,
        "ws.kraken.com",
        "ws-auth.kraken.com",
        [],
        []
    )
    SpotWebsocketClient(key::String, secret::String) = new(
        SpotBaseRESTAPI(),
        SpotBaseRESTAPI(key, secret),
        get_websockets_token(SpotBaseRESTAPI(key, secret))["token"],
        "ws.kraken.com",
        "ws-auth.kraken.com",
        [],
        []
    )
end

function send_message(; ws::HTTP.WebSockets.WebSocket, client::SpotWebsocketClient, message::Dict{String,Any}, private::Bool=false)
    if haskey(message, "subscription") && private
        message["subscription"]["token"] = client.private_ws_token
    elseif private
        message["token"] = client.private_ws_token
    end

    WebSockets.send(ws, json(message))
end

function unsubscribe(; client::SpotWebsocketClient, subscription::Dict{String,Any}, pairs::Union{Vector{String},Nothing}=nothing)
    [push!(client.pending_subscriptions, sub) for sub ∈ build_subscriptions(subscription=subscription, event="unsubscribe", pairs=pairs)]
end
function subscribe(; client::SpotWebsocketClient, subscription::Dict{String,Any}, pairs::Union{Vector{String},Nothing}=nothing)
    [push!(client.pending_subscriptions, sub) for sub ∈ build_subscriptions(subscription=subscription, event="subscribe", pairs=pairs)]
end

function build_subscriptions(; subscription::Dict{String,Any}, event::String, pairs::Union{Vector{String},Nothing}=nothing)
    subscriptions::Vector{Dict{String,Any}} = []

    if !isnothing(pairs)
        for pair ∈ pairs
            push!(subscriptions, Dict{String,Any}(
                "event" => event,
                "subscription" => subscription,
                "pair" => Vector{String}([pair])
            ))
        end
    else
        push!(subscriptions, Dict{String,Any}(
            "event" => event,
            "subscription" => subscription
        ))
    end

    return subscriptions
end

function check_pending_subscriptions(client::SpotWebsocketClient, ws::HTTP.WebSockets.WebSocket, private::Bool)
    public_sub_names::Vector{String} = ["ticker", "spread", "book", "ohlc", "trade", "*"]
    private_sub_names::Vector{String} = ["ownTrades", "openOrders"]

    for sub ∈ client.pending_subscriptions
        sub_name = sub["subscription"]["name"]

        if (sub_name ∈ public_sub_names && !private) || (sub_name ∈ private_sub_names && private)
            send_message(ws=ws, client=client, message=sub, private=private)
            filter!(e -> e ≠ sub, client.pending_subscriptions)
        elseif sub_name ∉ public_sub_names && sub_name ∉ private_sub_names
            error("Unknown subscription name!")
        end
    end
end

"""
    recover_subscriptions(client::SpotWebsocketClient, ws::HTTP.WebSockets.WebSocket, private::Bool)

Moves the active subscriptions to the pending subscriptions to resend a subscribe message.    
"""
function recover_subscriptions(client::SpotWebsocketClient, ws::HTTP.WebSockets.WebSocket, private::Bool)
    for sub ∈ client.active_subscriptions
        filter!(e -> e ≠ sub, client.active_subscriptions)
        push!(client.pending_subscriptions, sub)
    end
end

"""
    parse_message(client::SpotWebsocketClient, msg::String)

    Parses the incoming messages; appending, removing subscriptions ...
"""
function parse_message(client::SpotWebsocketClient, msg::String)
    try
        message::Dict{String,Any} = parse(msg)

        if haskey(message, "event")
            if message["event"] == "heartbeat"
                return

            elseif message["event"] == "subscriptionStatus" && haskey(message, "status")
                if message["status"] ∈ ["subscribed", "unsubscribed"]
                    sub::Union{Dict{String,Any},Nothing} = nothing
                    if haskey(message, "pair")
                        sub = build_subscriptions(subscription=message["subscription"], pairs=[message["pair"]], event="subscribe")[begin]
                    else
                        sub = build_subscriptions(subscription=message["subscription"], event="subscribe")[begin]
                    end

                    if message["status"] == "subscribed"
                        # add to subscription list
                        push!(client.active_subscriptions, sub)
                    else
                        # remove from subscription list
                        filter!(e -> e ≠ sub, client.active_subscriptions)
                    end

                elseif message["status"] == "error"
                    # handle or ignore? ... 
                end
            end
        end

        return message
    catch err
        # todo: handle error if is vector
        return msg
    end
end

function establish_connection(client::SpotWebsocketClient, callback::Core.Function, private::Bool)
    url::String = private ? client.private_url : client.public_url

    private ? auth = "private" : auth = "public"

    return @async WebSockets.open("https://" * url) do ws
        callback(parse_message(
            client,
            Dict{String,String}("event" => "$auth WebSocket connected")
        ))

        last_public_ping_time = now()
        msg::Union{String,Dict{String,Any},Nothing} = nothing

        recover_subscriptions(client, ws, private)

        while true
            check_pending_subscriptions(client, ws, private)
            msg = nothing

            if last_public_ping_time < now() - Second(15)
                WebSockets.ping(ws)
                last_public_ping_time = now()
            end

            msg = WebSockets.receive(ws)
            if !isnothing(msg)
                msg = parse_message(client, msg)
                !isnothing(msg) ? callback(msg) : nothing
            end
        end
    end
end

"""
    connect(client::SpotWebsocketClient; callback::Core.Function, public::Bool=true, private::Bool=true)

Connects to public Kraken Websocket API and also to the private feed if the 
    `SpotWebsocketClient` has assigned credentials. 
Messages are filtered and forwarded to the callback function.
"""
function connect(client::SpotWebsocketClient; callback::Core.Function, public::Bool=true, private::Bool=true)

    !public && !private ? error("No connection established, because public and private was set to false") : nothing

    if public
        @async while true
            public_task = establish_connection(client, callback, false)
            wait(public_task)
        end
    end

    if !isnothing(client.private_client) && private
        @async while true
            private_task = establish_connection(client, callback, true)
            wait(private_task)
        end
    end

    while true
        wait(@async sleep(30))
    end
end
end