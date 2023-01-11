```@meta
   CurrentModule = KrakenEx.FuturesWebSocketModule
```

# Kraken Futures WebSocket API

The listed functions and data types allow to access to public and private (authenticated) websocket feeds.

```@contents
Pages = ["futures_websocket.md"]
```

## FuturesWebSocketClient

```@docs
FuturesWebSocketClient
```

## WebSocket utilities

```@docs
connect(
    client::FuturesWebSocketClient;
    callback::Core.Function,
    public::Bool=true,
    private::Bool=false
)
```

```@docs
subscribe(;
    client::FuturesWebSocketClient,
    feed::String,
    products::Union{Vector{String},Nothing}=nothing
)
```

```@docs
unsubscribe(;
    client::FuturesWebSocketClient,
    feed::String,
    products::Union{Vector{String},Nothing}=nothing
)
```
