module FuturesTradeModule
using ..FuturesBaseAPIModule: FuturesBaseRESTAPI, request
using JSON: json

#======= E X P O R T S ========#
export get_fills
export create_batch_order
export cancel_all_orders
export dead_mans_switch
export cancel_order
export edit_order
export get_orders_status
export create_order

#======= F U N C T I O N S ========#
"""
    get_fills(client::FuturesBaseRESTAPI; lastFillTime::Union{Int64,String,Nothing}=nothing)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-historical-data-get-your-fills](https://docs.futures.kraken.com/#http-api-trading-v3-api-historical-data-get-your-fills)

Returns information about the user-specific fills of all Futures contracts.

Authenticated `client` required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(get_fills(client))
Dict{String,Any}(
    "result" => "success",
    "fills" => Any[Dict{String,Any}(
        "fill_id" => "3d57ed09-fbd6-44f1-8e8b-b10e551c5e73",
        "symbol" => "pi_xbtusd",
        "side" => "buy",
        "order_id" => "693af756-055e-47ef-99d5-bcf4c456ebc5",
        "size" => 5490,
        "price" => 9400,
        "fillTime" => "2020-07-22T13:37:27.077Z",
        "fillType" => "maker"
    ), ...],
    "serverTime" => "2020-07-22T13:44:24.311Z"
)
```
"""
function get_fills(client::FuturesBaseRESTAPI; lastFillTime::Union{Int64,String,Nothing}=nothing)
    params::Dict{String,Any} = Dict{String,Any}()
    isnothing(lastFillTime) ? nothing : params["lastFillTime"] = lastFillTime
    return request(client, "GET", "/derivatives/api/v3/fills", query_params=params, auth=true)
end

"""
    create_batch_order(client::FuturesBaseRESTAPI; batchorder_list::Vector{Dict{String,Any}})

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-batch-order-management](https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-batch-order-management)

Creates a batch of order instructions to create, edit or even cancel multiple orders at the same time.
Authenticated `client` required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(create_batch_order(
...        client, 
...        batchorder_list=[
...            Dict{String,Any}(
...                "order" => "send",
...                "order_tag" => "1",
...                "orderType" => "lmt",
...                "symbol" => "PI_XBTUSD",
...                "side" => "buy",
...                "size" => 2,
...                "limitPrice" => 15200.0,
...                "cliOrdId" => "my-another-client-id"
...            ),
...            Dict{String,Any}(
...                "order" => "send",
...                "order_tag" => "2",
...                "orderType" => "stp",
...                "symbol" => "PI_XBTUSD",
...                "side" => "buy",
...                "size" => 1,
...                "limitPrice" => 15100.0,
...                "stopPrice" => 15090.0,
...            ),
...            Dict{String,Any}(
...                "order" => "send",
...                "order_tag" => "3",
...                "orderType" => "stp",
...                "symbol" => "PI_XBTUSD",
...                "side" => "buy",
...                "size" => 3,
...                "limitPrice" => 15100.0,
...                "stopPrice" => 14900.0,
...            ),
...            Dict{String,Any}(
...                "order" => "cancel",
...                "order_id" => "f35a61dd-8a30-4d5f-a574-b5593ef0c050",
...            ),
...            Dict{String,Any}(
...                "order" => "cancel",
...                "cliOrdId" => "my_client_id1234"
...            )
...        ]))
...    
julia> # please see the linked Kraken Docs for response examples
```
"""
function create_batch_order(client::FuturesBaseRESTAPI; batchorder_list::Vector{Dict{String,Any}})
    return request(client, "POST", "/derivatives/api/v3/batchorder",
        post_params=Dict{String,Any}("batchOrder" => batchorder_list),
        auth=true,
        do_json=true
    )
end

