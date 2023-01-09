module SpotStakingModule

using ..SpotBaseAPIModule: SpotBaseRESTAPI, request
using ..Utils

#======= E X P O R T S ========#
export stake_asset
export unstake_asset
export list_stakeable_assets
export get_pending_staking_transactions
export list_staking_transactions

#======= F U N C T I O N S ========#
"""
    stake_asset(client::SpotBaseRESTAPI; asset::String, amount::Union{Float64,Int64,String}, method::String)

https://docs.kraken.com/rest/#operation/stake
"""
function stake_asset(client::SpotBaseRESTAPI; asset::String, amount::Union{Float64,Int64,String}, method::String)
    return request(client, "POST", "/private/Stake", data=Dict{String,Any}(
            "asset" => asset,
            "amount" => string(amount),
            "method" => method
        ), auth=true)
end

"""
    unstake_asset(client::SpotBaseRESTAPI; asset::String, amount::Union{Float64,Int64,String})

https://docs.kraken.com/rest/#operation/unstake
"""
function unstake_asset(client::SpotBaseRESTAPI; asset::String, amount::Union{Float64,Int64,String}, method::Union{String,Nothing}=nothing)
    params::Dict{String,Any} = Dict{String,Any}(
        "asset" => asset,
        "amount" => string(amount)
    )
    !isnothing(method) ? params["method"] = method : nothing
    return request(client, "POST", "/private/Unstake", data=params, auth=true)
end

"""
    list_stakeable_assets(client::SpotBaseRESTAPI)

https://docs.kraken.com/rest/#operation/getStakingAssetInfo
"""
function list_stakeable_assets(client::SpotBaseRESTAPI)
    return request(client, "POST", "/private/Staking/Assets", auth=true)
end

"""
    get_pending_staking_transactions(client::SpotBaseRESTAPI)

https://docs.kraken.com/rest/#operation/getStakingPendingDeposits
"""
function get_pending_staking_transactions(client::SpotBaseRESTAPI)
    return request(client, "POST", "/private/Staking/Pending", auth=true)
end

"""
    list_staking_transactions(client::SpotBaseRESTAPI)

https://docs.kraken.com/rest/#operation/getStakingTransactions
"""
function list_staking_transactions(client::SpotBaseRESTAPI)
    return request(client, "POST", "/private/Staking/Transactions", auth=true)
end
end
