```@meta
   CurrentModule = KrakenEx
```

# Kraken Spot REST API

The listed modules and functions allow to access public and private (authenticated) endpoints of the official Kraken Spot API.
All functions of these endpoints require a [`SpotBaseRESTAPI`](@ref KrakenEx.SpotBaseAPIModule.SpotBaseRESTAPI) instance.
For accessing private endpoints valid API keys must be generated at [https://www.kraken.com/u/security/api](https://www.kraken.com/u/security/api).
Some endpoints require specific premissions enables, other may require a higer tier rank.
Please see the official Kraken documentation in the [References](@ref) section for futher information.

The sample outputs are for illustrative purposes only and may vary depending on the user, request, and market behavior.

```@contents
Pages = ["spot.md"]
```

## SpotBaseRESTAPI

```@docs
KrakenEx.SpotBaseAPIModule.SpotBaseRESTAPI
```

---

## Market

```@autodocs
Modules = [KrakenEx.SpotMarketModule]
Private = false
Order = [:module, :type, :function, :macro]
```

---

## User

```@autodocs
Modules = [KrakenEx, KrakenEx.SpotUserModule]
Private = false
Order = [:module, :type, :function, :macro]
```

---

## Trade

```@autodocs
Modules = [KrakenEx.SpotTradeModule]
Private = false
Order = [:module, :type, :function, :macro]
```

---

## Funding

```@autodocs
Modules = [KrakenEx.SpotFundingModule]
Private = false
Order = [:module, :type, :function, :macro]
```

---

## Staking

```@autodocs
Modules = [KrakenEx.SpotStakingModule]
Private = false
Order = [:module, :type, :function, :macro]
```
