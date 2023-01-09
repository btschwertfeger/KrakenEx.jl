module FuturesFundingModule
using ..FuturesBaseAPIModule: FuturesBaseRESTAPI, request

#======= E X P O R T S ========#
export get_historical_funding_rates
export initiate_wallet_transfer
export initiate_subccount_transfer
export initiate_withdrawal_to_spot_wallet

#======= F U N C T I O N S ========#
"""
    get_historical_funding_rates(client::FuturesBaseRESTAPI; symbol::String)

https://docs.futures.kraken.com/#http-api-trading-v3-api-historical-funding-rates-historicalfundingrates
"""
function get_historical_funding_rates(client::FuturesBaseRESTAPI; symbol::String)
    return request(client, "GET", "/derivatives/api/v4/historicalfundingrates", query_params=Dict{String,Any}(
            "symbol" => symbol
        ), auth=false)
end

"""
    initiate_wallet_transfer(
        client::FuturesBaseRESTAPI;
        amount::Union{String,Float64,Int},
        fromAccount::String,
        toAccount::String,
        unit::String
    )

https://docs.futures.kraken.com/#http-api-trading-v3-api-transfers-initiate-wallet-transfer
"""
function initiate_wallet_transfer(
    client::FuturesBaseRESTAPI;
    amount::Union{String,Float64,Int},
    fromAccount::String,
    toAccount::String,
    unit::String
)
    return request(client, "POST", "/derivatives/api/v3/transfer", post_params=Dict{String,Any}(
            "amount" => amount,
            "fromAccount" => fromAccount,
            "toAccount" => toAccount,
            "unit" => unit
        ), auth=true)
end

"""
    initiate_subccount_transfer(
        client::FuturesBaseRESTAPI;
        amount::Union{String,Float64,Int},
        fromAccount::String,
        toAccount::String,
        unit::String,
        fromUser::String,
        toUser::String
    )

https://docs.futures.kraken.com/#http-api-trading-v3-api-transfers-initiate-sub-account-transfer
"""
function initiate_subccount_transfer(
    client::FuturesBaseRESTAPI;
    amount::Union{String,Float64,Int},
    fromAccount::String,
    toAccount::String,
    unit::String,
    fromUser::String,
    toUser::String
)
    return request(client, "POST", "/derivatives/api/v3/transfer/subaccount", post_params=Dict{String,Any}(
            "amount" => amount,
            "fromAccount" => fromAccount,
            "fromUser" => fromUser,
            "toAccount" => toAccount,
            "toUser" => toUser,
            "unit" => unit
        ), auth=true)
end

"""
    initiate_withdrawal_to_spot_wallet(
        client::FuturesBaseRESTAPI;
        amount::Union{String,Int,Float64},
        currency::String,
        sourceWallet::Union{String,Nothing}
    )

https://docs.futures.kraken.com/#http-api-trading-v3-api-transfers-initiate-withdrawal-to-spot-wallet
"""
function initiate_withdrawal_to_spot_wallet(
    client::FuturesBaseRESTAPI;
    amount::Union{String,Int,Float64},
    currency::String,
    sourceWallet::Union{String,Nothing}=nothing
)
    params::Dict{String,Any} = Dict{String,Any}(
        "amount" => string(amount),
        "currency" => currency
    )
    isnothing(sourceWallet) ? nothing : params["sourceWallet"] = sourceWallet
    return request(client, "POST", "/derivatives/api/v3/withdrawal", post_params=params, auth=true)
end

end