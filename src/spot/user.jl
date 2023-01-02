module SpotUserModule

using ..SpotBaseAPIModule: SpotBaseRESTAPI, request
using ..Utils

#======= E X P O R T S ========#
export get_account_balance
export get_trade_balance
export get_open_orders
export get_closed_orders
export get_orders_info
export get_trades_history
export get_trades_info
export get_open_positions
export get_ledgers_info
export get_ledgers
export get_trade_volume
export request_export_report
export get_export_report_status
export retrieve_export
export delete_export_report
export get_websockets_token

#======= F U N C T I O N S ========#
"""
    get_account_balance(client::SpotBaseRESTAPI)

https://docs.kraken.com/rest/#operation/getAccountBalance
"""
function get_account_balance(client::SpotBaseRESTAPI)
    return request(client, "POST", "/private/Balance"; auth=true)
end

"""
    get_trade_balance(client::SpotBaseRESTAPI; asset::Union{String,Nothing}=nothing)

https://docs.kraken.com/rest/#operation/getTradeBalance
"""
function get_trade_balance(client::SpotBaseRESTAPI; asset::Union{String,Nothing}=nothing)
    params = Dict{String,Any}()
    !isnothing(asset) ? params["asset"] = asset : nothing
    return request(client, "POST", "/private/TradeBalance"; data=params, auth=true)
end

"""
    get_open_orders(client::SpotBaseRESTAPI; trades::Bool=false, userref::Union{Int64,Nothing}=nothing)

https://docs.kraken.com/rest/#operation/getOpenOrders
"""
function get_open_orders(client::SpotBaseRESTAPI; trades::Bool=false, userref::Union{Int64,Nothing}=nothing)
    params = Dict{String,Any}("trades" => string(trades))
    !isnothing(userref) ? params["userref"] = userref : nothing
    return request(client, "POST", "/private/OpenOrders"; data=params, auth=true)
end

"""
    get_closed_orders(client::SpotBaseRESTAPI;
        trades::Bool=false,
        userref::Union{Int64,Nothing}=nothing,
        start::Union{Int64,Nothing}=nothing,
        end_::Union{Int64,Nothing}=nothing,
        ofs::Union{Int64,String,Nothing}=nothing,
        closetime::String="both"
    )

https://docs.kraken.com/rest/#operation/getClosedOrders
"""
function get_closed_orders(client::SpotBaseRESTAPI;
    trades::Bool=false,
    userref::Union{Int64,Nothing}=nothing,
    start::Union{Int64,Nothing}=nothing,
    end_::Union{Int64,Nothing}=nothing,
    ofs::Union{Int64,String,Nothing}=nothing,
    closetime::String="both"
)
    params = Dict{String,Any}(
        "trades" => string(trades),
        "closetime" => closetime
    )
    !isnothing(userref) ? params["userref"] = userref : nothing
    !isnothing(start) ? params["start"] = start : nothing
    !isnothing(end_) ? params["end"] = end_ : nothing
    !isnothing(ofs) ? params["ofs"] = ofs : nothing
    return request(client, "POST", "/private/ClosedOrders"; data=params, auth=true)
end

"""
    get_orders_info(client::SpotBaseRESTAPI;
        txid::Union{String,Vector{String}},
        trades::Bool=false,
        userref::Union{Int64,Nothing}=nothing
    )

https://docs.kraken.com/rest/#tag/User-Data/operation/getOrdersInfo
"""
function get_orders_info(client::SpotBaseRESTAPI;
    txid::Union{String,Vector{String}},
    trades::Bool=false,
    userref::Union{Int64,Nothing}=nothing
)
    params = Dict{String,Any}(
        "txid" => vector_to_string(txid),
        "trades" => string(trades)
    )
    !isnothing(userref) ? params["userref"] = userref : nothing
    return request(client, "POST", "/private/QueryOrders"; data=params, auth=true)
end

"""
    get_trades_history(client::SpotBaseRESTAPI;
        type::String="all",
        trades::Bool=false,
        start::Union{Int64,Nothing}=nothing,
        end_::Union{Int64,Nothing}=nothing,
        ofs::Union{String,Int64,Nothing}=nothing
    )

https://docs.kraken.com/rest/#operation/getTradeHistory
"""
function get_trades_history(client::SpotBaseRESTAPI;
    type::String="all",
    trades::Bool=false,
    start::Union{Int64,Nothing}=nothing,
    end_::Union{Int64,Nothing}=nothing,
    ofs::Union{String,Int64,Nothing}=nothing
)
    params = Dict{String,Any}(
        "type" => type,
        "trades" => string(trades)
    )
    !isnothing(start) ? params["start"] = start : nothing
    !isnothing(end_) ? params["end"] = end_ : nothing
    !isnothing(ofs) ? params["ofs"] = ofs : nothing
    return request(client, "POST", "/private/TradesHistory"; data=params, auth=true)
end

"""
    get_trades_info(client::SpotBaseRESTAPI; txid::Union{String,Vector{String}}, trades::Bool=false)

https://docs.kraken.com/rest/#operation/getTradesInfo
"""
function get_trades_info(client::SpotBaseRESTAPI; txid::Union{String,Vector{String}}, trades::Bool=false)
    return request(client, "POST", "/private/QueryTrades"; data=Dict{String,Any}(
            "txid" => vector_to_string(txid),
            "trades" => string(trades)
        ), auth=true)
end

