"""
    SpotFundingModule

Enables accessing Spot funding endpoints using predefined methods.
"""
module SpotFundingModule
using ..SpotBaseAPIModule: SpotBaseRESTAPI, request
using ..Utils

#======= E X P O R T S ========#
export get_deposit_methods
export get_deposit_address
export get_recent_deposits_status
export withdraw_funds
export get_withdrawal_info
export get_recent_withdraw_status
export cancel_withdraw
export wallet_transfer

#======= F U N C T I O N S ========#
"""
    get_deposit_methods(client::SpotBaseRESTAPI; asset::String)

Kraken Docs: [https://docs.kraken.com/rest/#operation/getDepositMethods](https://docs.kraken.com/rest/#operation/getDepositMethods)

Returns the available deposit methods for a given `asset` (symbol/currency pair).

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> get_deposit_methods(client, asset="DOT")
Any[Dict{String, Any}(
    "gen-address" => true,
    "method" =>
    "Polkadot",
    "limit" => false
)]
```
"""
function get_deposit_methods(client::SpotBaseRESTAPI; asset::String)
    return request(client, "POST", "/private/DepositMethods", data=Dict{String,Any}("asset" => asset), auth=true)
end

"""
    get_deposit_address(
        client::SpotBaseRESTAPI;
        asset::String,
        method::String,
        new::Bool=false
    )

Kraken Docs: [https://docs.kraken.com/rest/#operation/getDepositAddresses](https://docs.kraken.com/rest/#operation/getDepositAddresses)

Returns the available deposit adresses of a given `asset` (symbol/currency pair).

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(get_deposit_address(client, asset="DOT", method="Polkadot"))
Any[
    Dict{String, Any}(
        "new" => true,
        "expiretm" => "0",
        "address" => "14MvdTudtJppS4WrUXg5mQiQiq6baUXt3KwhxxEDXnB7nMYv"
    ), Dict{String, Any}(
        "new" => true,
        "expiretm" => "0",
        "address" => "15mK6NDReFAxkP6menxPRZdGNzRJY31vDMe9uSUPWfZj64Vy"
    ), ...
]
```
"""
function get_deposit_address(
    client::SpotBaseRESTAPI;
    asset::String,
    method::String,
    new::Bool=false
)
    return request(client, "POST", "/private/DepositAddresses", data=Dict{String,Any}(
            "asset" => asset, "method" => method, "new" => string(new)
        ), auth=true)
end

"""
    get_recent_deposits_status(
        client::SpotBaseRESTAPI;
        asset::Union{String,Nothing}=Nothing,
        method::Union{String,Nothing}=nothing
    )

Kraken Docs: [https://docs.kraken.com/rest/#operation/getStatusRecentDeposits](https://docs.kraken.com/rest/#operation/getStatusRecentDeposits)

Returns the status of the recent deposit.

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(
...        get_recent_deposits_status(
...             client, asset="DOT", method="Polkadot"
...        )
...    )
Any[]
```
"""
function get_recent_deposits_status(
    client::SpotBaseRESTAPI;
    asset::Union{String,Nothing}=nothing,
    method::Union{String,Nothing}=nothing
)
    params = Dict{String,Any}()
    !isnothing(asset) ? params["asset"] = asset : nothing
    !isnothing(method) ? params["method"] = method : nothing
    return request(client, "POST", "/private/DepositStatus", data=params, auth=true)
end

"""
    withdraw_funds(
        client::SpotBaseRESTAPI;
        asset::String,
        key::String,
        amount::Union{Float64,Int64,String}
    )

Kraken Docs: [https://docs.kraken.com/rest/#operation/withdrawFunds](https://docs.kraken.com/rest/#operation/withdrawFunds)

Initiates a withdraw and returns the `refid` to track the status.

Authenticated `client` required

Note: The `key` must be the name of the withdraw wallet as defined in the Web UI of the Kraken exchange.
# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(withdraw_funds(
...         client,
...         asset="DOT",
...         key="some-widthdrawal-id-from-gui",
...         amount=200
...     ))
Dict{String,Any}("refid" => "AGBSO6T-UFMTTQ-I7KGS6")
```
"""
function withdraw_funds(
    client::SpotBaseRESTAPI;
    asset::String,
    key::String,
    amount::Union{Float64,Int64,String}
)
    return request(client, "POST", "/private/Withdraw", data=Dict{String,Any}(
            "asset" => asset,
            "key" => key,
            "amount" => string(amount)
        ), auth=true)
