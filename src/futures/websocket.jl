module FuturesWebSocketModule
using HTTP
using Dates
using JSON
using Base64
using Nettle

import ..ExceptionsModule as exc
using ..FuturesBaseAPIModule: FuturesBaseRESTAPI

#= E X P O R T S =#
export FuturesWebSocketClient
export subscribe
export unsubscribe
export connect

"""
    FuturesWebSocketClient

Type that stores information about the client and can be used
to establish public and private websocket connections for 
Kraken Futures trading.

# Fields

- `key` -- Kraken Futures API key
- `secret` -- Kraken Futures Secret key
- `cancel_public_connection` -- can be set disable the active public websocket connection
- `cancel_private_connection` -- can be set to disable the active private websocket connection

The following will be managed by the connection:
- `new_challenge` -- newest signed message
- `last_challenge` -- last signed message
- `challenge_ready` -- is set if the challenge is signed

- `url` -- default websocket url for Kraken Futures
- `active_subscriptions` -- List of active subscribed feeds
- `pending_subscriptions` -- List of pending subscribtions

- `public_ws` -- Public connected websocket instance
- `private_ws` -- Private connected websocket instance

- `available_public_feeds` -- List of all public feeds
- `available_private_feeds` -- List of all private feeds

# Exampless

- `FuturesWebSocketClient()` -- default, public client

- `FuturesWebSocketClient("the-api-key", "the-api-secret-key")` -- authenticated client for public and private requests
"""
mutable struct FuturesWebSocketClient

    rest_client::FuturesBaseRESTAPI

    key::Union{String,Nothing}
    secret::Union{String,Nothing}

    new_challenge::Union{String,Nothing}
    last_challenge::Union{String,Nothing}
    challenge_ready::Bool

    url::String
    active_subscriptions::Vector{Dict{String,Any}}
    pending_subscriptions::Vector{Dict{String,Any}}

    public_ws::Union{HTTP.WebSockets.WebSocket,Nothing}
    private_ws::Union{HTTP.WebSockets.WebSocket,Nothing}

    cancel_public_connection::Bool
    cancel_private_connection::Bool

    available_public_feeds::Vector{String}
    available_private_feeds::Vector{String}

    FuturesWebSocketClient() = new(
        FuturesBaseRESTAPI(),       # REST client
        nothing,                    # key
        nothing,                    # secret
        nothing,                    # new_challenge
        nothing,                    # last_challenge
        false,                      # challenge_ready
        "futures.kraken.com/ws/v1", # url
        [], [],                     # misc
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
        FuturesBaseRESTAPI(key=key, secret=secret), # REST client
        key,                            # key
        secret,                         # secret
        nothing,                        # new_challenge
        nothing,                        # last_challenge
        false,                          # challenge_ready
        "futures.kraken.com/ws/v1",     # url
        [], [],                         # misc
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

"""
    subscribe(; 
        client::FuturesWebSocketClient,
        feed::String,
        products::Union{Vector{String},Nothing}=nothing
    )

Subscribe to a websocket feed.

# Examples

```julia-repl
julia> # ws_client = FuturesWebSocketClient() # unauthenticated
julia> ws_client = FuturesWebSocketClient("api-key", "secret-key") # authenticated
julia> on_message(msg::Union{Dict{String,Any},String}) = println(msg)
julia> con = @async connect(ws_client, callback=on_message)
julia> subscribe(client=ws_client, feed="ticker", products=["PI_XBTUSD", "PF_SOLUSD"]) # public feeds
julia> subscribe(client=ws_client, feed="open_orders") # private feed
julia> wait(conn)
```
"""
function subscribe(;
    client::FuturesWebSocketClient,
    feed::String,
    products::Union{Vector{String},Nothing}=nothing
)
    [push!(client.pending_subscriptions, sub) for sub ∈ build_subscriptions(client, feed, "subscribe", products)]
end

"""
    unsubscribe(;
        client::FuturesWebSocketClient,
        feed::String,
        products::Union{Vector{String},Nothing}=nothing
    )

Unsubscribe from a subscribed feed.

# Examples

```julia-repl
julia> # ws_client = FuturesWebSocketClient() # unauthenticated
julia> ws_client = FuturesWebSocketClient("api-key", "secret-key") # authenticated
julia> on_message(msg::Union{Dict{String,Any},String}) = println(msg)
julia> con = @async connect(ws_client, callback=on_message)
julia> unsubscribe(client=ws_client, feed="ticker", products=["PI_XBTUSD", "PF_SOLUSD"]) # public feeds
julia> unsubscribe(client=ws_client, feed="open_orders") # private feed
julia> wait(conn)
```
"""
function unsubscribe(;
    client::FuturesWebSocketClient,
    feed::String,
    products::Union{Vector{String},Nothing}=nothing
)
    [push!(client.pending_subscriptions, sub) for sub ∈ build_subscriptions(client, feed, "unsubscribe", products)]
end

"""
    wait_check_challenge_ready(client::FuturesWebSocketClient)

Requests and wait for a new challenge to create a private request.
"""
function wait_check_challenge_ready(client::FuturesWebSocketClient)
    WebSockets.send(client.private_ws, JSON.json(Dict{String,Any}(
        "event" => "challenge",
        "key" => client.key
    )))

    wait(@async while !client.challenge_ready
        sleep(0.2)
    end)
end

"""
    send_message(
        client::FuturesWebSocketClient,
        message::Dict{String,Any},
        private::Bool=false
    )

Sends a (optional: signed) message via the websocket connection.
"""
function send_message(
    client::FuturesWebSocketClient,
    message::Dict{String,Any},
    private::Bool=false
)
    if private
        if isnothing(client.key) || isnothing(client.secret)
            throw(KrakenAuthenticationError("Cannot access private endpoints using an unauthenticated client."))
        elseif !client.challenge_ready
            wait_check_challenge_ready(client)
        end

        message["key"] = client.key
        message["original_challenge"] = client.last_challenge
        message["signed_challenge"] = client.new_challenge
        WebSockets.send(client.private_ws, JSON.json(message))

    elseif !isnothing(client.public_ws)
        WebSockets.send(client.public_ws, JSON.json(message))

    else
        error("Could not send message $message")
    end
end

"""
    build_subscriptions(
        client::FuturesWebSocketClient,
        feed::String,
        event::String,
        products::Union{Vector{String},Nothing}=nothing
    )

Builds sub- and unsubscription payloads.
"""
function build_subscriptions(
    client::FuturesWebSocketClient,
    feed::String,
    event::String,
    products::Union{Vector{String},Nothing}=nothing
)
    if feed ∈ client.available_public_feeds
        if isnothing(products)
            return Vector{Dict{String,Any}}([Dict{String,Any}(
                "event" => event,
                "feed" => feed
            )])
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
            return Vector{Dict{String,Any}}([
                Dict{String,Any}(
                    "event" => event,
                    "feed" => feed
                )
            ])
        end
    else
        error("Unknown feed `$feed`!")
    end
end

"""
    check_pending_subscriptions(client::FuturesWebSocketClient, private::Bool)

Iterates over the pending subscriptions and calls the `send_message` function
to request the subscription to Kraken.
"""
function check_pending_subscriptions(client::FuturesWebSocketClient, private::Bool)
    for sub ∈ client.pending_subscriptions
        feed = sub["feed"]
        if feed ∈ client.available_public_feeds && !private || feed ∈ client.available_private_feeds && private
            send_message(client, sub, private)
            filter!(e -> e ≠ sub, client.pending_subscriptions)
        elseif feed ∉ client.available_public_feeds && feed ∉ client.available_private_feeds
            error("Unknown feed `$feed`!")
        end
    end
end

"""
    recover_subscriptions(client::FuturesWebSocketClient)

Moves the subscriptions to pending subscriptions to resubscribe from them later.
"""
function recover_subscriptions(client::FuturesWebSocketClient)
    for sub ∈ client.active_subscriptions
        filter!(e -> e ≠ sub, client.active_subscriptions)
        push!(client.pending_subscriptions, sub)
    end
end

"""
    get_sign_challenge(client::FuturesWebSocketClient, challenge::String)

Signes the challenge based on the users credentials.
"""
function get_sign_challenge(client::FuturesWebSocketClient, challenge::String)
    return Base64.base64encode(
        transcode(
            String, Nettle.digest(
                "sha512",
                Base64.base64decode(client.secret), # decoded 
                transcode(String, Nettle.digest("sha256", challenge)) # message
            )
        )
    )
end

"""
    handle_new_challenge(client::FuturesWebSocketClient, last_challenge::String)

Computes a new challenge based on the old (received) one.
"""
function handle_new_challenge(client::FuturesWebSocketClient, last_challenge::String)
    client.last_challenge = last_challenge
    client.new_challenge = get_sign_challenge(client, client.last_challenge)
    client.challenge_ready = true
end

"""
    parse_message(client::FuturesWebSocketClient, msg::String)

Parses the incoming messages; appending, removing subscriptions etc.
"""
function parse_message(client::FuturesWebSocketClient, msg::String)
    try
        message::Dict{String,Any} = JSON.parse(msg)

        if haskey(message, "event")
            if message["event"] == "challenge" && haskey(message, "message")
                handle_new_challenge(client, message["message"])
                return nothing
            elseif message["event"] ∈ ["subscribed", "unsubscribed"]
                sub::Union{Dict{String,Any},Nothing} = nothing
                if haskey(message, "product_ids")
                    sub = build_subscriptions(
                        client,
                        message["feed"],
                        [message["product_ids"]],
                        "subscribe"
                    )[begin]
                else
                    sub = build_subscriptions(client, message["feed"], "subscribe")[begin]
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
    catch err
        # throw(err)
        return msg
    end
end

"""
    establish_connection(
        client::FuturesWebSocketClient,
        callback::Core.Function,
        private::Bool=false
    )

Can create both, private and public websocket connections to send the received messages to
the callback function.
"""
function establish_connection(
    client::FuturesWebSocketClient,
    callback::Core.Function,
    private::Bool=false
)

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
            JSON.json(Dict{String,String}("event" => "$auth WebSocket connected"))
        ))

        recover_subscriptions(client)

        last_ping_time = Dates.now()
        @async while true
            check_pending_subscriptions(client, private)
            if last_ping_time < Dates.now() - Dates.Second(15)
                WebSockets.ping(ws)
                last_ping_time = Dates.now()
            end
            sleep(0.25)
        end

        msg::Union{String,Dict{String,Any},Nothing} = nothing
        try
            for msg ∈ ws
                if !isnothing(msg)
                    msg = parse_message(client, msg)
                    !isnothing(msg) ? callback(msg) : nothing
                end
            end
        catch err
        # throw(err)
        finally
            callback(parse_message(
                client,
                JSON.json(Dict{String,String}("event" => "$auth connection closed"))
            ))
        end
    end
