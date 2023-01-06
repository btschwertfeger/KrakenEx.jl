module FuturesWebsocketModule
using HTTP
using Dates: now, Second
using JSON: json, parse

import ..ExceptionsModule as exc

export FuturesWebSocketClient
export subscribe
export unsubscribe
export connect

mutable struct FuturesWebSocketClient
    API_KEY::Union{String,Nothing}
    SECRET_KEY::Union{String,Nothing}

    new_challenge::Union{String,Nothing}
    last_challenge::Union{String,Nothing}
    challenge_ready::Bool

    url::String
    active_subscriptions::Vector{Dict{String,Any}}
    pending_subscriptions::Vector{Dict{String,Any}}
    pending_messages::Vector{Dict{String,Any}}

    public_ws::Union{HTTP.WebSockets.WebSocket,Nothing}
    private_ws::Union{HTTP.WebSockets.WebSocket,Nothing}

    cancel_public_connection::Bool
    cancel_private_connection::Bool

    available_public_feeds::Vector{String}
    available_private_feeds::Vector{String}

    FuturesWebSocketClient() = new(
        nothing,                    # key
        nothing,                    # secret
        nothing,                    # new_challenge
        nothing,                    # last_challenge
        false,                      # challenge_ready
        "futures.kraken.com/ws/v1", # url
        [], [], [],                 # misc
        nothing, nothing,           # connections
        false, false,               # cancel connections
        ["trade", "book", "ticker", "ticker_lite", "heartbeat"],
        [
            "fills",
            "open_positions", "open_orders", "open_orders_verbose",
            "balances",
            "deposits_withdrawals", "account_balances_and_margins",
            "account_log", "notifications_auth"
        ]
    )
    FuturesWebSocketClient(key::String, secret::String) = new(
        key,                            # key
        secret,                         # secret
        nothing,                        # new_challenge
        nothing,                        # last_challenge
        false,                          # challenge_ready
        "futures.kraken.com/ws/v1",     # url
        [], [], [],                     # misc
        nothing, nothing,               # connections
        false, false,                   # cancel connections
        ["trade", "book", "ticker", "ticker_lite", "heartbeat"],
        [
            "fills",
            "open_positions", "open_orders", "open_orders_verbose",
            "balances",
            "deposits_withdrawals", "account_balances_and_margins",
            "account_log", "notifications_auth"
        ]
    )
end

function subscribe(; client::FuturesWebSocketClient, feed::String, products::Union{Vector{String},Nothing}=nothing)
    [push!(client.pending_subscriptions, sub) for sub ∈ build_subscriptions(client=client, feed=feed, event="subscribe", products=products)]
end

function unsubscribe(; client::FuturesWebSocketClient, feed::String, products::Union{Vector{String},Nothing}=nothing)
    [push!(client.pending_subscriptions, sub) for sub ∈ build_subscriptions(client=client, feed=feed, event="unsubscribe", products=products)]
end

function wait_check_challenge_ready(client::FuturesWebSocketClient)
    WebSockets.send(client.private_ws, json(Dict{String,Any}(
        "event" => "challenge",
        "api_key" => client.API_KEY
    )))

    return @async while !client.challenge_ready
        sleep(0.2)
    end
end

function send_message(
    client::FuturesWebSocketClient,
    message::Dict{String,Any},
    private::Bool=false
)
    if private
        if isnothing(client.API_KEY) || isnothing(client.SECRET_KEY)
            throw(KrakenAuthenticationError("Cannot access private endpoints using an unauthenticated client."))
        elseif !client.challenge_ready
            wait(wait_check_challenge_ready(client))
        end

        message["api_key"] = client.API_KEY
        message["original_challenge"] = client.last_challenge
        message["signed_challenge"] = client.new_challenge
        WebSockets.send(client.private_ws, json(message))

    elseif !isnothing(client.public_ws)
        WebSockets.send(client.public_ws, json(message))

    else
        error("Could not send message $message")
    end
end

function build_subscriptions(; client::FuturesWebSocketClient, feed::String, event::String, products::Union{Vector{String},Nothing}=nothing)

    if feed ∈ client.available_public_feeds
        if isnothing(products)
            return Vector{Dict{String,Any}}(Dict{String,Any}(
                "event" => event,
                "feed" => feed
            ))
        else
            events::Vector{Dict{String,Any}} = Vector{Dict{String,Any}}()
            for product ∈ products
                push!(events, Dict{String,Any}(
                    "event" => event,
                    "feed" => feed,
                    "product_ids" => [product]
                ))
            end
            return events
        end
    elseif feed ∈ client.available_private_feeds
        if !isnothing(products)
            error("private feeds do not accept `products`!")
        else
            return Vector{Dict{String,Any}}(
                Dict{String,Any}(
                    "event" => event,
                    "feed" => feed
                )
            )
        end
    else
        error("Unknown feed `$feed`!")
    end
