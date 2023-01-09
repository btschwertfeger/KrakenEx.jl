# Kraken Spot WebSocket API

The listed functions and data types allow to access to public and private (authenticated) websocket feeds.

```@meta
   CurrentModule = KrakenEx.SpotWebSocketModule
```

```@contents
Pages = ["spot_websocket.md"]
```

## SpotWebSocketClient

```@docs
SpotWebSocketClient
```

## WebSocket utilities

```@docs
connect(
    client::SpotWebSocketClient;
    callback::Core.Function,
    public::Bool=true,
    private::Bool=false
)
```

```@docs
subscribe(;
    client::SpotWebSocketClient,
    subscription::Dict{String,Any},
    pairs::Union{Vector{String},Nothing}=nothing
)
```

```@docs
unsubscribe(;
    client::SpotWebSocketClient,
    subscription::Dict{String,Any},
    pairs::Union{Vector{String},Nothing}=nothing
)
```

## Client functions

```@docs
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
```

```@docs
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
```

```@docs
cancel_order(client::SpotWebSocketClient; txid::String)
```

```@docs
cancel_all_orders(client::SpotWebSocketClient)
```

```@docs
cancel_all_orders_after_x(client::SpotWebSocketClient, timeout::Int)
```
