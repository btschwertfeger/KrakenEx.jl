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

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-historical-funding-rates-historicalfundingrates](https://docs.futures.kraken.com/#http-api-trading-v3-api-historical-funding-rates-historicalfundingrates)

# Examples 

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> println(get_historical_funding_rates(client, symbol="PI_XBTUSD"))
Dict{String, Any}(
    "rates" => Any[
        Dict{String, Any}(
            "fundingRate" => 1.0327058177e-8, 
            "timestamp" => "2018-08-31T16:00:00.000Z", 
            "relativeFundingRate" => 7.182407e-5
        ), 
        Dict{String, Any}(
            "fundingRate" => -1.2047162502e-8,
            "timestamp" => "2018-08-31T20:00:00.000Z",
            "relativeFundingRate" => -8.4873103125e-5
        ), 
        Dict{String, Any}(
            "fundingRate" => -9.645113378e-9, 
            "timestamp" => "2018-09-01T00:00:00.000Z", 
            "relativeFundingRate" => -6.76651e-5
        ), 
        Dict{String, Any}(
            "fundingRate" => -8.028122964e-9, 
            "timestamp" => "2018-09-01T04:00:00.000Z", 
            "relativeFundingRate" => -5.66897875e-5
        ), ...
    ]
)
```
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

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-transfers-initiate-wallet-transfer](https://docs.futures.kraken.com/#http-api-trading-v3-api-transfers-initiate-wallet-transfer)

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> initiate_wallet_transfer(client,
...        amount=100,
...        fromAccount="some-cash-or-margin-account",
...        toAccount="another-cash-or-margin-account",
...        unit="the-currency-unit-to-transfer"
...    )
```
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

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-transfers-initiate-sub-account-transfer](https://docs.futures.kraken.com/#http-api-trading-v3-api-transfers-initiate-sub-account-transfer)

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> initiate_subccount_transfer(
...        client,
...        amount=200,
...        fromAccount="SomeAccount",
...        toAccount="ToAnotherAccount",
...        fromUser="Marianne",
...        toUser="Perl",
...        unit="XBT"
...    )
```
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

Kraken Docs: [https://docs.futures.kraken.com/#http-api-trading-v3-api-transfers-initiate-withdrawal-to-spot-wallet](https://docs.futures.kraken.com/#http-api-trading-v3-api-transfers-initiate-withdrawal-to-spot-wallet)

# Examples

```julia-repl
julia> client = FuturesBaseRESTAPI(key="api-key", secret="api-secret")
julia> initiate_withdrawal_to_spot_wallet(
...       client,
...       amount=200,
...       currency="XBT",
...       sourceWallet="Cross-Margin"
...    )
```
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