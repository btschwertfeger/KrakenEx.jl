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

https://docs.futures.kraken.com/#http-api-trading-v3-api-account-information-get-wallets
"""
function get_wallets(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/accounts", auth=true)
end

"""
    get_open_orders(client::FuturesBaseRESTAPI)

https://docs.futures.kraken.com/#http-api-trading-v3-api-account-information-get-open-orders
"""
function get_open_orders(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/openorders", auth=true)
end

"""
    get_open_positions(client::FuturesBaseRESTAPI)

https://docs.futures.kraken.com/#http-api-trading-v3-api-account-information-get-open-positions
"""
function get_open_positions(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/openpositions", auth=true)
end

"""
    get_subaccounts(client::FuturesBaseRESTAPI)

https://docs.futures.kraken.com/#http-api-trading-v3-api-account-information-get-subaccounts
"""
function get_subaccounts(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/subaccounts", auth=true)
end

"""
    get_unwindqueue(client::FuturesBaseRESTAPI)

https://docs.futures.kraken.com/#http-api-trading-v3-api-account-information-get-position-percentile-of-unwind-queue
"""
function get_unwindqueue(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/derivatives/api/v3/unwindqueue", auth=true)
end

"""
    get_notificatios(client::FuturesBaseRESTAPI)

https://docs.futures.kraken.com/#http-api-trading-v3-api-general-get-notifications
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

https://docs.futures.kraken.com/#http-api-history-account-log
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

https://docs.futures.kraken.com/#http-api-history-account-log-get-recent-account-log-csv
"""
function get_account_log_csv(client::FuturesBaseRESTAPI)
    return request(client, "GET", "/api/history/v2/accountlogcsv", auth=true, return_raw=true)
end

end