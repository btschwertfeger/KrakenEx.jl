"""
    SpotTradeModule

Enables accessing Spot trade endpoints using predefined methods.
"""
module SpotTradeModule

using ..SpotBaseAPIModule: SpotBaseRESTAPI, request
using ..Utils

#======= E X P O R T S ========#
export create_order
export create_order_batch
export edit_order
export cancel_order
export cancel_all_orders
export cancel_all_orders_after_x
export cancel_order_batch

#======= F U N C T I O N S ========#
"""
    create_order(client::SpotBaseRESTAPI;
        ordertype::String,
        side::String,
        pair::String,
        volume::Union{Float64,Int64,String},
        price::Union{Float64,Int64,String,Nothing}=nothing,
        price2::Union{Float64,Int64,String,Nothing}=nothing,
        trigger::Union{String,Nothing}=nothing,
        leverage::Union{Float64,Int64,String,Nothing}=nothing,
        stp_type::String="cancel-newest",
        oflags::Union{String,Vector{String},Nothing}=nothing,
        timeinforce::Union{String,Nothing}=nothing,
        starttm::String="0",
        expiretim::String="0",
        close_ordertype::Union{String,Nothing}=nothing,
        close_price::Union{String,Nothing}=nothing,
        close_price2::Union{String,Nothing}=nothing,
        deadline::Union{String,Nothing}=nothing,
        validate::Bool=false,
        reduce_only::Bool=false,
        displayvol::Union{Float64,Int64,String,Nothing}=nothing,
        userref::Union{Int32,Nothing}=nothing
    )

Kraken Docs: [https://docs.kraken.com/rest/#operation/addOrder](https://docs.kraken.com/rest/#operation/addOrder)

Enables the Spot trading mechanism. Various parameters can be specified for an individual trading preference.

Authenticated `client` required

# Arguments

`validate::Bool=false` -- Simulates order placement if set to `true`

...

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(
...        create_order(
...            private_client,
...            ordertype="limit",
...            side="buy",
...            volume=0.3,
...            pair="XBTUSD",
...            price="17000",
...            oflags="post"
...        )
...    )
Dict{String,Any}(
    "descr" => Dict{String,Any}(
        "order" => "buy 0.30000000 XBTUSD @ limit 17000.0",
    ),
    "txid" => ["0ZH90J-M4W3ZY-66GF8Y"]
)
julia> println(
...        create_order(
...            private_client,
...            ordertype="market",
...            side="buy",
...            volume=0.001,
...            pair="XBTUSD",
...            validate=true
...        )
...    )
Dict{String,Any}(
    "descr" => Dict{String,Any}(
        "order" => "buy 0.00100000 XBTUSD @ market",
    ),
    "txid" => ["T4HSG14-TYRCOC-7SWPQ0"]
)
```
"""
function create_order(client::SpotBaseRESTAPI;
    ordertype::String,
    side::String,
    pair::String,
    volume::Union{Float64,Int64,String},
    price::Union{Float64,Int64,String,Nothing}=nothing,
    price2::Union{Float64,Int64,String,Nothing}=nothing,
    trigger::Union{String,Nothing}=nothing,
    leverage::Union{Float64,Int64,String,Nothing}=nothing,
    stp_type::String="cancel-newest",
    oflags::Union{String,Vector{String},Nothing}=nothing,
    timeinforce::Union{String,Nothing}=nothing,
    starttm::String="0",
    expiretim::String="0",
    close_ordertype::Union{String,Nothing}=nothing,
    close_price::Union{String,Nothing}=nothing,
    close_price2::Union{String,Nothing}=nothing,
    deadline::Union{String,Nothing}=nothing,
    validate::Bool=false,
    reduce_only::Bool=false,
    displayvol::Union{Float64,Int64,String,Nothing}=nothing,
    userref::Union{Int32,Nothing}=nothing
)
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

    !isnothing(price) ? params["price"] = price : nothing
    !isnothing(price2) ? params["price2"] = price2 : nothing
    !isnothing(leverage) ? params["leverage"] = leverage : nothing
    !isnothing(oflags) ? params["oflags"] = vector_to_string(oflags) : nothing
    !isnothing(close_ordertype) ? params["close_ordertype"] = close_ordertype : nothing
    !isnothing(close_price) ? params["close_price"] = close_price : nothing
    !isnothing(close_price2) ? params["close_price2"] = close_price2 : nothing
    !isnothing(deadline) ? params["deadline"] = deadline : nothing
    !isnothing(userref) ? params["userref"] = userref : nothing
    !isnothing(displayvol) ? params["displayvol"] = displayvol : nothing
    !isnothing(timeinforce) ? params["timeinforce"] = timeinforce : nothing
    !isnothing(trigger) ? params["trigger"] = trigger : nothing
    (reduce_only) ? params["reduce_only"] = reduce_only : nothing
    return request(client, "POST", "/private/AddOrder", data=params, auth=true)
