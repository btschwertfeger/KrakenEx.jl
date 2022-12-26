module KrakenSpotUserModule

using ..KrakenSpotBaseAPIModule
using ..Utils

#======= E X P O R T S ========#
export get_account_balance
export get_trade_balance
export get_open_orders
#======= F U N C T I O N S ========#

function get_account_balance(client::SpotBaseRESTAPI)
    """https://docs.kraken.com/rest/#operation/getAccountBalance"""
    return request(client, "POST", "/private/Balance"; auth=true)
end

function get_trade_balance(client::SpotBaseRESTAPI; asset::Union{String,Nothing}=nothing)
    """https://docs.kraken.com/rest/#operation/getTradeBalance"""
    params = Dict()
    !isnothing(asset) ? params["asset"] = asset : nothing
    return request(client, "POST", "/private/TradeBalance"; data=params, auth=true)
end

function get_open_orders(client::SpotBaseRESTAPI; trades::Bool=false, userref::Union{Int64,Nothing}=nothing)
    """https://docs.kraken.com/rest/#operation/getOpenOrders"""
    params = Dict{String,Any}(["trades" => bool_to_string(trades)])
    !isnothing(userref) ? params["userref"] = userref : nothing
    return request(client, "POST", "/private/OpenOrders"; data=params, auth=true)
end


end