"""
    cancel_all_orders(client::FuturesBaseRESTAPI; symbol::Union{String,Nothing}=nothing)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-cancel-all-orders](https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-cancel-all-orders)

Cancels all active orders of a user. 

Authenticated `client` required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(cancel_all_orders(client))
Dict{String,Any}(
    "result" => "success",
    "cancelStatus" => Dict{String,Any}(
        "receivedTime" => "2019-08-01T15:57:37.518Z",
        "cancelOnly" => "all",
        "status" => "cancelled",
        "cancelledOrders": Any[
            Dict{String,Any}("order_id" => "XXXXXXXX-XXX-XXXX-XXXX-XXXXXXXXXXXX"),
            Dict{String,Any}("order_id" => "XXXXXXXX-XXX-XXXX-XXXX-XXXXXXXXXXXX"),
            ...
        ],
        "orderEvents" => Any[Dict{String,Any}(
            "uid" => "XXXXXXXX-XXX-XXXX-XXXX-XXXXXXXXXXXX",
            "order" => Dict{String,Any}(
                "orderId" => "XXXXXXXX-XXX-XXXX-XXXX-XXXXXXXXXXXX",
                "cliOrdId" => null,
                "type" => "stp",
                "symbol" => "pi_xbtusd",
                "side" => "buy",
                "quantity" => 2001,
                "filled" => 0,
                "limitPrice" => 11031,
                "stopPrice" => 11031,
                "reduceOnly" => false,
                "timestamp" => "2022-08-01T15:57:19.482Z"
            ),
            "type": "CANCEL"
        ), ...]
    )
)
```
"""
function cancel_all_orders(client::FuturesBaseRESTAPI; symbol::Union{String,Nothing}=nothing)
    params::Dict{String,Any} = Dict{String,Any}()
    isnothing(symbol) ? nothing : params["symbol"] = symbol
    return request(client, "POST", "/derivatives/api/v3/cancelallorders", post_params=params, auth=true)
end

"""
    dead_mans_switch(client::FuturesBaseRESTAPI; timeout::Int=60)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-dead-man-39-s-switch](https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-dead-man-39-s-switch)

Enables the dead mans switch to prevent unwanted behaviour e.g. during system instabilities. Set `timeout=0` ro reset.

Authenticated `client` required

Set `timeout` to 0 to reset the death man switch.

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(dead_mans_switch(client, timeout=60))
Dict{String,Any}(
    "result" => "success",
    "status" => Dict{String,Any}(
        "currentTime" => "2018-06-19T16:51:23.839Z",
        "triggerTime" => "60"
    ),
    "serverTime" => "2018-06-19T16:51:23.839Z"
)
julia> println(dead_mans_switch(client, timeout=0))
Dict{String,Any}(
    "result" => "success",
    "status" => Dict{String,Any}(
        "currentTime" => "2018-06-19T16:51:23.839Z",
        "triggerTime" => "0"
    ),
    "serverTime" => "2018-06-19T16:51:23.839Z"
)
```
"""
function dead_mans_switch(client::FuturesBaseRESTAPI; timeout::Int=60)
    return request(client, "POST", "/derivatives/api/v3/cancelallordersafter", post_params=Dict{String,Any}(
            "timeout" => timeout
        ), auth=true)
end

"""
    cancel_order(client::FuturesBaseRESTAPI;
        order_id::Union{String,Nothing}=nothing,
        cliOrdId::Union{String,Nothing}=nothing
    )

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-cancel-order](https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-cancel-order)

Cancels an order by `order_id` or `cliOrdId`.

Authenticated `client` required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(cancel_order(client, order_id="XXXXXXXX-XXX-XXXX-XXXX-XXXXXXXXXXXX"))
Dict{String,Any}(
    "result" => "success",
    "cancelStatus" => Dict{String,Any}(
        "status" => "cancelled",
        "order_id" => ""XXXXXXXX-XXX-XXXX-XXXX-XXXXXXXXXXXX,
        "cancelOnly" => "all",
        "receivedTime" => "2019-08-01T15:57:37.518Z",
        "orderEvents" => Any[Dict{String,Any}(
            "uid" => "XXXXXXXX-XXX-XXXX-XXXX-XXXXXXXXXXXX",
            "order" => Dict{String,Any}(
                "orderId" => "XXXXXXXX-XXX-XXXX-XXXX-XXXXXXXXXXXX",
                "cliOrdId" => null,
                "type" => "stp",
                "symbol" => "pi_xbtusd",
                "side" => "buy",
                "quantity" => 2001,
                "filled" => 0,
                "limitPrice" => 11031,
                "stopPrice" => 11031,
                "reduceOnly" => false,
                "timestamp" => "2022-08-01T15:57:19.482Z"
            ),
            "type": "CANCEL"
        ), ...]
    )
)
```
"""
function cancel_order(client::FuturesBaseRESTAPI;
    order_id::Union{String,Nothing}=nothing,
    cliOrdId::Union{String,Nothing}=nothing
)
    params::Dict{String,Any} = Dict{String,Any}()
    if !isnothing(order_id)
        params["order_id"] = order_id
    elseif !isnothing(cliOrdId)
        params["cliOrdId"] = cliOrdId
    else
        error("cancel_order: Either `order_id` or `cliOrdId` must be set!")
    end
    return request(client, "POST", "/derivatives/api/v3/cancelorder", post_params=params, auth=true)
end

