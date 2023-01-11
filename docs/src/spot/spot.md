```@meta
   CurrentModule = KrakenEx
```

# Kraken Spot REST API

The listed modules and functions allow to access public and private (authenticated) endpoints of the official Kraken Spot API.
All functions of these endpoints require a [`SpotBaseRESTAPI`](@ref KrakenEx.SpotBaseAPIModule.SpotBaseRESTAPI) instance.

The sample outputs are for illustrative purposes only and may vary depending on the user, request, and market behavior.

```@contents
Pages = ["spot.md"]
```

## SpotBaseRESTAPI

```@docs
KrakenEx.SpotBaseAPIModule.SpotBaseRESTAPI
```

## Market

```@autodocs
Modules = [KrakenEx.SpotMarketModule]
Private = false
Order = [:module, :type, :function, :macro]
```

## User

```@autodocs
Modules = [KrakenEx, KrakenEx.SpotUserModule]
Private = false
Order = [:module, :type, :function, :macro]
```

## Trade

```@autodocs
Modules = [KrakenEx.SpotTradeModule]
Private = false
Order = [:module, :type, :function, :macro]
```

## Funding

```@autodocs
Modules = [KrakenEx.SpotFundingModule]
Private = false
Order = [:module, :type, :function, :macro]
```

## Staking

```@autodocs
Modules = [KrakenEx.SpotStakingModule]
Private = false
Order = [:module, :type, :function, :macro]
```