end

"""
    create_order_batch(client::SpotBaseRESTAPI;
        orders::Vector{Dict{String,Any}},
        pair::String,
        deadline::Union{String,Nothing}=nothing,
        validate::Bool=false
    )

Kraken Docs: [https://docs.kraken.com/rest/#operation/addOrderBatch](https://docs.kraken.com/rest/#operation/addOrderBatch)

Enables placing multiple orders and order-specific actions at once.

Authenticated `client` required

The `validate` key can be submitted to orders to simulate the result (see [`create_order`](@ref)).

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(
...        create_order_batch(
...            client,
...            orders=[
...                Dict{String,Any}(
...                    "close" => Dict{String,Any}(
...                        "ordertype" => "stop-loss-limit",
...                       "price" => 1000,
...                       "price2" => 900
...                   ),
...                   "ordertype" => "limit",
...                   "price" => 40000,
...                   "timeinforce" => "GTC",
...                   "type" => "buy",
...                   "userref" => Int32(123),
...                   "volume" => 2
...                ),
...                Dict{String,Any}(
...                    "ordertype" => "limit",
...                    "price" => 42000,
...                    "starttm" => "1668455555",
...                    "timeinforce" => "GTC",
...                    "type" => "sell",
...                    "userref" => Int32(999),
...                    "volume" => 5
...                ),
...                Dict{String,Any}(
...                    "ordertype" => "market",
...                    "volume" => 2,
...                    "type" => "buy"
...                ),
...                Dict{String,Any}(
...                    "ordertype" => "limit",
...                    "price" => 43000,
...                    "starttm" => "1668455555",
...                    "timeinforce" => "GTC",
...                    "type" => "sell",
...                    "userref" => Int32(999),
...                    "volume" => 5
...                )
...            ],
...            pair="XBTUSD",
...        )
...    )
...)
Dict{String, Any}(
    "orders" => Any[
        Dict{String, Any}(
            "descr" => Dict{String, Any}(
                "order" => "buy 2.00000000 XBTUSD @ limit 40000.0",
                "close" => "close position @ stop loss 1000.0 -> limit 900.0",
                "txid" => "N5F2Y6-E898J5-8Y6QE0"
            )
        ),
        Dict{String, Any}(
            "descr" => Dict{String, Any}(
                "order" => "sell 5.00000000 XBTUSD @ limit 42000.0",
                "txid" => "3YHGOT-P82PNP-D9DY85"
            )
        ),
        Dict{String, Any}(
            "descr" => Dict{String, Any}(
                "order" => "buy 2.00000000 XBTUSD @ market",
                "txid" => "IZXJ1O-9HER70-XJ0PCD"
            )
        ),
        Dict{String, Any}(
            "descr" => Dict{String, Any}(
                "order" => "sell 5.00000000 XBTUSD @ limit 43000.0",
                "txid" => "3YHGOT-P82PNP-D9DY85"
            )
        )
    ]
)
```
"""
function create_order_batch(client::SpotBaseRESTAPI;
    orders::Vector{Dict{String,Any}},
    pair::String,
    deadline::Union{String,Nothing}=nothing,
    validate::Bool=false
)
    params = Dict{String,Any}(
        "orders" => orders,
        "pair" => pair,
        "validate" => validate
    )
    !isnothing(deadline) ? params["deadline"] = deadline : nothing
    return request(client, "POST", "/private/AddOrderBatch", data=params, auth=true, do_json=true)