"""
    edit_order(client::FuturesBaseRESTAPI;
        orderId::Union{String,Nothing}=nothing,
        cliOrdId::Union{String,Nothing}=nothing,
        limitPrice::Union{String,Float64,Int64,Nothing}=nothing,
        size::Union{String,Float64,Int64,Nothing}=nothing,
        stopPrice::Union{String,Float64,Int64,Nothing}=nothing
    )

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-edit-order](https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-edit-order)

Enables editing placed orders which are still open.

Authenticated `client` required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(edit_order(client,
...        orderId="XXXXXXXX-XXX-XXXX-XXXX-XXXXXXXXXXXX",
...        size=2,
...        limitPrice=16000,
...    ))
Dict{String,Any}(
    "result" => "success",
    "serverTime" => "2022-09-05T16:47:47.521Z",
    "editStatus" => Dict{String,Any}(
        "status" => "edited",
        "orderId" => "XXXXXXXX-XXX-XXXX-XXXX-XXXXXXXXXXXX",
        "receivedTime" => "2022-09-05T16:47:47.521Z",
        "orderEvents" => Any[
            Dict{String,Any}(
                "old" => Dict{String,Any}(
                    "orderId" => "XXXXXXXX-XXX-XXXX-XXXX-XXXXXXXXXXXX",
                    "cliOrdId" => null,
                    "type" => "lmt",
                    "symbol" => "pi_xbtusd",
                    "side" => "buy",
                    "quantity" => 1,
                    "filled": => 0,
                    "limitPrice" => 17000.0,
                    "reduceOnly" => false,
                    "timestamp" => "2022-09-05T16:41:35.173Z",
                    "lastUpdateTimestamp" => "2019-09-05T16:41:35.173Z"
                )
                "new" => Dict{String,Any}(
                    "orderId" => "XXXXXXXX-XXX-XXXX-XXXX-XXXXXXXXXXXX",
                    "cliOrdId" => null,
                    "type" => "lmt",
                    "symbol" => "pi_xbtusd",
                    "side" => "buy",
                    "quantity" => 2,
                    "filled" => 0,
                    "limitPrice" => 16000.0,
                    "reduceOnly" => false,
                    "timestamp" => "2022-09-05T16:41:35.173Z",
                    "lastUpdateTimestamp" => "2019-09-05T16:47:47.519Z"
                ),
                "reducedQuantity": null,
                "type": "EDIT"
            )
        ]
    )
)
```
"""
function edit_order(client::FuturesBaseRESTAPI;
    orderId::Union{String,Nothing}=nothing,
    cliOrdId::Union{String,Nothing}=nothing,
    limitPrice::Union{String,Float64,Int64,Nothing}=nothing,
    size::Union{String,Float64,Int64,Nothing}=nothing,
    stopPrice::Union{String,Float64,Int64,Nothing}=nothing
)
    params::Dict{String,Any} = Dict{String,Any}()
    if !isnothing(orderId)
        params["orderId"] = orderId
    elseif !isnothing(cliOrdId)
        params["cliOrdId"] = cliOrdId
    else
        error("edit_order: Either `orderId` or `cliOrdId` must be set!")
    end
    isnothing(limitPrice) ? nothing : params["limitPrice"] = limitPrice
    isnothing(size) ? nothing : params["size"] = size
    isnothing(stopPrice) ? nothing : params["stopPrice"] = stopPrice
    return request(client, "POST", "/derivatives/api/v3/editorder", post_params=params, auth=true)
end

"""
    get_orders_status(client::FuturesBaseRESTAPI;
        orderIds::Union{Vector{String},Nothing}=nothing,
        cliOrdIds::Union{Vector{String},Nothing}=nothing
    )

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-get-the-current-status-for-specific-orders](https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-get-the-current-status-for-specific-orders)

Get information about (a) specific order(s) using `orderIds` or `cliOrdIds`. 

Authenticated `client` required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(get_orders_status(client, orderIds=["orderid1", "orderid2"]))
Dict{String,Any}(
    "orders" => Any[Dict{String,Any}
      "error" => "MARKET_SUSPENDED",
      "order" => {
        "cliOrdId" => "someniceid",
        "filled" => 0.1,
        "lastUpdateTimestamp": "2021-08-26T17:03:33.196Z",
        "limitPrice": 2,
        "orderId": "orderid1",
        "priceTriggerOptions": {
          "triggerPrice": 1,
          "triggerSide": "TRIGGER_ABOVE",
          "triggerSignal": "MARK_PRICE"
        },
        "quantity": 5,
        "reduceOnly": false,
        "side": "buy",
        "symbol": "DOTUSD",
        "timestamp": "2021-08-27T17:03:33.196Z",
        "type": "TRIGGER_ORDER"
      },
      "status": "ENTERED_BOOK",
      "updateReason": "LOADING_MARKET"
    }
  ],
  "result": "success",
  "serverTime": "2022-08-27T17:03:33.196Z"
)
```
"""
function get_orders_status(client::FuturesBaseRESTAPI;
    orderIds::Union{Vector{String},Nothing}=nothing,
    cliOrdIds::Union{Vector{String},Nothing}=nothing
)
    params::Dict{String,Any} = Dict{String,Any}()
    if !isnothing(orderIds)
        params["orderIds"] = orderIds
    elseif !isnothing(cliOrdIds)
        params["cliOrdIds"] = cliOrdIds
    else
        error("get_orders_status: Either `orderIds` or `cliOrdIds` must be set!")
    end
    return request(client, "POST", "/derivatives/api/v3/orders/status", post_params=params, auth=true)
