module KrakenSpotTradeModule

using ..KrakenSpotBaseAPIModule
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
function create_order(client::SpotBaseRESTAPI;
    ordertype::String,
    side::String,
    volume::Union{Float64,Int64,String},
    pair::String,
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
    userref::Union{Int32,Nothing}=nothing
)
    """https://docs.kraken.com/rest/#operation/addOrder"""
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
    return request(client, "POST", "/private/AddOrder", data=params, auth=true)
end

function create_order_batch(client::SpotBaseRESTAPI;
    orders::Vector{Dict{String,Any}},
    pair::String,
    deadline::Union{String,Nothing}=nothing,
    validate::Bool=false
)
    """https://docs.kraken.com/rest/#operation/addOrderBatch"""
    params = Dict{String,Any}(
        "orders" => orders,
        "pair" => pair,
        "validate" => validate
    )
    !isnothing(deadline) ? params["deadline"] = deadline : nothing
    return request(client, "POST", "/private/AddOrderBatch", data=params, auth=true, do_json=true)
end

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
    """https://docs.kraken.com/rest/#operation/editOrder"""
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


function cancel_order(client::SpotBaseRESTAPI; txid::String)
    """https://docs.kraken.com/rest/#operation/cancelOrder"""
    return request(client, "POST", "/private/CancelOrder", data=Dict{String,Any}("txid" => txid), auth=true)
end

function cancel_all_orders(client::SpotBaseRESTAPI)
    """https://docs.kraken.com/rest/#operation/cancelAllOrders"""
    return request(client, "POST", "/private/CancelAll", auth=true)
end

function cancel_all_orders_after_x(client::SpotBaseRESTAPI; timeout::Int)
    """https://docs.kraken.com/rest/#operation/cancelAllOrdersAfter"""
    return request(client, "POST", "/private/CancelAllOrdersAfter", data=Dict{String,Any}("timeout" => timeout), auth=true)
end

function cancel_order_batch(client::SpotBaseRESTAPI; orders::Vector{String})
    """https://docs.kraken.com/rest/#operation/cancelOrderBatch"""
    return request(client, "POST", "/private/CancelOrderBatch", data=Dict{String,Any}("orders" => orders), auth=true, do_json=true)
end

end