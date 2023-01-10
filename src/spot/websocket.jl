module SpotWebSocketModule
using HTTP
using Dates: now, Second
using JSON: json, parse

using ..SpotBaseAPIModule: SpotBaseRESTAPI
using ..SpotUserModule: get_websockets_token
import ..ExceptionsModule as exc

export SpotWebSocketClient
export connect, subscribe, unsubscribe
export create_order
export edit_order
export cancel_order
export cancel_all_orders
export cancel_all_orders_after_x

"""
    SpotWebSocketClient

Type that stores information about the client and can be used
to establish public and private websocket connections for 
Kraken Spot trading.

### Fields

- `key` -- Kraken Spot API key
- `secret` -- Kraken Spot Secret key
- `cancel_public_connection` -- can be set disable the active public websocket connection
- `cancel_private_connection` -- can be set to disable the active private websocket connection

The following will be managed by the connection:
- `public_url` -- default websocket url for Kraken public Spot trading (default: "ws.kraken.com")
- `private_url` -- default websocket url for Kraken private Spot trading (default: "ws-auth.kraken.com")
- `active_subscriptions` -- List of active subscribed feeds
- `pending_subscriptions` -- List of pending subscribtions
- `pending_messages` -- List of pending messages (e.g. `create_order` events)

### Examples

- `SpotWebSocketClient()` -- default, public client

- `SpotWebSocketClient("the-api-key", "the-api-secret-key")` -- authenticated client for public and private requests
"""
mutable struct SpotWebSocketClient
    public_client::SpotBaseRESTAPI
    private_client::Union{SpotBaseRESTAPI,Nothing}
    private_ws_token::Union{String,Nothing}
    public_url::String
    private_url::String

    active_subscriptions::Vector{Dict{String,Any}}
    pending_subscriptions::Vector{Dict{String,Any}}
    pending_messages::Vector{Dict{String,Any}}

    cancel_public_connection::Bool
    cancel_private_connection::Bool

    SpotWebSocketClient() = new(
        SpotBaseRESTAPI(),
        nothing,
        nothing,
        "ws.kraken.com",
        "ws-auth.kraken.com",
        [], [], [],
        false, false
    )

    SpotWebSocketClient(key::String, secret::String) = new(
        SpotBaseRESTAPI(),
        SpotBaseRESTAPI(key=key, secret=secret),
        get_websockets_token(SpotBaseRESTAPI(key=key, secret=secret))["token"],
        "ws.kraken.com",
        "ws-auth.kraken.com",
        [], [], [],
        false, false
    )
end

"""
    send_message(;
        ws::HTTP.WebSockets.WebSocket,
        client::SpotWebSocketClient,
        message::Dict{String,Any},
        private::Bool=false
    )

Sends a (optional: signed) message via the websocket connection.
"""
function send_message(;
    ws::HTTP.WebSockets.WebSocket,
    client::SpotWebSocketClient,
    message::Dict{String,Any},
    private::Bool=false
)
    if haskey(message, "subscription") && private
        message["subscription"]["token"] = client.private_ws_token
    elseif private
        message["token"] = client.private_ws_token
    end

    WebSockets.send(ws, json(message))
end

"""
    subscribe(;
        client::SpotWebSocketClient,
        subscription::Dict{String,Any},
        pairs::Union{Vector{String},Nothing}=nothing
    )

Kraken Docs: [https://docs.kraken.com/websockets/#message-subscribe](https://docs.kraken.com/websockets/#message-subscribe)

Subscribe to a websocket feed.

# Example

```julia-repl
julia> ws_client = SpotWebSocketClient()
julia> on_message(msg::Union{Dict{String,Any},String}) = println(msg)
julia> con = @async connect(ws_client, callback=on_message)
julia> subscribe(
...        client=ws_client,
...        subscription=Dict{String,Any}("name" => "ticker"),
...        pairs=["XBT/USD", "DOT/USD"]
...    )
julia> wait(conn)
```
"""
function subscribe(;
    client::SpotWebSocketClient,
    subscription::Dict{String,Any},
    pairs::Union{Vector{String},Nothing}=nothing
)
    [push!(client.pending_subscriptions, sub) for sub ∈ build_subscriptions(subscription=subscription, event="subscribe", pairs=pairs)]
end