"""
    get_open_positions(client::SpotBaseRESTAPI;
        txid::Union{String,Vector{String},Nothing}=nothing,
        docalcs::Bool=false,
        consolidation::String="market"
    )

https://docs.kraken.com/rest/#operation/getOpenPositions
"""
function get_open_positions(client::SpotBaseRESTAPI;
    txid::Union{String,Vector{String},Nothing}=nothing,
    docalcs::Bool=false,
    consolidation::String="market"
)
    params = Dict{String,Any}(
        "docalcs" => string(docalcs),
        "consolidation" => consolidation
    )
    !isnothing(txid) ? params["txid"] = vector_to_string(txid) : nothing
    return request(client, "POST", "/private/OpenPositions"; data=params, auth=true)
end

"""
    get_ledgers_info(client::SpotBaseRESTAPI;
        asset::Union{String,Vector{String}}="all",
        aclass::String="currency",
        type::String="all",
        start::Union{Int64,Nothing}=nothing,
        end_::Union{Int64,Nothing}=nothing,
        ofs::Union{Int64,String,Nothing}=nothing
    )

https://docs.kraken.com/rest/#operation/getLedgers
"""
function get_ledgers_info(client::SpotBaseRESTAPI;
    asset::Union{String,Vector{String}}="all",
    aclass::String="currency",
    type::String="all",
    start::Union{Int64,Nothing}=nothing,
    end_::Union{Int64,Nothing}=nothing,
    ofs::Union{Int64,String,Nothing}=nothing
)
    params = Dict{String,Any}(
        "asset" => vector_to_string(asset),
        "aclass" => aclass,
        "type" => type,
    )
    !isnothing(start) ? params["start"] = start : nothing
    !isnothing(end_) ? params["end"] = end_ : nothing
    !isnothing(ofs) ? params["ofs"] = ofs : nothing
    return request(client, "POST", "/private/Ledgers"; data=params, auth=true)
end

"""
    get_ledgers(client::SpotBaseRESTAPI; id::Union{String,Vector{String}}, trades::Bool=false)

https://docs.kraken.com/rest/#operation/getLedgersInfo
"""
function get_ledgers(client::SpotBaseRESTAPI; id::Union{String,Vector{String}}, trades::Bool=false)
    params = Dict{String,Any}(
        "id" => vector_to_string(id),
        "trades" => string(trades)
    )
    return request(client, "POST", "/private/QueryLedgers"; data=params, auth=true)
end

"""
    get_trade_volume(client::SpotBaseRESTAPI; pair::Union{String,Vector{String},Nothing}=nothing, fee_info::Bool=true)

https://docs.kraken.com/rest/#operation/getTradeVolume
"""
function get_trade_volume(client::SpotBaseRESTAPI; pair::Union{String,Vector{String},Nothing}=nothing, fee_info::Bool=true)
    params = Dict{String,Any}("fee_info" => string(fee_info))
    !isnothing(pair) ? params["pair"] = vector_to_string(pair) : nothing
    return request(client, "POST", "/private/TradeVolume"; data=params, auth=true)
end

"""
    request_export_report(client::SpotBaseRESTAPI;
        report::String,
        description::String,
        format::String="CSV",
        fields::String="all",
        starttm::Union{Int64,Nothing}=nothing,
        endtm::Union{Int64,Nothing}=nothing
    )

https://docs.kraken.com/rest/#operation/addExport
==== RESPONSE ====
    id => INSG
"""
function request_export_report(client::SpotBaseRESTAPI;
    report::String,
    description::String,
    format::String="CSV",
    fields::String="all",
    starttm::Union{Int64,Nothing}=nothing,
    endtm::Union{Int64,Nothing}=nothing
)
    report ∉ ["trades", "ledgers"] ? error("`report` must be one of \"trades\" or \"ledgers\"") : nothing
    params = Dict{String,Any}(
        "report" => report,
        "description" => description,
        "format" => format,
        "fields" => fields
    )
    !isnothing(starttm) ? params["starttm"] = starttm : nothing
    !isnothing(endtm) ? params["endtm"] = endtm : nothing
    return request(client, "POST", "/private/AddExport"; data=params, auth=true)
end

"""
    get_export_report_status(client::SpotBaseRESTAPI; report::String)

https://docs.kraken.com/rest/#operation/exportStatus
"""
function get_export_report_status(client::SpotBaseRESTAPI; report::String)
    report ∉ ["trades", "ledgers"] ? error("`report` must be one of \"trades\" or \"ledgers\"") : nothing
    return request(client, "POST", "/private/ExportStatus"; data=Dict{String,Any}("report" => report), auth=true)
end

"""
    retrieve_export(client::SpotBaseRESTAPI; id::String)

https://docs.kraken.com/rest/#operation/retrieveExport
"""
function retrieve_export(client::SpotBaseRESTAPI; id::String)
    return request(client, "POST", "/private/RetrieveExport"; data=Dict{String,Any}("id" => id), auth=true, return_raw=true)
end

"""
    delete_export_report(client::SpotBaseRESTAPI; id::String, type::String)

https://docs.kraken.com/rest/#operation/removeExport

type can be `delete` or `cancel`
"""
function delete_export_report(client::SpotBaseRESTAPI; id::String, type::String)
    return request(client, "POST", "/private/RemoveExport"; data=Dict{String,Any}(
            "id" => id,
            "type" => type
        ), auth=true)
end

"""
    get_websockets_token(client::SpotBaseRESTAPI)

https://docs.kraken.com/rest/#tag/Websockets-Authentication
"""
function get_websockets_token(client::SpotBaseRESTAPI)
    return request(client, "POST", "/private/GetWebSocketsToken", auth=true)
end
end