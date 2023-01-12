```@meta
   CurrentModule = KrakenEx
```

# Kraken Futures REST API

The listed modules and functions allow to access public and private (authenticated) endpoints of the official Kraken Futures API. All functions of these endpoints require a [`FuturesBaseRESTAPI`](@ref) instance. For accessing private endpoints, valid API keys must be generated either using the [official Kraken API](https://futures.kraken.com/trade/settings/api) or the offical [Kraken demo/sandbox environment](https://demo-futures.kraken.com/settings/api). Some endpoints may not work using the demo account, other may require a higer tier rank. Please see the official Kraken documentation in the [References](@ref) section for futher information.

The sample outputs are for illustrative purposes only and may vary depending on the user, request and market behavior.

```@contents
Pages = ["futures.md"]
```

## FuturesBaseRESTAPI

```@docs
KrakenEx.FuturesBaseAPIModule.FuturesBaseRESTAPI
```

---

## Market

```@autodocs
Modules = [KrakenEx.FuturesMarketModule]
Private = false
Order = [:module, :type, :function, :macro]
```

---

## User

```@autodocs
Modules = [KrakenEx.FuturesUserModule]
Private = false
Order = [:module, :type, :function, :macro]
```

---

## Trade

```@autodocs
Modules = [KrakenEx.FuturesTradeModule]
Private = false
Order = [:module, :type, :function, :macro]
```

---

## Funding

```@autodocs
Modules = [KrakenEx.FuturesFundingModule]
Private = false
Order = [:module, :type, :function, :macro]
```