"""
    unsubscribe(;
        client::SpotWebSocketClient,
        subscription::Dict{String,Any},
        pairs::Union{Vector{String},Nothing}=nothing
    )

Kraken Docs: [https://docs.kraken.com/websockets/#message-unsubscribe](https://docs.kraken.com/websockets/#message-unsubscribe)

Unsubscribe from a subscribed feed.

# Example

```julia-repl
julia> ws_client = SpotWebSocketClient()
julia> on_message(msg::Union{Dict{String,Any},String}) = println(msg)
julia> con = @async connect(ws_client, callback=on_message)
julia> unsubscribe(
...        client=ws_client,
...        subscription=Dict{String,Any}("name" => "ticker"),
...        pairs=["XBT/USD", "DOT/USD"]
...    )
julia> wait(conn)
```
"""
function unsubscribe(;
    client::SpotWebSocketClient,
    subscription::Dict{String,Any},
    pairs::Union{Vector{String},Nothing}=nothing
)
    [push!(client.pending_subscriptions, sub) for sub ∈ build_subscriptions(subscription=subscription, event="unsubscribe", pairs=pairs)]
end

"""
    build_subscriptions(;
        subscription::Dict{String,Any},
        event::String,
        pairs::Union{Vector{String},Nothing}=nothing
    )

Builds sub- and unsubscription payloads.
"""
function build_subscriptions(;
    subscription::Dict{String,Any},
    event::String,
    pairs::Union{Vector{String},Nothing}=nothing
)
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

"""
    check_pending_subscriptions(
        client::SpotWebSocketClient,
        ws::HTTP.WebSockets.WebSocket,
        private::Bool
    )

Iterates over the pending subscriptions and calls the `send_message` function 
to request the subscription to Kraken.
"""
function check_pending_subscriptions(
    client::SpotWebSocketClient,
    ws::HTTP.WebSockets.WebSocket,
    private::Bool
)
    public_sub_names::Vector{String} = ["ticker", "spread", "book", "ohlc", "trade", "*"]
    private_sub_names::Vector{String} = ["ownTrades", "openOrders"]

    for sub ∈ client.pending_subscriptions
        sub_name = sub["subscription"]["name"]

        if (sub_name ∈ public_sub_names && !private) || (sub_name ∈ private_sub_names && private)
            send_message(ws=ws, client=client, message=sub, private=private)
            filter!(e -> e ≠ sub, client.pending_subscriptions)
        elseif sub_name ∉ public_sub_names && sub_name ∉ private_sub_names
            error("Unknown subscription name `$sub_name`!")
        end
    end
end


"""
    check_pending_messages(client::SpotWebSocketClient, ws::HTTP.WebSockets.WebSocket)

"""
function check_pending_messages(client::SpotWebSocketClient, ws::HTTP.WebSockets.WebSocket)
    for message ∈ client.pending_messages
        # messages sent are always private (so far)
        send_message(ws=ws, client=client, message=sub, private=true)
        filter!(e -> e ≠ message, client.pending_messages)
    end
end

"""
    recover_subscriptions(client::SpotWebSocketClient)

Moves the active subscriptions to the pending subscriptions to resend a subscribe message.    
"""
function recover_subscriptions(client::SpotWebSocketClient)
    for sub ∈ client.active_subscriptions
        filter!(e -> e ≠ sub, client.active_subscriptions)
        push!(client.pending_subscriptions, sub)
    end
end

"""
    parse_message(client::SpotWebSocketClient, msg::String)

Parses the incoming messages; appending, removing subscriptions etc.
"""
function parse_message(client::SpotWebSocketClient, msg::String)
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
    catch
        return msg
    end
end

"""
    establish_connection(
        client::SpotWebSocketClient,
        callback::Core.Function,
        private::Bool
    )

Can create both, private and public websocket connections to send the received messages to
the callback function.
"""
function establish_connection(
    client::SpotWebSocketClient,
    callback::Core.Function,
    private::Bool
)
    url::String = private ? client.private_url : client.public_url

    private ? auth = "private" : auth = "public"

    return @async WebSockets.open("wss://" * url) do ws
        callback(parse_message(
            client,
            json(Dict{String,String}("event" => "$auth WebSocket connected"))
        ))

        last_ping_time = now()
        msg::Union{String,Dict{String,Any},Nothing} = nothing

        recover_subscriptions(client)

        try
            for msg ∈ ws
                check_pending_subscriptions(client, ws, private)
                if private
                    check_pending_messages(client, ws)
                end

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

