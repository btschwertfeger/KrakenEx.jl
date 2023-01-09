# Kraken Futures REST API

The listed modules and functions allow to access public and private (authenticated) endpoints of the official Kraken Futures API. All functions of these endpoints require a `FuturesRESTBASEAPI` instance.

```@meta
   CurrentModule = KrakenEx
```

```@contents
Pages = ["futures.md"]
```

## FuturesBaseRESTAPI

```@docs
KrakenEx.FuturesBaseAPIModule.FuturesBaseRESTAPI
```

## Market

```@autodocs
Modules = [KrakenEx.FuturesMarketModule]
Private = false
Order = [:module, :type, :function, :macro]
```

## User

```@autodocs
Modules = [KrakenEx.FuturesUserModule]
Private = false
Order = [:module, :type, :function, :macro]
```

## Trade

```@autodocs
Modules = [KrakenEx.FuturesTradeModule]
Private = false
Order = [:module, :type, :function, :macro]
```

## Funding

```@autodocs
Modules = [KrakenEx.FuturesFundingModule]
Private = false
Order = [:module, :type, :function, :macro]
```
