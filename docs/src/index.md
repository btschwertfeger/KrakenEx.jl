```@meta
   CurrentModule = KrakenEx
```

# KrakenEx.jl

Futures and Spot Websocket and REST API Julia SDK for the Kraken Cryptocurrency Exchange 🐙

[![GitHub](https://badgen.net/badge/icon/github?icon=github&label)](https://github.com/btschwertfeger/KrakenEx.jl)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-orange.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Generic badge](https://img.shields.io/badge/julia-1.8+-orange.svg)](https://shields.io/)
[![version](https://juliahub.com/docs/KrakenEx/version.svg)](https://juliahub.com/ui/Packages/KrakenEx/C18NY)
[![CI](https://github.com/btschwertfeger/KrakenEx.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/btschwertfeger/KrakenEx.jl/actions/workflows/CI.yml)
[![Documentation](https://github.com/btschwertfeger/KrakenEx.jl/actions/workflows/Documentation.yml/badge.svg)](https://github.com/btschwertfeger/KrakenEx.jl/actions/workflows/Documentation.yml)

> ⚠️ This is an unofficial collection of REST and websocket clients for Spot and Futures trading on the Kraken cryptocurrency exchange using Julia. Payward Ltd. and Kraken are in no way associated with the authors of this module and documentation.

This project is based on the [python-kraken-sdk](https://github.com/btschwertfeger/python-kraken-sdk).

## Disclaimer

There is no guarantee that this software will work flawlessly at this or later times. Of course, no responsibility is taken for possible profits or losses. This software probably has some errors in it, so use it at your own risk. Also no one should be motivated or tempted to invest assets in speculative forms of investment. By using this software you release the author(s) from any liability regarding the use of this software.

---

## Features

Clients:

- Spot REST Clients
- Spot Websocket Client
- Futures REST Clients
- Futures Websocket Client

General:

- access both public and private endpoints
- responsive error handling and custom exceptions
- extensive example scripts (see [https://github.com/btschwertfeger/KrakenEx.jl](https://github.com/btschwertfeger/KrakenEx.jl))

---

## Installation and setup

### 1. Install the Julia Package:

```julia-repl
julia> using Pkg; Pkg.add("KrakenEx")
```

### 2. Register at Kraken and generate API Keys:

- Spot Trading: [ttps://www.kraken.com/u/security/api](https://www.kraken.com/u/security/api)
- Futures Trading: [https://futures.kraken.com/trade/settings/api](https://futures.kraken.com/trade/settings/api)
- Futures Sandbox: [https://demo-futures.kraken.com/settings/api](https://demo-futures.kraken.com/settings/api)

### 3. Start using the provided example scripts

- [Kraken Spot Examples](@ref)
- [Kraken Futures Examples](@ref)

### 4. Error handling

If any unexpected behavior occurs, please check your API permissions, rate limits, update the [KrakenEx.jl](@ref) package, see the [Troubleshooting](@ref) Troubleshooting section, and if the error persits please open an issue on GitHub.

---

## Troubleshooting

- Check if your version of [KrakenEx.jl](@ref) version is the newest.
- Check the permissions of your API keys and the required permissions on the respective endpoints.
- If you get some cloudflare or rate limit errors, please check your Kraken Tier level and maybe apply for a higher rank if required.
- Use different API keys for different algorithms, because the nonce calculation is based on timestamps and a sent nonce must always be the highest nonce ever sent of that API key. Having multiple algorithms using the same keys will result in invalid nonce errors.

---

## Notes

- Coding standards are not always followed to make arguments and function names as similar as possible to those in the Kraken API documentations.

- When calling endpoints for examlpe the futures funding endpoint and you submit spaces, braces, etc in strings like `" ()[]{}|/\*.+!^"` a [`KrakenAuthenticationError`](@ref KrakenEx.ExceptionsModule.KrakenAuthenticationError) will be raised.

## References

- [https://docs.kraken.com/rest](https://docs.kraken.com/rest)
- [https://docs.kraken.com/websockets](https://docs.kraken.com/websockets)
- [https://docs.futures.kraken.com](https://docs.futures.kraken.com)
- [https://support.kraken.com/hc/en-us/sections/360012894412-Futures-API](https://support.kraken.com/hc/en-us/sections/360012894412-Futures-API)

---