"""
    connect(
        client::SpotWebSocketClient;
        callback::Core.Function,
        public::Bool=true,
        private::Bool=false
    )
    
Can create up to two (one private and one public) websocket connections. The public and/or private
websocket object will be stored within the [`SpotWebSocketClient`](@ref). Websocket feeds can be subscribed
and unsubscribed after a successful connection. This function must be invoked using `@async`. Private 
websocket connections and privat feed subscriptions requre valid API keys on the passed 
[`SpotWebSocketClient`](@ref) object.

# Attributes

- `client::SpotWebSocketClient` -- the [`SpotWebSocketClient`](@ref) instance
- `callback::Core.Function` -- Callback function wich receives the websocket messages
- `public::Bool=true` -- switch to activate/deactivate the public websocket connection
- `private::Bool=false` -- switch to activate/deactivate the private websocket connection

# Example

```julia-repl
julia> # ws_client = SpotWebSocketClient() # unauthenticated
julia> ws_client = SpotWebSocketClient("api-key", "api-secret") # authenticated
julia> function on_message(msg::Union{Dict{String,Any},String})
...        println(msg)
...        # implement your strategy here
...    end 
julia> con = @async connect(ws_client, callback=on_message, private=true)
julia> subscribe(
...        client=ws_client,
...        subscription=Dict{String,Any}("name" => "ticker"),
...        pairs=["XBT/USD", "DOT/USD"]
...    )
julia> # do more stuff ... 
julia> wait(conn)
```
"""
function connect(
    client::SpotWebSocketClient;
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

    if !isnothing(client.private_client) && private
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

"""
    add_message(client::SpotWebSocketClient, payload::Dict{String,Any}, private::Bool)

Adds a message to the pending list of messages. These messages will be sent via the 
websocket connection.
"""
function add_message(client::SpotWebSocketClient, payload::Dict{String,Any}, private::Bool)
    push!(client.pending_messages, Dict{String,Any}("private" => private, "payload" => payload))
end

"""
    create_order(client::SpotWebSocketClient;
        ordertype::String,
        side::String,
        pair::String,
        volume::Union{String,Nothing},
        price::Union{String,Nothing}=nothing,
        price2::Union{String,Nothing}=nothing,
        leverage::Union{Float64,Int64,String,Nothing}=nothing,
        oflags::Union{String,Vector{String},Nothing}=nothing,
        starttm::String="0",
        expiretim::String="0",
        deadline::Union{String,Nothing}=nothing,
        userref::Union{Int32,Nothing}=nothing,
        validate::Bool=false,
        close_ordertype::Union{String,Nothing}=nothing,
        close_price::Union{String,Nothing}=nothing,
        close_price2::Union{String,Nothing}=nothing,
        timeinforce::Union{String,Nothing}=nothing
    )

Kraken Docs: [https://docs.kraken.com/websockets/#message-addOrder](https://docs.kraken.com/websockets/#message-addOrder)
"""
function create_order(client::SpotWebSocketClient;
    ordertype::String,
    side::String,
    pair::String,
    volume::Union{String,Nothing},
    price::Union{String,Nothing}=nothing,
    price2::Union{String,Nothing}=nothing,
    leverage::Union{Float64,Int64,String,Nothing}=nothing,
    oflags::Union{String,Vector{String},Nothing}=nothing,
    starttm::String="0",
    expiretim::String="0",
    deadline::Union{String,Nothing}=nothing,
    userref::Union{Int32,Nothing}=nothing,
    validate::Bool=false,
    close_ordertype::Union{String,Nothing}=nothing,
    close_price::Union{String,Nothing}=nothing,
    close_price2::Union{String,Nothing}=nothing,
    timeinforce::Union{String,Nothing}=nothing
)
    if isnothing(client.private_client)
        error("Cannot create order without an authenticated client.")
    end

    params = Dict{String,Any}(
        "ordertype" => ordertype,
        "type" => side,
        "volume" => string(volume),
        "pair" => pair,
        "stp_type" => stp_type,
        "starttm" => starttm,
        "expiretim" => expiretim,
        "validate" => string(validate)
    )
    if !isnothing(trigger)
        if ordertype ∈ ["stop-loss", "stop-loss-limit", "take-profit-limit", "take-profit-limit"]
            if !isnothing(timeinforce)
                params["trigger"] = trigger
            else
                error("Cannot use trigger " * trigger * " and timeinforce " * timeinforce * " together.")
            end
        else
            error("Cannot use trigger on ordertype " * ordertype * ".")
        end
    elseif !isnothing(timeinforce)
        params["timeinforce"] = timeinforce
    end
    !isnothing(price) ? params["price"] = price : nothing
    !isnothing(price2) ? params["price2"] = price2 : nothing
    !isnothing(leverage) ? params["leverage"] = leverage : nothing
    !isnothing(oflags) ? params["oflags"] = vector_to_string(oflags) : nothing
    !isnothing(close_ordertype) ? params["close_ordertype"] = close_ordertype : nothing
    !isnothing(close_price) ? params["close_price"] = close_price : nothing
    !isnothing(close_price2) ? params["close_price2"] = close_price2 : nothing
    !isnothing(deadline) ? params["deadline"] = deadline : nothing
    !isnothing(userref) ? params["userref"] = userref : nothing
    add_message(client, params, true)
end

"""
    edit_order(client::SpotWebSocketClient;
        txid::String,
        pair::String,
        volume::Union{String,Int64,Float64,Nothing}=nothing,
        price::Union{String,Int64,Float64,Nothing}=nothing,
        price2::Union{String,Int64,Float64,Nothing}=nothing,
        oflags::Union{String,Vector{String},Nothing}=nothing,
        deadline::Union{String,Nothing}=nothing,
        cancel_response::Bool=false,
        validate::Bool=false,
        userref::Union{Int32,Nothing}=nothing
    )

Kraken Docs: [https://docs.kraken.com/websockets/#message-editOrder](https://docs.kraken.com/websockets/#message-editOrder)
"""
function edit_order(client::SpotWebSocketClient;
    txid::String,
    pair::String,
    volume::Union{String,Int64,Float64,Nothing}=nothing,
    price::Union{String,Int64,Float64,Nothing}=nothing,
    price2::Union{String,Int64,Float64,Nothing}=nothing,
    oflags::Union{String,Vector{String},Nothing}=nothing,
    deadline::Union{String,Nothing}=nothing,
    cancel_response::Bool=false,
    validate::Bool=false,
    userref::Union{Int32,Nothing}=nothing
)
    if isnothing(client.private_client)
        error("Cannot create order without an authenticated client.")
    end

    params = Dict{String,Any}(
        "txid" => txid,
        "pair" => pair,
        "validate" => validate
    )
    !isnothing(userref) ? params["userref"] = userref : nothing
    !isnothing(volume) ? params["volume"] = string(volume) : nothing
    !isnothing(price) ? params["price"] = string(price) : nothing
    !isnothing(price2) ? params["price2"] = string(price2) : nothing
    !isnothing(oflags) ? params["oflags"] = vector_to_string(oflags) : nothing
    !isnothing(deadline) ? params["deadline"] = deadline : nothing
    !isnothing(cancel_response) ? params["cancel_response"] = string(cancel_response) : nothing
    add_message(client, params, true)
end

"""
    cancel_order(client::SpotWebSocketClient; txid::String)

[https://docs.kraken.com/websockets/#message-cancelOrder](https://docs.kraken.com/websockets/#message-cancelOrder)
"""
function cancel_order(client::SpotWebSocketClient; txid::String)
    if isnothing(client.private_client)
        error("Cannot create order without an authenticated client.")
    end
    add_message(client, Dict{String,Any}("txid" => txid), true)
end

"""
    cancel_all_orders(client::SpotWebSocketClient)

Kraken Docs: [https://docs.kraken.com/websockets/#message-cancelAll](https://docs.kraken.com/websockets/#message-cancelAll)
"""
function cancel_all_orders(client::SpotWebSocketClient)
    if isnothing(client.private_client)
        error("Cannot create order without an authenticated client.")
    end

    add_message(client, Dict{String,Any}("event" => "cancelAll"), true)
end
"""
    cancel_all_orders_after_x(client::SpotWebSocketClient, timeout::Int)

Kraken Docs: [https://docs.kraken.com/websockets/#message-cancelAllOrdersAfter](https://docs.kraken.com/websockets/#message-cancelAllOrdersAfter)
"""
function cancel_all_orders_after_x(client::SpotWebSocketClient, timeout::Int)
    if isnothing(client.private_client)
        error("Cannot create order without an authenticated client.")
    end

    add_message(client, Dict{String,Any}(
            "event" => "cancelAllOrdersAfter",
            "timeout" => timeout
        ), true)
end

end