end

"""
    edit_order(client::SpotBaseRESTAPI;
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

Kraken Docs: [https://docs.kraken.com/rest/#operation/editOrder](https://docs.kraken.com/rest/#operation/editOrder)

Enables the editing of a placed order by `txid`.

Authenticated `client` required

# Arguments
`validate::Bool=false` -- Simulates order placement if set to `true`
...

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(
...        edit_order(
...            client,
...            txid="O2JLFP-VYFIW-35ZAAE",
...            pair="XBTUSD",
...            volume=4.2,
...            price=17000
...        )
...    )
Dict{String, Any}(
    "status" => "ok",
    "originaltxid" => "O2JLFP-VYFIW-35ZAAE",
    "orders_cancelled" => 0,
    "descr" => Dict{String, Any}("order" => "Order edited")
)
```
"""
function edit_order(client::SpotBaseRESTAPI;
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
    return request(client, "POST", "/private/EditOrder", data=params, auth=true)
end

"""
    cancel_order(client::SpotBaseRESTAPI; txid::String)

Kraken Docs: [https://docs.kraken.com/rest/#operation/cancelOrder](https://docs.kraken.com/rest/#operation/cancelOrder)

Cancel an order by `txid`.

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(cancel_order(client, txid="O2JLFP-VYFIW-35ZAAE"))
```
"""
function cancel_order(client::SpotBaseRESTAPI; txid::String)
    return request(client, "POST", "/private/CancelOrder", data=Dict{String,Any}("txid" => txid), auth=true)
end

"""
    cancel_all_orders(client::SpotBaseRESTAPI)

Kraken Docs: [https://docs.kraken.com/rest/#operation/cancelAllOrders](https://docs.kraken.com/rest/#operation/cancelAllOrders)

Cancel all open orders.

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(cancel_all_orders(client))
```
"""
function cancel_all_orders(client::SpotBaseRESTAPI)
    return request(client, "POST", "/private/CancelAll", auth=true)
end

"""
    cancel_all_orders_after_x(client::SpotBaseRESTAPI; timeout::Int)

Kraken Docs: [https://docs.kraken.com/rest/#operation/cancelAllOrdersAfter](https://docs.kraken.com/rest/#operation/cancelAllOrdersAfter)

Cancel all open orders after `timeout` seconds. This can be used to avoid unwanted behavior in case of system instabilities. Set `timeout` to 0 to reset the timout.

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(cancel_all_orders_after_x(client, timeout=60))
Dict{String, Any}(
    "currentTime" => "2023-01-10T17:01:57Z",
    "triggerTime" => "2023-01-10T17:02:57Z"
)
julia> println(cancel_all_orders_after_x(client, timeout=0))
Dict{String, Any}(
    "currentTime" => "2023-01-10T17:01:59Z",
    "triggerTime" => "0"
)
```
"""
function cancel_all_orders_after_x(client::SpotBaseRESTAPI; timeout::Int)
    return request(client, "POST", "/private/CancelAllOrdersAfter", data=Dict{String,Any}("timeout" => timeout), auth=true)
end

"""
    cancel_order_batch(client::SpotBaseRESTAPI; orders::Vector{String})

Kraken Docs: [https://docs.kraken.com/rest/#operation/cancelOrderBatch](https://docs.kraken.com/rest/#operation/cancelOrderBatch)

Enables the cancellation of multiple orders by `txid`.

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(cancel_order_batch(
...        client,
...        orders=[
...            "O2JLFP-VYFIW-35ZAAE", "O523KJ-DO4M2-KAT243",
...            "OCDIAL-YC66C-DOF7HS", "OVFPZ2-DA2GV-VBFVVI"
...        ]
...    ))
```
"""
function cancel_order_batch(client::SpotBaseRESTAPI; orders::Vector{String})
    return request(client, "POST", "/private/CancelOrderBatch", data=Dict{String,Any}("orders" => orders), auth=true, do_json=true)
end

end