end

"""
    create_order(client::FuturesBaseRESTAPI;
        orderType::String,
        side::String,
        size::Union{Float64,Int64,String},
        symbol::String,
        cliOrdId::Union{String,Nothing}=nothing,
        limitPrice::Union{String,Float64,Int64,Nothing}=nothing,
        stopPrice::Union{String,Float64,Int64,Nothing}=nothing,
        reduceOnly::Union{Bool,Nothing}=nothing,
        triggerSignal::Union{String,Nothing}=nothing
    )

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-send-order](https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-send-order)

Creates/places an order. 

Authenticated `client` required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(create_order(client,
...         orderType="lmt",
...         side="buy",
...         size=1,
...         limitPrice=16000.0,
...         symbol="PI_XBTUSD",
...     ))
Dict{String,Any}(
    "result" => "success",
    "sendStatus" => Dict{String,Any}(
        "order_id" => "XXXXXXXX-XXX-XXXX-XXXX-XXXXXXXXXXXX",
        "status" => "placed",
        "receivedTime" => "2022-12-11T17:17:33.888Z",
        "orderEvents": Any[Dict{String,Any}(
            "executionId" => "XXXXX0XX-XXX-XXXX-XXXX-XXXXXXXXXXXX",
            "price" => 17000.0,
            "amount" => 1,
            "orderPriorEdit" => null,
            "orderPriorExecution" => Dict{String,Any}(
                    "orderId" => "XXXXXXXX-XXX-XXXX-XXXX-XXXXXXXXXXXX",
                    "cliOrdId" => null,
                    "type" => "lmt",
                    "symbol" => "pi_xbtusd",
                    "side" => "buy",
                    "quantity" => 1,
                    "filled" => 0,
                    "limitPrice" => 16000.0,
                    "reduceOnly" => false,
                    "timestamp" => "2012-12-11T17:17:33.888Z",
                    "lastUpdateTimestamp" => "2012-12-11T17:17:33.888Z"
            ),
            "takerReducedQuantity" => null,
            "type" => "EXECUTION"
        )]
    ),
    "serverTime": "2019-12-11T17:17:33.888Z"
)
```
"""
function create_order(client::FuturesBaseRESTAPI;
    orderType::String,
    side::String,
    size::Union{Float64,Int64,String},
    symbol::String,
    cliOrdId::Union{String,Nothing}=nothing,
    limitPrice::Union{String,Float64,Int64,Nothing}=nothing,
    stopPrice::Union{String,Float64,Int64,Nothing}=nothing,
    reduceOnly::Union{Bool,Nothing}=nothing,
    triggerSignal::Union{String,Nothing}=nothing
)
    otypes = ["lmt", "post", "ioc", "mkt", "stp", "take_profit"]
    orderType ∉ otypes ? error("create_order: `orderType` must be one of $otypes") : nothing
    sides = ["buy", "sell"]
    side ∉ sides ? error("create_order: `side` must be one of $sides") : nothing

    params::Dict{String,Any} = Dict{String,Any}(
        "orderType" => orderType,
        "side" => side,
        "size" => size,
        "symbol" => symbol
    )

    isnothing(cliOrdId) ? nothing : params["cliOrdId"] = cliOrdId
    isnothing(reduceOnly) ? nothing : params["reduceOnly"] = reduceOnly
    if !isnothing(triggerSignal)
        tsignals = ["mark", "spot", "last"]
        triggerSignal ∉ tsignals ? error("create_order: `triggerSignal` must be one of $tsignals") : params["triggerSignal"] = triggerSignal
    end
    if orderType ∈ ["post", "lmt"]
        isnothing(limitPrice) ? error("create_order: $orderType requires a `limitPrice`") : params["limitPrice"] = limitPrice
    elseif orderType ∈ ["stp", "take_profit"]
        isnothing(stopPrice) ? error("create_order: `stopPrice` must be specified when using `orderType` $orderType") : params["stopPrice"] = stopPrice
    end
    return request(client, "POST", "/derivatives/api/v3/sendorder", post_params=params, auth=true)
end

end