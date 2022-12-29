module KrakenSpotStakingModule

using ..KrakenSpotBaseAPIModule
using ..Utils

#======= E X P O R T S ========#
export stake_asset
export unstake_asset
export list_stakeable_assets
export get_pending_staking_transactions
export list_staking_transactions

#======= F U N C T I O N S ========#
function stake_asset(client::SpotBaseRESTAPI; asset::String, amount::Union{Float64,Int64,String}, method::String)
    """https://docs.kraken.com/rest/#operation/stake"""
    return request(client, "POST", "/private/Stake", data=Dict{String,Any}(
            "asset" => asset,
            "amount" => string(amount),
            "method" => method
        ), auth=true)
end

function unstake_asset(client::SpotBaseRESTAPI; asset::String, amount::Union{Float64,Int64,String})
    """https://docs.kraken.com/rest/#operation/unstake"""
    return request(client, "POST", "/private/Unstake", data=Dict{String,Any}(
            "asset" => asset,
            "amount" => string(amount)
        ), auth=true)
end

function list_stakeable_assets(client::SpotBaseRESTAPI)
    """https://docs.kraken.com/rest/#operation/getStakingAssetInfo"""
    return request(client, "POST", "/private/Staking/Assets", auth=true)
end
function get_pending_staking_transactions(client::SpotBaseRESTAPI)
    """https://docs.kraken.com/rest/#operation/getStakingPendingDeposits"""
    return request(client, "POST", "/private/Staking/Pending", auth=true)
end

function list_staking_transactions(client::SpotBaseRESTAPI)
    """https://docs.kraken.com/rest/#operation/getStakingTransactions"""
    return request(client, "POST", "/private/Staking/Transactions", auth=true)
end
end