end

"""
    connect(
        client::FuturesWebSocketClient;
        callback::Core.Function,
        public::Bool=true,
        private::Bool=false
    )

Can create up to two (one private and one public) websocket connections. The public and/or private
websocket object will be stored within the `FuturesWebSocketClient`. Websocket feeds can be subscribed
and unsubscribed after a successful connection. This function must be invoked using `@async`. Private 
websocket connections and privat feed subscriptions requre valid API keys on the passed 
`FuturesWebSocketClient` object.

# Attributes

- `client::FuturesWebSocketClient` -- the [`FuturesWebSocketClient`](@ref) instance
- `callback::Core.Function` -- Callback function wich receives the websocket messages
- `public::Bool=true` -- switch to activate/deactivate the public websocket connection
- `private::Bool=false` -- switch to activate/deactivate the private websocket connection


# Examples

```julia-repl
julia> # ws_client = FuturesWebSocketClient() # unauthenticated
julia> ws_client = FuturesWebSocketClient("api-key", "secret-key") # authenticated
julia> on_message(msg::Union{Dict{String,Any},String}) = println(msg)
julia> con = @async connect(ws_client, callback=on_message)
julia> subscribe(client=ws_client, feed="ticker", products=["PI_XBTUSD", "PF_SOLUSD"]) # public feeds
julia> subscribe(client=ws_client, feed="open_orders") # private feed
julia> wait(conn)
```
"""
function connect(
    client::FuturesWebSocketClient;
    callback::Core.Function,
    public::Bool=true,
    private::Bool=false
)

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

    if !isnothing(client.key) && !isnothing(client.secret) && private
        @async while !client.cancel_private_connection
            client.challenge_ready = false
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