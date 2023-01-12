"""
    SpotStakingModule

Enables accessing Spot staking endpoints using predefined methods.
"""
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

Kraken Docs: [https://docs.kraken.com/rest/#operation/stake](https://docs.kraken.com/rest/#operation/stake)

Initiates a staking action for a desired `asset`.

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(stake_asset(client, asset="DOT", amount=2000, method="polkadot-staked"))
Dict{String,Any}("refid" => "ABFPN4-KSKVP4-VPNALT")
```
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

Kraken Docs: [https://docs.kraken.com/rest/#operation/unstake](https://docs.kraken.com/rest/#operation/unstake)

Enables the unstaking of a staked `asset`.

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(unstake_asset(client, asset="DOT", amount=2000))
Dict{String,Any}("refid" => "GT01XVK-1VCDWO-7HR18B")
```
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

Kraken Docs: [https://docs.kraken.com/rest/#operation/getStakingAssetInfo](https://docs.kraken.com/rest/#operation/getStakingAssetInfo)

Lists the available assets to stake.

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(list_stakeable_assets(client))
Any[Dict{String,Any}(
    "method" => "polkadot-staked",
    "asset" => "DOT",
    "staking_asset": "DOT.S",
    "rewards" => Dict{String,ANy}()
        "reward" => "12.00",
        "type" => "percentage"
    ),
    "on_chain" => true,
    "can_stake" => true,
    "can_unstake" => true,
    "minimum_amount" => Dict{String,Any}(
        "staking" => "0.0000000000",
        "unstaking" => "0.0000000000"
    )
), ...]
```
"""
function list_stakeable_assets(client::SpotBaseRESTAPI)
    return request(client, "POST", "/private/Staking/Assets", auth=true)
end

"""
    get_pending_staking_transactions(client::SpotBaseRESTAPI)

Kraken Docs: [https://docs.kraken.com/rest/#operation/getStakingPendingDeposits](https://docs.kraken.com/rest/#operation/getStakingPendingDeposits)

Returns a list of pending staking transactions of this user.

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(get_pending_staking_transactions(client))
Any[Dict{String,Any}(
    "method" => "polkadot-staked",
    "aclass" => "currency",
    "asset" => "DOT.S",
    "refid" => "CN1EVQO-MOWU97-89F1D5",
    "amount" => "2010",
    "fee" => "0.01",
    "time" => 1622988877,
    "status" => "Initial",
    "type" => "bonding"
), ...]
```
"""
function get_pending_staking_transactions(client::SpotBaseRESTAPI)
    return request(client, "POST", "/private/Staking/Pending", auth=true)
end

"""
    list_staking_transactions(client::SpotBaseRESTAPI)

Kraken Docs: [https://docs.kraken.com/rest/#operation/getStakingTransactions](https://docs.kraken.com/rest/#operation/getStakingTransactions)

Returns the list of staking transactions for this user.

Authenticated `client` required

# Examples

```julia-repl
julia> client = SpotBaseRESTAPI(key="api-key", secret="secret-key")
julia> println(list_staking_transactions(client))
Any[Dict{String,Any}(
    "method" => "xbt-staked",
    "aclass" => "currency",
    "asset" => "XBT.M",
    "refid" => "2BPOYNJ-Q3P855-5B9BL4",
    "amount" => "0.612",
    "fee" => "0.0000000000",
    "time" => 1623132481,
    "status" => "Success",
    "type" => "bonding",
    "bond_start" => 1623132481,
    "bond_end" => 1623132481
), ...]
```
"""
function list_staking_transactions(client::SpotBaseRESTAPI)
    return request(client, "POST", "/private/Staking/Transactions", auth=true)
end
end