end

"""
    get_withdrawal_info(
        client::SpotBaseRESTAPI;
        asset::String,
        key::String,
        amount::Union{Float64,Int64,String}
    )

Kraken Docs: [https://docs.kraken.com/rest/#operation/getWithdrawalInformation](https://docs.kraken.com/rest/#operation/getWithdrawalInformation)

Returns information about a specific withdrawal. The `key` can be the `refid` returned by [`withdraw_funds`](@ref).

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(get_withdrawal_info(
...        client,
...        asset="DOT",
...        key="pwallet1",
...        amount="200"
...    ))
)
Dict{String,Any}(
    "method" => "Bitcoin",
    "limit" => "332.00956139",
    "amount" => "0.72485000",
    "fee" => "0.00015000"
)
```
"""
function get_withdrawal_info(
    client::SpotBaseRESTAPI;
    asset::String,
    key::String,
    amount::Union{Float64,Int64,String}
)
    return request(client, "POST", "/private/WithdrawInfo", data=Dict{String,Any}(
            "amount" => string(amount),
            "asset" => asset,
            "key" => key,
        ), auth=true)
end

"""
    get_recent_withdraw_status(
        client::SpotBaseRESTAPI;
        asset::String,
        method::Union{String,Nothing}=nothing
    )

Kraken Docs: [https://docs.kraken.com/rest/#operation/getStatusRecentWithdrawals](https://docs.kraken.com/rest/#operation/getStatusRecentWithdrawals)

Returns information about the recent withdrawal.

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(get_recent_withdraw_status(client, asset="DOT"))
Dict{String,Any}(
    "method": =>"Bitcoin",
    "aclass" => "currency",
    "asset" => "XXBT",
    "refid" => "AGBZNBO-5P2XSB-RFVF6J",
    "txid" => "THVRQM-33VKH-UCI7BS",
    "info" => "mzp6yUVMRxfasyfwzTZjjy38dHqMX7Z3GR",
    "amount" => "0.72485000",
    "fee" => "0.00015000",
    "time" => 1617014586,
    "status" => "Pending"
)
```
"""
function get_recent_withdraw_status(
    client::SpotBaseRESTAPI;
    asset::String,
    method::Union{String,Nothing}=nothing
)
    params = Dict{String,Any}("asset" => asset)
    !isnothing(method) ? params["method"] = method : nothing
    return request(client, "POST", "/private/WithdrawStatus", data=params, auth=true)
end

"""
    cancel_withdraw(client::SpotBaseRESTAPI; asset::String, refid::String)

Kraken Docs: [https://docs.kraken.com/rest/#operation/cancelWithdrawal](https://docs.kraken.com/rest/#operation/cancelWithdrawal)

Cancels a withdrawal by `refid`. The `refid` returned by [`withdraw_funds`](@ref) when initiating a withdraw.
Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> cancel_withdraw(client, asset="DOT", refid="VGBNO6T-KFPTAQ-LAKGA6")
true
```
"""
function cancel_withdraw(client::SpotBaseRESTAPI; asset::String, refid::String)
    return request(client, "POST", "/private/WithdrawCancel", data=Dict{String,Any}(
            "asset" => asset,
            "refid" => refid
        ), auth=true)
end

"""
    wallet_transfer(
        client::SpotBaseRESTAPI;
        asset::String,
        from::String,
        to::String,
        amount::Union{Float64,Int64,String}
    )

Kraken Docs: [https://docs.kraken.com/rest/#operation/walletTransfer](https://docs.kraken.com/rest/#operation/walletTransfer)

Enables the transfer of assets between different wallets e.g. from Spot to Futures wallet.

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(wallet_transfer(
...        client,
...        asset="XLM",
...        from="Spot Wallet",
...        to="Futures Wallet",
...        amount=200
...    ))
Dict{String,Any}("refid" => "AJGLAE5-KSKMGR4-VPNPNV")
```
"""
function wallet_transfer(
    client::SpotBaseRESTAPI;
    asset::String,
    from::String,
    to::String,
    amount::Union{Float64,Int64,String}
)
    return request(client, "POST", "/private/WalletTransfer", data=Dict{String,Any}(
            "asset" => asset,
            "from" => from,
            "to" => to,
            "amount" => string(amount)
        ), auth=true)
end
end