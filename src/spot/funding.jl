module KrakenSpotFundingModule

using ..KrakenSpotBaseAPIModule
using ..Utils

#======= E X P O R T S ========#
export get_deposit_methods
export get_deposit_address
export get_recend_deposits_status
export get_withdrawal_info
export get_recend_withdraw_status
export cancel_withdraw
export wallet_transfer

#======= F U N C T I O N S ========#


function get_deposit_methods(client::SpotBaseRESTAPI; asset::String)
    """https://docs.kraken.com/rest/#operation/getDepositMethods"""
    return request(client, "POST", "/private/DepositMethods", data=Dict{String,Any}(["asset" => asset]), auth=true)
end

function get_deposit_address(client::SpotBaseRESTAPI; asset::String, method::String, new::Bool=false)
    """https://docs.kraken.com/rest/#operation/getDepositAddresses"""
    return request(client, "POST", "/private/DepositAddresses", data=Dict{String,Any}([
            "asset" => asset, "method" => method, "new" => string(new)
        ]), auth=true)
end

function get_recend_deposits_status(client::SpotBaseRESTAPI; asset::String, method::Union{String,Nothing}=nothing)
    """https://docs.kraken.com/rest/#operation/getStatusRecentDeposits"""
    params = Dict{String,Any}(["asset" => asset])
    !isnothing(method) ? params["method"] = method : nothing
    return request(client, "POST", "/private/DepositStatus", data=params, auth=true)
end

function withdraw_funds(client::SpotBaseRESTAPI; asset::String, key::String, amount::Union{Float64,String})
    """https://docs.kraken.com/rest/#operation/withdrawFund"""
    return request(client, "POST", "/private/Withdraw", data=Dict{String,Any}([
            "asset" => asset,
            "key" => key,
            "amount" => string(amount)
        ]), auth=true)
end

function get_withdrawal_info(client::SpotBaseRESTAPI; asset::String, key::String, amount::Union{Float64,String})
    """https://docs.kraken.com/rest/#operation/getWithdrawalInformation"""
    return request(client, "POST", "/private/WithdrawInfo", data=Dict{String,Any}([
            "asset" => asset,
            "key" => key,
            "amount" => string(amount)
        ]), auth=true)
end

function get_recend_withdraw_status(client::SpotBaseRESTAPI; asset::String, method::Union{String,Nothing}=nothing)
    """https://docs.kraken.com/rest/#operation/getStatusRecentWithdrawals"""
    params = Dict{String,Any}(["asset" => asset])
    !isnothing(method) ? params["method"] = method : nothing
    return request(client, "POST", "/private/WithdrawStatus", data=params, auth=true)
end

function cancel_withdraw(client::SpotBaseRESTAPI; asset::String, refid::String)
    """https://docs.kraken.com/rest/#operation/cancelWithdrawal"""
    return request(client, "POST", "/private/WithdrawCancel", data=Dict{String,Any}([
            "asset" => asset,
            "refid" => refid
        ]), auth=true)
end
function (client::SpotBaseRESTAPI)
    """"""
    return request(client, "POST", "/private/", data=params, auth=true)
end

function wallet_transfer(client::SpotBaseRESTAPI; asset::String, from::String, to::String, amount::Union{Float64,String})
    """https://docs.kraken.com/rest/#operation/walletTransfer"""
    return request(client, "POST", "/private/WalletTransfer", data=Dict{String,Any}([
            "asset" => asset,
            "from" => from,
            "to" => to,
            "amount" => string(amount)
        ]), auth=true)
end
end