end

function check_pending_subscriptions(client::FuturesWebSocketClient, private::Bool)
    for sub ∈ client.pending_subscriptions
        feed = sub["feed"]
        if feed ∈ client.available_public_feeds && !private || feed ∈ client.available_private_feeds && private
            if private && !client.challenge_ready
                return
            end
            send_message(client, sub, private)
            filter!(e -> e ≠ sub, client.pending_subscriptions)
        elseif feed ∉ client.available_public_feeds && feed ∉ client.available_private_feeds
            error("Unknown feed `$feed`!")
        end
    end
end

function recover_subscriptions(client::FuturesWebSocketClient)
    for sub ∈ client.active_subscriptions
        filter!(e -> e ≠ sub, client.active_subscriptions)
        push!(client.pending_subscriptions, sub)
    end
end

function get_sign_challenge(client::FuturesWebSocketClient, challenge::String)
    return base64encode(
        transcode(
            String, digest(
                "sha512",
                base64decode(client.SECRET_KEY), # decoded 
                transcode(String, digest("sha256", challenge)) # message
            )
        )
    )
end

function handle_new_challenge(client::FuturesWebSocketClient, msg::String)
    client.last_challenge = msg["message"]
    client.new_challenge = get_sign_challenge(client, client.last_challenge)
    client.challenge_ready = true
end

function parse_message(client::FuturesWebSocketClient, msg::String)
    try
        message::Dict{String,Any} = parse(msg)

        if haskey(message, "event")
            if message["event"] == "challenge" && haskey(message, "message")
                handle_new_challenge(client, msg)
                return nothing
            elseif message["event"] ∈ ["subscribed", "unsubscribed"]
                sub::Union{Dict{String,Any},Nothing} = nothing
                if haskey(message, "product_ids")
                    sub = build_subscriptions(feed=message["feed"], products=[message["product_ids"]], event="subscribe")[begin]
                else
                    sub = build_subscriptions(feed=message["feed"], event="subscribe")[begin]
                end

                if message["event"] == "subscribed"
                    # add to subscription list
                    push!(client.active_subscriptions, sub)
                else
                    # remove from subscription list
                    filter!(e -> e ≠ sub, client.active_subscriptions)
                end
            end
        end

        return message
    catch
        return msg
    end
end

function establish_connection(client::FuturesWebSocketClient, callback::Core.Function, private::Bool=false)

    return @async WebSockets.open("wss://" * client.url) do ws

        if private
            auth = "private"
            client.private_ws = ws
        else
            auth = "public"
            client.public_ws = ws
        end

        callback(parse_message(
            client,
            json(Dict{String,String}("event" => "$auth WebSocket connected"))
        ))

        recover_subscriptions(client)

        @async while true
            check_pending_subscriptions(client, private)
            check_pending_messages(client)
            sleep(0.1)
        end

        last_ping_time = now()
        msg::Union{String,Dict{String,Any},Nothing} = nothing
        try
            for msg ∈ ws
                if last_ping_time < now() - Second(15)
                    WebSockets.ping(ws)
                    last_ping_time = now()
                end

                if !isnothing(msg)
                    msg = parse_message(client, msg)
                    !isnothing(msg) ? callback(msg) : nothing
                end
            end
        catch
            callback(parse_message(
                client,
                json(Dict{String,String}("event" => "connection closed"))
            ))
        end
    end
end

function connect(client::FuturesWebSocketClient; callback::Core.Function, public::Bool=true, private::Bool=false)

    !public && !private ? error("No connection established, because public and private was set to false") : nothing

    public_task::Union{Task,Nothing} = nothing
    private_task::Union{Task,Nothing} = nothing
    some_connected::Bool = false

    if public
        @async while !client.cancel_public_connection
            public_task = establish_connection(client, callback, false)
            some_connected = true
            wait(public_task)
        end
        public_task = nothing
    end

    if !isnothing(client.API_KEY) && !isnothing(client.SECRET_KEY) && private
        @async while !client.cancel_private_connection
            private_task = establish_connection(client, callback, true)
            some_connected = true
            wait(private_task)
        end
        private_task = nothing
    end

    while !some_connected || (!isnothing(public_task) || !isnothing(private_task))
        wait(@async sleep(30))
    end
end

end