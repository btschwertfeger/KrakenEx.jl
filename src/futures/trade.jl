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

https://docs.futures.kraken.com/#http-api-trading-v3-api-historical-data-get-your-fills
"""
function get_fills(client::FuturesBaseRESTAPI; lastFillTime::Union{Int64,String,Nothing}=nothing)
    params::Dict{String,Any} = Dict{String,Any}()
    isnothing(lastFillTime) ? nothing : params["lastFillTime"] = lastFillTime
    return request(client, "GET", "/derivatives/api/v3/fills", query_params=params, auth=true)
end

"""
    create_batch_order(client::FuturesBaseRESTAPI; batchorder_list::Vector{Dict{String,Any}})

https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-batch-order-management
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

https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-cancel-all-orders
"""
function cancel_all_orders(client::FuturesBaseRESTAPI; symbol::Union{String,Nothing}=nothing)
    params::Dict{String,Any} = Dict{String,Any}()
    isnothing(symbol) ? nothing : params["symbol"] = symbol
    return request(client, "POST", "/derivatives/api/v3/cancelallorders", post_params=params, auth=true)
end

"""
    dead_mans_switch(client::FuturesBaseRESTAPI; timeout::Int=60)

https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-dead-man-39-s-switch
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

https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-cancel-order
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

https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-edit-order
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

https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-get-the-current-status-for-specific-orders
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

https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-send-order
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