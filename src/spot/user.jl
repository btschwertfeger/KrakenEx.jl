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

Kraken Docs: [https://docs.kraken.com/rest/#operation/getAccountBalance](https://docs.kraken.com/rest/#operation/getAccountBalance)

Returns the actual balances of all currencies.

Authenticated `client` required

# Examples
```julia-repl 
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(get_account_balance(client))
Dict{String, Any}(
    "KFEE" => "9431.54", 
    "BCH" => "123.0000077100",
    "ZUSD" => "798.5491", 
    "XETH" => "14.0119368320", 
    "DOT" => "671.0153183000", 
    "ZEUR" => "101.12000", 
    "XXBT" => "1.0011888110", 
    "XXLM" => "2030121.00001212", 
    "EOS" => "24.0000065500", 
    "TRX" => "9121230.00000000"
)
```
"""
function get_account_balance(client::SpotBaseRESTAPI)
    return request(client, "POST", "/private/Balance"; auth=true)
end

"""
    get_trade_balance(client::SpotBaseRESTAPI; asset::Union{String,Nothing}=nothing)

Kraken Docs: [https://docs.kraken.com/rest/#operation/getTradeBalance](https://docs.kraken.com/rest/#operation/getTradeBalance)

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(get_trade_balance(client))
Dict{String, Any}(
    "v" => "0.0000", 
    "tb" => "113145.4781", 
    "mf" => "113145.4781", 
    "uv" => "0.0000", 
    "m" => "0.0000", 
    "c" => "0.0000", 
    "e" => "113112.4781",
    "eb" => "116412.4143", 
    "n" => "0.0000"
)
julia> println(get_trade_balance(client, asset="DOT"))
Dict{String, Any}(
    "v" => "0.0000000000", 
    "tb" => "2301.0859297648", 
    "mf" => "2301.0859297648", 
    "uv" => "0.0000000000", 
    "m" => "0.0000000000", 
    "c" => "0.0000000000", 
    "e" => "2301.0859297648", 
    "eb" => "2367.7876343538", 
    "n" => "0.0000000000"
)
```
"""
function get_trade_balance(client::SpotBaseRESTAPI; asset::Union{String,Nothing}=nothing)
    params = Dict{String,Any}()
    !isnothing(asset) ? params["asset"] = asset : nothing
    return request(client, "POST", "/private/TradeBalance"; data=params, auth=true)
end

"""
    get_open_orders(client::SpotBaseRESTAPI; trades::Bool=false, userref::Union{Int64,Nothing}=nothing)

Kraken Docs: [https://docs.kraken.com/rest/#operation/getOpenOrders](https://docs.kraken.com/rest/#operation/getOpenOrders)

Retrurns the actual open orders.

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(get_open_orders(client))
Dict{String, Any}(
    "open" => Dict{String, Any}(
        "OAQZLS-7SFKK-PAA6BW" => Dict{String, Any}(
            "price" => "0.00000", 
            "vol" => "20.11513967", 
            "status" => "open", 
            "vol_exec" => "0.00000000", 
            "oflags" => "fciq", 
            "starttm" => 0, 
            "stopprice" => "0.00000", 
            "refid" => nothing, 
            "userref" => 0, 
            "expiretm" => 0, 
            "cost" => "0.00000", 
            "fee" => "0.00000",
            "misc" => "", 
            "limitprice" => "0.00000", 
            "opentm" => 1.6678760796400564e9, 
            "descr" => Dict{String, Any}(
                "ordertype" => "limit", 
                "price" => "7.1288", 
                "pair" => "DOTUSD", 
                "order" => "sell 20.11513967 DOTUSD @ limit 7.1288", 
                "leverage" => "none", 
                "type" => "sell", 
                "close" => "", 
                "price2" => "0"
            )
        ), 
        "OPNPFB-NRZY3-O6T46Y" => Dict{String, Any}(
            "price" => "0.00000", 
            ...
        )
    )
)
```
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

Kraken Docs: [https://docs.kraken.com/rest/#operation/getClosedOrders](https://docs.kraken.com/rest/#operation/getClosedOrders)

Returns information about the closed orders. 

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(get_closed_orders(client))
Dict{String, Any}(
    "closed" => Dict{String, Any}(
        "OLGRP5-M42MC-YOFF7T" => Dict{String, Any}(
            "price" => "0.00000", 
            "vol" => "40.36280000", 
            "status" => "canceled", 
            "vol_exec" => "0.00000000", 
            "oflags" => "fciq", 
            "reason" => "User requested", 
            "starttm" => 0, 
            "stopprice" => "0.00000", 
            "refid" => nothing, 
            "userref" => 0, 
            "expiretm" => 0,
            "cost" => "0.00000",
            "fee" => "0.00000", 
            "misc" => "", 
            "limitprice" => "0.00000", 
            "opentm" => 1.6730201392732968e9, 
            "descr" => Dict{String, Any}(
                "ordertype" => "limit",
                "price" => "40.5842", 
                "pair" => "DOTUSD", 
                "order" => "buy 40.36280000 DOTUSD @ limit 4.5842", 
                "leverage" => "none",
                "type" => "buy", 
                "close" => "", 
                "price2" => "0"
            ), 
            "closetm" => 1.673225209430317e9
        ), 
        "OUSQ7U-2TP3Q-PBKOIP" => Dict{String, Any}(
            ...
        )
    )
)
```
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

Kraken Docs: [https://docs.kraken.com/rest/#tag/User-Data/operation/getOrdersInfo](https://docs.kraken.com/rest/#tag/User-Data/operation/getOrdersInfo)

Returns information about a specific order by `txid`.

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(get_orders_info(client, txid="OLGRP5-M42MC-YOFF7T"))
Dict{String, Any}
    "OLGRP5-M42MC-YOFF7T" => Dict{String, Any}(
        "price" => "0.00000", 
        "vol" => "40.36280000", 
        "status" => "canceled", 
        "vol_exec" => "0.00000000", 
        "oflags" => "fciq", 
        "reason" => "User requested", 
        "starttm" => 0, 
        "stopprice" => "0.00000", 
        "refid" => nothing, 
        "userref" => 0, 
        "expiretm" => 0,
        "cost" => "0.00000",
        "fee" => "0.00000", 
        "misc" => "", 
        "limitprice" => "0.00000", 
        "opentm" => 1.6730201392732968e9, 
        "descr" => Dict{String, Any}(
            "ordertype" => "limit",
            "price" => "40.5842", 
            "pair" => "DOTUSD", 
            "order" => "buy 40.36280000 DOTUSD @ limit 4.5842", 
            "leverage" => "none",
            "type" => "buy", 
            "close" => "", 
            "price2" => "0"
        ), 
        "closetm" => 1.673225209430317e9
    )
)
```
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

Kraken Docs: [https://docs.kraken.com/rest/#operation/getTradeHistory](https://docs.kraken.com/rest/#operation/getTradeHistory)

Returns historical trades and information.

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(get_trades_history(client, type="all", start=1668431675, trades=true))
Dict{String, Any}(
    "count" => 182, 
    "trades" => Dict{String, Any}(
        "TRZUTT-EZZ7C-NYDTL3" => Dict{String, Any}(
            "price" => "4.29780", 
            "time" => 1.6722627506350572e9, 
            "ordertxid" => "OGFLW2-CZKU3-XKCBMB",
            "trade_id" => 8737419, 
            "vol" => "46.5350000", 
            "pair" => "DOTUSD", 
            "postxid" => "TKH2SE-M7IF5-CFI7LT", 
            "ordertype" => "limit", 
            "cost" => "199.9981", 
            "fee" => "0.3200", 
            "misc" => "", 
            "leverage" => "0", 
            "margin" => "0.00000",
            "type" => "buy"
        ), "TNJFKJ-YLYX7-ETYS66" => Dict{String, Any}(
            ...
        )
    )
)
```
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

Kraken Docs: [https://docs.kraken.com/rest/#operation/getTradesInfo](https://docs.kraken.com/rest/#operation/getTradesInfo)

Returns information about specific trades by `txid`. 

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(get_trades_info(private_client, txid="2QMIXRF-I0EXWP-WQ6459"))
Dict{String,Any)(
    "2QMIXRF-I0EXWP-WQ6459" => Dict{String,Any}(
        "ordertxid" => "OQCLML-BW3P3-BUCMWZ",
        "postxid" => "0H90AJ-M4W3ZY-66GF8Y",
        "pair" => "XXBTZUSD",
        "time" => 1616667796.8802,
        "type" => "buy",
        "ordertype" => "limit",
        "price" => "30010.00000",
        "cost" => "600.20000",
        "fee" => "0.00000",
        "vol" => "0.02000000",
        "margin" => "0.00000",
        "misc" => ""
    )
)
```
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

Kraken Docs: [https://docs.kraken.com/rest/#operation/getOpenPositions](https://docs.kraken.com/rest/#operation/getOpenPositions)

Returns a list of open Margin positions.

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(get_open_positions(client))
Dict{String,Any}(
    "ZBR4YTU-ND7TDJ-OZ8LR" => Dict{String,Any}(
        "ordertxid" => "03YHGT-P82PNP-D9DY85",
        "posstatus" => "open",
        "pair" => "XXBTZUSD",
        "time" => 1605280097.8294,
        "type" => "buy",
        "ordertype" => "limit",
        "cost" => "104610.52842",
        "fee" => "289.06565",
        "vol" => "8.82412861",
        "vol_closed" => "0.20200000",
        "margin" => "20922.10568",
        "value" => "258797.5",
        "net" => "+154186.9728",
        "terms" => "0.0100% per 4 hours",
        "rollovertm" => "1616672637",
        "misc" => "",
        "oflags" => ""
    )
)
```
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

Kraken Docs: [https://docs.kraken.com/rest/#operation/getLedgers](https://docs.kraken.com/rest/#operation/getLedgers)

Returns information about the current ledergs.

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(get_ledgers_info(client))
Dict{String, Any}(
    "count" => 1068, 
    "ledger" => Dict{String, Any}(
        "LWSAYQ-GD2N2-IM3I6O" => Dict{String, Any}(
            "amount" => "0.00", 
            "balance" => "9437.94", 
            "fee" => "6.43", 
            "time" => 1.6732795570751212e9, 
            "aclass" => "currency", 
            "asset" => "KFEE", 
            "subtype" => "", 
            "refid" => "TYQEFQ-NYADC-R4LII6", 
            "type" => "trade"
        ), 
        "LP6VNL-HDXPP-JLVG73" => Dict{String, Any}(
            "amount" => "-0.0300000000", 
            "balance" => "0.0119368320", 
            "fee" => "0.0000000000", 
            "time" => 1.6732795570750895e9, 
            "aclass" => "currency", 
            "asset" => "XETH", 
            "subtype" => "", 
            "refid" => "TYQEFQ-NYADC-R4LII6", 
            "type" => "trade"
        ), ....
    )
)

```
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

Kraken Docs: [https://docs.kraken.com/rest/#operation/getLedgersInfo](https://docs.kraken.com/rest/#operation/getLedgersInfo)

Returns information about specific ledergs by `id`.

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(get_ledgers(client, id="LNYQGU-SUR5U-UXTOWM"))
Dict{String, Any}(
    "LNYQGU-SUR5U-UXTOWM" => Dict{String, Any}(
        "amount" => "2001.0000",
        "balance" => "2001.0082", 
        "fee" => "0.0000", 
        "time" => 1.668681189483613e9, 
        "aclass" => "currency", 
        "asset" => "EUR", 
        "subtype" => "", 
        "refid" => "QYSCWYA-S54CSU-RDHRV3", 
        "type" => "deposit"
    )
)
```
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

Kraken Docs: [https://docs.kraken.com/rest/#operation/getTradeVolume](https://docs.kraken.com/rest/#operation/getTradeVolume)

Returns the actual 30-day trading volume.
Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(get_trade_volume(client))
Dict{String, Any}(
    "currency" => "ZUSD", 
    "volume" => "204212.9762",
    "fees_maker" => nothing, 
    "fees" => nothing
)
```
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

Kraken Docs: [https://docs.kraken.com/rest/#operation/addExport](https://docs.kraken.com/rest/#operation/addExport)

Initiates the export of a report and returns the export-`id`.

Authenticated `client` required

# Attributes

- `report` -- must be one of ["trades", "ledgers"] 

...


# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(request_export_report(
...        client, 
...        report="ledgers", 
...        description="myLedgersExport", 
...        format="CSV"
...    ) 
Dict{String, Any}("id" => "OFEZ")
```
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

Kraken Docs: [https://docs.kraken.com/rest/#operation/exportStatus](https://docs.kraken.com/rest/#operation/exportStatus)

Returns information about the current export status.

Authenticated `client` required

# Attributes

- `report` -- must be one of ["trades", "ledgers"] 

...

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(get_export_report_status(client, report="ledgers"))
Any[Dict{String, Any}(
    "report" => "ledgers", 
    "fields" => "all", 
    "aclass" => "currency", 
    "endtm" => "1673368394", 
    "createdtm" => "1673368394", 
    "format" => "CSV", 
    "status" => "Queued", 
    "id" => "OFEZ", 
    "subtype" => "all", 
    "starttm" => "1672531200",
    "dataendtm" => "1673368394", 
    "completedtm" => "0", 
    "datastarttm" => "1672531200", 
    "expiretm" => "1674577994", 
    "flags" => "0", 
    "asset" => "all", 
    "descr" => "myLedgersExport"
)]
```
"""
function get_export_report_status(client::SpotBaseRESTAPI; report::String)
    report ∉ ["trades", "ledgers"] ? error("`report` must be one of \"trades\" or \"ledgers\"") : nothing
    return request(client, "POST", "/private/ExportStatus"; data=Dict{String,Any}("report" => report), auth=true)
end

"""
    retrieve_export(client::SpotBaseRESTAPI; id::String)

Kraken Docs: [https://docs.kraken.com/rest/#operation/retrieveExport](https://docs.kraken.com/rest/#operation/retrieveExport)

Retrieves the initiated exprort. Can be used to save this report to csv.

Authenticated `client` required

The `id` is obtained when requesting the report using [`request_export_report`](@ref).

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> report = retrieve_export(private_client, id="OFEZ") 
julia> open("myExport.zip", "w") do io
...        write(io, report)
...    end

```
"""
function retrieve_export(client::SpotBaseRESTAPI; id::String)
    return request(client, "POST", "/private/RetrieveExport"; data=Dict{String,Any}("id" => id), auth=true, return_raw=true)
end

"""
    delete_export_report(client::SpotBaseRESTAPI; id::String, type::String)

Kraken Docs: [https://docs.kraken.com/rest/#operation/removeExport](https://docs.kraken.com/rest/#operation/removeExport)

Removes an export by `id` from the system.

Authenticated `client` required

# Attributes
- `type` -- must be one of ["delete", "cancel"]

...

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(delete_export_report(client, type="delete", id="PFEZ))
Dict{String, Any}("delete" => true)
```
"""
function delete_export_report(client::SpotBaseRESTAPI; id::String, type::String)
    return request(client, "POST", "/private/RemoveExport"; data=Dict{String,Any}(
            "id" => id,
            "type" => type
        ), auth=true)
end

"""
    get_websockets_token(client::SpotBaseRESTAPI)

Kraken Docs: [https://docs.kraken.com/rest/#tag/Websockets-Authentication](https://docs.kraken.com/rest/#tag/Websockets-Authentication)

Returns the websocket token. This is used by the when 
managing private websocket feeds and subscriptions.

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(get_websockets_token(client))
Dict{String,Any}(
    "token": "1Agc3liasQPoAkAkadohsSNMFhs1ende06d1von3YFEMq",
    "expires": 900
)
```
"""
function get_websockets_token(client::SpotBaseRESTAPI)
    return request(client, "POST", "/private/GetWebSocketsToken", auth=true)
end
end