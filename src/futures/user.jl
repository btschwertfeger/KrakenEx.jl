"""
    FuturesUserModule

Enables accessing Futures user endpoints using predefined methods.
"""
module FuturesUserModule
using ..FuturesBaseAPIModule: FuturesBaseRESTAPI, request

#======= E X P O R T S ========#
export get_wallets
export get_open_orders
export get_open_positions
export get_subaccounts
export get_unwindqueue
export get_notificatios
export get_account_log
export get_account_log_csv

#======= F U N C T I O N S ========#
"""
    get_wallets(client::FuturesBaseRESTAPI)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-account-information-get-wallets](https://docs.futures.kraken.com/#http-api-trading-v3-api-account-information-get-wallets)

Lists the user-specifc wallets.

Authenticated `client` required

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> println(get_wallets(client))
ict{String, Any}(
    "serverTime" => "2023-01-10T18:29:00.251Z", 
    "accounts" => Dict{String, Any}(
        "fv_xrpxbt" => Dict{String, Any}(
            "currency" => "xbt", 
            "marginRequirements" => Dict{String, Any}(
                "tt" => 0.0, "mm" => 0.0, "lt" => 0.0, "im" => 0.0
            ), 
            "auxiliary" => Dict{String, Any}(
                "pv" => 0.0, "pnl" => 0.0, "funding" => 0.0, "af" => 0.0, "usd" => 0
            ), 
            "balances" => Dict{String, Any}("xbt" => 0.0), 
            "triggerEstimates" => Dict{String, Any}(
                "tt" => 0, "mm" => 0, "lt" => 0, "im" => 0
            ), 
            "type" => "marginAccount"
        ), 
        "fi_xbtusd" => Dict{String, Any}(
            "currency" => "xbt", 
            "marginRequirements" => Dict{String, Any}(
                "tt" => 0.0, "mm" => 0.0, "lt" => 0.0, "im" => 0.0
            ), 
            "auxiliary" => Dict{String, Any}(
                "pv" => 0.0, "pnl" => 0.0, "funding" => 0.0, "af" => 0.0, "usd" => 0
            ), 
            "balances" => Dict{String, Any}("xbt" => 0.0),
            "triggerEstimates" => Dict{String, Any}(
                "tt" => 0, "mm" => 0, "lt" => 0, "im" => 0
            ), "type" => "marginAccount"
        ), ...
    )
)
```
"""
function get_wallets(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/accounts", auth=true)
end

"""
    get_open_orders(client::FuturesBaseRESTAPI)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-account-information-get-open-orders](https://docs.futures.kraken.com/#http-api-trading-v3-api-account-information-get-open-orders)

Lists the open orders of this user.

Authenticated `client` required

# Examples 

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> println(get_open_orders(client))
Dict{String, Any}(
    "openOrders" => Any[], 
    "serverTime" => "2023-01-10T18:31:07.027Z", 
    "result" => "success"
)
```
"""
function get_open_orders(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/openorders", auth=true)
end

"""
    get_open_positions(client::FuturesBaseRESTAPI)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-account-information-get-open-positions](https://docs.futures.kraken.com/#http-api-trading-v3-api-account-information-get-open-positions)

Lists the open positions of this user.

Authenticated `client` required

# Examples 

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> println(get_open_positions(client))
Dict{String, Any}(
    "openPositions" => Any[],
    "serverTime" => "2023-01-10T18:31:45.903Z", 
    "result" => "success
)
```
"""
function get_open_positions(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/openpositions", auth=true)
end

"""
    get_subaccounts(client::FuturesBaseRESTAPI)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-account-information-get-subaccounts](https://docs.futures.kraken.com/#http-api-trading-v3-api-account-information-get-subaccounts)

Lists the available subaccounts.

Authenticated `client` required

# Examples 

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> println(get_subaccounts(client))
Dict{String, Any}(
    "subaccounts" => Any[], 
    "serverTime" => "2023-01-10T18:32:03.993Z", 
    "masterAccountUid" => "XXX-XXX-XXX-XXX", 
    "result" => "success"
)
```
"""
function get_subaccounts(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/subaccounts", auth=true)
end

"""
    get_unwindqueue(client::FuturesBaseRESTAPI)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-account-information-get-position-percentile-of-unwind-queue](https://docs.futures.kraken.com/#http-api-trading-v3-api-account-information-get-position-percentile-of-unwind-queue)

Authenticated `client` required

# Examples 

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> println(get_unwindqueue(client))
Dict{String, Any}(
    "queue" => Any[], 
    "serverTime" => "2023-01-10T18:33:00.647Z", 
    "result" => "success"
)
```
"""
function get_unwindqueue(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/unwindqueue", auth=true)
end

"""
    get_notificatios(client::FuturesBaseRESTAPI)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-general-get-notifications](https://docs.futures.kraken.com/#http-api-trading-v3-api-general-get-notifications)

Returns information defined by Kraken, e.g. "PostOnly mode at 01.01.2023 00:00:00"

Authenticated `client` required

# Examples 

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> println(get_notificatios(client))
Dict{String, Any}(
    "serverTime" => "2023-01-10T18:33:28.582Z", 
    "notifications" => Any[], 
    "result" => "success"
)
```
"""
function get_notificatios(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/notifications", auth=true)
end

"""
    get_account_log(client::FuturesBaseRESTAPI;
        before::Union{Int,String,Nothing}=nothing,
        since::Union{Int,String,Nothing}=nothing,
        count::Union{Int,String,Nothing}=nothing,
        from::Union{Int,String,Nothing}=nothing,
        to::Union{Int,String,Nothing}=nothing,
        sort::Union{String,Nothing}=nothing,
        info::Union{String,Nothing}=nothing
    )

Kraken Docs: [https://docs.futures.kraken.com/#http-api-history-account-log](https://docs.futures.kraken.com/#http-api-history-account-log)

Enables querying the log of specific events.

Authenticated `client` required

# Examples 

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> println(get_account_log(
...        client, 
...        before="1604937694000", 
...        info="futures liquidation"
...    ))
Dict{String, Any}(
    "accountUid" => "XXX-XXX-XXX--XXXX", 
    "logs" => Any[]
)
```
"""
function get_account_log(client::FuturesBaseRESTAPI;
    before::Union{Int,String,Nothing}=nothing,
    since::Union{Int,String,Nothing}=nothing,
    count::Union{Int,String,Nothing}=nothing,
    from::Union{Int,String,Nothing}=nothing,
    to::Union{Int,String,Nothing}=nothing,
    sort::Union{String,Nothing}=nothing,
    info::Union{String,Nothing}=nothing
)
    params::Dict{String,Any} = Dict{String,Any}()
    isnothing(count) ? nothing : params["count"] = count
    isnothing(sort) ? nothing : params["sort"] = sort
    isnothing(info) ? nothing : params["info"] = info
    isnothing(before) ? nothing : params["before"] = before
    isnothing(since) ? nothing : params["since"] = since
    isnothing(from) ? nothing : params["from"] = from
    isnothing(to) ? nothing : params["to"] = to

    return request(client, "GET", "/api/history/v2/account-log", query_params=params, auth=true)
end

"""
    get_account_log_csv(client::FuturesBaseRESTAPI)

Kraken Docs: [https://docs.futures.kraken.com/#http-api-history-account-log-get-recent-account-log-csv](https://docs.futures.kraken.com/#http-api-history-account-log-get-recent-account-log-csv)

Enables requesting the account log to save it as for example as csv.

Authenticated `client` required

# Examples 

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> log = get_account_log_csv(client)
julia> open("myAccountLog.csv", "w") do io
...        write(io, log)
...    end
```
"""
function get_account_log_csv(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/api/history/v2/accountlogcsv", auth=true, return_raw=true)
end

end