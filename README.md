<h1 align="center">Futures and Spot Websocket and REST API Julia SDK for the Kraken Cryptocurrency Exchange 🐙</h1>

<div align="center">

[![GitHub](https://badgen.net/badge/icon/github?icon=github&label)](https://github.com/btschwertfeger/KrakenEx.jl)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-orange.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Generic badge](https://img.shields.io/badge/julia-1.8+-orange.svg)](https://shields.io/)

[![CI](https://github.com/btschwertfeger/KrakenEx.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/btschwertfeger/KrakenEx.jl/actions/workflows/CI.yml)
[![Documentation](https://github.com/btschwertfeger/KrakenEx.jl/actions/workflows/Documentation.yml/badge.svg)](https://github.com/btschwertfeger/KrakenEx.jl/actions/workflows/Documentation.yml)

</div>

<h3>
This is an unofficial collection of REST and websocket clients for Spot and Futures trading on the Kraken cryptocurrency exchange using Julia.

This project is based on the [python-kraken-sdk](https://github.com/btschwertfeger/python-kraken-sdk).

</h3>

---

## 📌 Disclaimer

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
- extensive example scripts (see `/examples`)

---

## Table of Contents

- [ Installation and setup ](#installation)
- [ Spot Client Example Usage ](#spotusage)
  - [REST API](#spotrest)
  - [Websockets](#spotws)
- [ Futures Client Example Usage ](#futuresusage)
  - [REST API](#futuresrest)
  - [Websockets](#futuresws)
- [ Base Clients Documentation ](#baseclients)
- [ Spot Client Documentation ](#spotdocu)
  - [ User Module ](#spotuser)
  - [ Trade Module ](#spottrade)
  - [ Market Module ](#spotmarket)
  - [ Funding Module ](#spotfunding)
  - [ Staking Module ](#spotstaking)
  - [ WebSocket Module ](#spotwsclient)
- [ Futures Client Documentation ](#futuresdocu)
  - [ User Module ](#futuresuser)
  - [ Trade Module ](#futurestrade)
  - [ Market Module ](#futuresmarket)
  - [ Funding Module ](#futuresfunding)
  - [ WebSocket Module ](#futureswsclient)
- [ Troubleshooting ](#trouble)
- [ Notes ](#notes)
- [ References ](#references)

---

<a name="installation"></a>

# 🛠 Installation and setup

### 1. Install the Julia Package:

```julia
using Pkg; Pkg.add("KrakenEx")
```

### 2. Register at Kraken and generate API Keys:

- Spot Trading: https://www.kraken.com/u/security/api
- Futures Trading: https://futures.kraken.com/trade/settings/api
- Futures Sandbox: https://demo-futures.kraken.com/settings/api

### 3. Start using the provided example scripts

### 4. Error handling

If any unexpected behavior occurs, please check <b style="color: yellow">your API permissions</b>, <b style="color: yellow">rate limits</b>, update the KrakenEx.jl SDK, see the [Troubleshooting](#trouble) section, and if the error persits please open an issue.

---

<a name="spotusage"></a>

# 📍 Spot Client Example Usage

<a name="spotrest"></a>

## Spot REST API

... can be found in `/examples/spot_rest_examples.jl`

```julia
using KrakenEx: SpotBaseRESTAPI

using KrakenEx.SpotMarketModule
using KrakenEx.SpotUserModule
using KrakenEx.SpotTradeModule
using KrakenEx.SpotFundingModule
using KrakenEx.SpotStakingModule
# you can also import all specific functions separate like shown in `/examples/spot_rest_examples.jl`

function main()
    key = "Kraken-public-key"
    secret = "Kraken-secret-key"

    client = SpotBaseRESTAPI() # public client
    private_client = SpotBaseRESTAPI(
        key=key,
        secret=secret
    ) # authenticated client

    #===== User Endpoints =====#
    println(get_account_balance(private_client))
    println(get_open_orders(private_client))
    # ...

    #===== Market Endpoints =====#
    println(get_assets(client))
    println(get_tradable_asset_pair(client, pair=["XBTUSD", "DOTUSD"]))
    println(get_ticker(client, pair="DOTUSD"))
    # ...

    #===== Trade Endpoints =====#
    println(
        create_order(
            private_client,
            ordertype="limit",
            side="buy",
            volume=1,
            pair="XBTUSD",
            price="10",
            oflags="post",
            validate=true
        )
    )
    # ...

    #===== Funding Endpoints =====#
    println(get_deposit_methods(private_client, asset="DOT"))
    println(get_deposit_address(private_client, asset="DOT", method="Polkadot"))
    # ...

    #===== Staking Endpoints =====#
    println(list_stakeable_assets(private_client))
    println(stake_asset(
        private_client, asset="DOT", amount=20000, method="polkadot-staked"
    ))
    # ...
end

main()
```

<a name="spotws"></a>

## Websockets

... can be found in `/examples/spot_websocket_example.jl`

```julia

using KrakenEx
using KrakenEx.SpotWebSocketModule:
    SpotWebSocketClient,
    connect,
    subscribe, unsubscribe

function main()
    key = "Kraken-public-key"
    secret = "Kraken-secret-key"

    ws_client = SpotWebSocketClient(key, secret)

    function on_message(msg::Union{Dict{String,Any},String})
        println(msg)
        # implement your strategy here....

        #=
            Dont forget that you can also access public rest endpoints here.
            If the `ws_client` instance is authenticated, you can also
            use private endpoints:

        KrakenEx.SpotMarketModule.cancel_order(
            ws_client.rest_client,
            txid="XXXXXX-XXXXXX-XXXXXX"
        )
        =#
    end

    # the conn will create a public and a private websocket connection
    con = @async connect(ws_client, callback=on_message, private=true)

    #== Subscribe to public and private websocket feeds ==#
    subscribe(
        client=ws_client,
        subscription=Dict{String,Any}("name" => "ticker"),
        pairs=["XBT/USD", "DOT/USD"]
    )

    subscribe(
        client=ws_client,
        subscription=Dict{String,Any}("name" => "ownTrades")
    )

    # wait before unsubscribe is done ...
    sleep(2)

    #== Unsubscribe from public and private websocket feeds ==#
    # unsubscribe(
    #     client=ws_client,
    #     subscription=Dict{String,Any}("name" => "ticker"),
    #     pairs=["XBT/USD", "DOT/USD"]
    # )
    # unsubscribe(
    #     client=ws_client,
    #     subscription=Dict{String,Any}("name" => "ownTrades")
    # )

    # to cancel a connection you can use:
    # ws_client.cancel_private_connection = true
    # ws_client.cancel_public_connection = true

    wait(con)
end

main()
```

---

<a name="futuresusage"></a>

# 📍 Futures Client Example Usage

Kraken provides a sandbox environment at https://demo-futures.kraken.com for paper trading. When using this API keys you have to set the `DEMO` parameter to `true` when instantiating the respecitve client.

<a name="futuresrest"></a>

## Futures REST API

The following example can be found in `/examples/futures_rest_examples.jl`.

```julia
using KrakenEx: FuturesBaseRESTAPI

using KrakenEx.FuturesMarketModule
using KrakenEx.FuturesUserModule
using KrakenEx.FuturesTradeModule
using KrakenEx.FuturesFundingModule

function main()

    # private clients can also access public endpoints
    private_client = FuturesBaseRESTAPI(
        key="Kraken-public-key",
        secret="Kraken-secret-key"
    )

    # sandbox_client = FuturesBaseRESTAPI(
    #     API_KEY=key,
    #     SECRET_KEY=secret,
    #     DEMO=true
    # )

    #==== User Endpoints ====#
    println(get_wallets(private_client))
    println(get_open_orders(private_client))
    log = get_account_log_csv(client)
    open("myAccountLog.csv", "w") do io
        write(io, log)
    end
    # ...

    #==== Market Endpoints ====#
    println(get_ohlc(private_client,
        tick_type="trade",
        symbol="PI_XBTUSD",
        resolution="1m",
        from=1668989233,
        to=1668999233
    ))
    # ...

    #==== Trade Endpoints ====#
    println(create_order(private_client,
        orderType="lmt",
        side="buy",
        size=1,
        limitPrice=4,
        symbol="pf_bchusd",
    ))

    println(create_batch_order(client, batchorder_list=[
        Dict{String,Any}(
            "order" => "send",
            "order_tag" => "1",
            "orderType" => "lmt",
            "symbol" => "PI_XBTUSD",
            "side" => "buy",
            "size" => 1,
            "limitPrice" => 1.00,
            "cliOrdId" => "my-another-client-id"
        ),
        Dict{String,Any}(
            "order" => "send",
            "order_tag" => "2",
            "orderType" => "stp",
            "symbol" => "PI_XBTUSD",
            "side" => "buy",
            "size" => 1,
            "limitPrice" => 2.00,
            "stopPrice" => 3.00,
        ),
        Dict{String,Any}(
            "order" => "send",
            "order_tag" => "2",
            "orderType" => "stp",
            "symbol" => "PI_XBTUSD",
            "side" => "buy",
            "size" => 1,
            "limitPrice" => 2.00,
            "stopPrice" => 3.00,
        ),
        Dict{String,Any}(
            "order" => "cancel",
            "order_id" => "e35d61dd-8a30-4d5f-a574-b5593ef0c050",
        ),
        Dict{String,Any}(
            "order" => "cancel",
            "cliOrdId" => "my_client_id1234"
        )
    ]))

    println(cancel_all_orders(private_client))
    # ...

    #==== Funding Endpoints ====#
    println(get_historical_funding_rates(private_client, symbol="PI_XBTUSD"))
    # ...
end

main()
```

<a name="futuresws"></a>

## Futures Websocket Client

The following example can be found in `/examples/futures_websocket_example.jl`.

```julia
using KrakenEx
using .KrakenEx.FuturesWebSocketModule:
    FuturesWebSocketClient,
    connect,
    subscribe, unsubscribe

function main()
    key = "Kraken-public-key"
    secret = "Kraken-secret-key"
    ws_client = FuturesWebSocketClient(key, secret)

    function on_message(msg::Union{Dict{String,Any},String})
        println(msg)
        # implement your strategy here....

        #=
            Dont forget that you can also access public rest endpoints here.
            If the `ws_client` instance is authenticated, you can also
            use private endpoints:

        KrakenEx.FuturesMarketModule.cancel_order(
            ws_client.rest_client,
            txid="XXXXXX-XXXXXX-XXXXXX"
        )
        =#
    end

    #=
     `connect` can establish a private and a public connection at the same time.
     You can turn off either the private or the public connection
      using `private=false` or `public=false`.
    =#
    con = @async connect(ws_client, callback=on_message, private=true)

    #== Subscribe to public and private websocket feeds ==#

    # public feeds
    products::Vector{String} = ["PI_XBTUSD", "PF_SOLUSD"]
    subscribe(client=ws_client, feed="ticker", products=products)
    # subscribe(client=ws_client, feed="ticker", products=products)
    # subscribe(client=ws_client, feed="book", products=products)
    # subscribe(client=ws_client, feed="trade", products=products)
    # subscribe(client=ws_client, feed="ticker_lite", products=products)
    # subscribe(client=ws_client, feed="heartbeat")
    # ...

    # private feeds
    subscribe(client=ws_client, feed="fills")
    # subscribe(client=ws_client, feed="open_positions")
    subscribe(client=ws_client, feed="open_orders")
    # subscribe(client=ws_client, feed="open_orders_verbose")
    # subscribe(client=ws_client, feed="deposits_withdrawals")
    # subscribe(client=ws_client, feed="account_balances_and_margins")
    # subscribe(client=ws_client, feed="balances")
    # subscribe(client=ws_client, feed="account_log")
    # subscribe(client=ws_client, feed="notifications_auth")
    # ...

    # wait before unsubscribe is done ...
    sleep(2)

    #== Unsubscribe from public and private websocket feeds ==#
    unsubscribe(client=ws_client, feed="ticker", products=["PF_SOLUSD"])
    # unsubscribe(client=ws_client, feed="ticker", products=["PF_XBTUSD"])
    # unsubscribe(client=ws_client, feed="fills")
    # unsubscribe(client=ws_client, feed="open_orders")
    # ...

    # to cancel a connection you can use:
    # ws_client.cancel_private_connection = true
    # ws_client.cancel_public_connection = true
    # ...

    wait(con)
end

main()
```

Note: Authenticated Futures websocket clients can also un/subscribe from/to public feeds.

---

<a name="baseclients"></a>

# 📍 Base Clients Documentation

`KrakenEx`
| Type | Documentation |
| -------------------------- | --------------------------------------------------------- |
|`SpotBaseRESTAPI` | Base client for all Spot REST endpoints|
|`FuturesBaseRESTAPI`|Base client for all Futures REST endpoints|

<a name="spotdocu"></a>

# 📖 Spot Client Documentation

<a name="spotuser"></a>

## SpotUserModule

`KrakenEx.SpotUserModule`

| Method                     | Documentation                                             |
| -------------------------- | --------------------------------------------------------- |
| `get_account_balance`      | https://docs.kraken.com/rest/#operation/getAccountBalance |
| `get_trade_balance`        | https://docs.kraken.com/rest/#operation/getTradeBalance   |
| `get_open_orders`          | https://docs.kraken.com/rest/#operation/getOpenOrders     |
| `get_closed_orders`        | https://docs.kraken.com/rest/#operation/getClosedOrders   |
| `get_orders_info`          | https://docs.kraken.com/rest/#operation/getOrdersInfo     |
| `get_trades_history`       | https://docs.kraken.com/rest/#operation/getTradeHistory   |
| `get_trades_info`          | https://docs.kraken.com/rest/#operation/getTradesInfo     |
| `get_open_positions`       | https://docs.kraken.com/rest/#operation/getOpenPositions  |
| `get_ledgers_info`         | https://docs.kraken.com/rest/#operation/getLedgers        |
| `get_ledgers`              | https://docs.kraken.com/rest/#operation/getLedgersInfo    |
| `get_trade_volume`         | https://docs.kraken.com/rest/#operation/getTradeVolume    |
| `request_export_report`    | https://docs.kraken.com/rest/#operation/addExport         |
| `get_export_report_status` | https://docs.kraken.com/rest/#operation/exportStatus      |
| `retrieve_export`          | https://docs.kraken.com/rest/#operation/retrieveExport    |
| `delete_export_report`     | https://docs.kraken.com/rest/#operation/removeExport      |

<a name="spottrade"></a>

## SpotTradeModule

`KrakenEx.SpotTradeModule`

| Method                      | Documentation                                                |
| --------------------------- | ------------------------------------------------------------ |
| `create_order`              | https://docs.kraken.com/rest/#operation/addOrder             |
| `create_order_batch`        | https://docs.kraken.com/rest/#operation/addOrderBatch        |
| `edit_order`                | https://docs.kraken.com/rest/#operation/editOrder            |
| `cancel_order`              | https://docs.kraken.com/rest/#operation/cancelOrder          |
| `cancel_all_orders`         | https://docs.kraken.com/rest/#operation/cancelAllOrders      |
| `cancel_all_orders_after_x` | https://docs.kraken.com/rest/#operation/cancelAllOrdersAfter |
| `cancel_order_batch`        | https://docs.kraken.com/rest/#operation/cancelOrderBatch     |

<a name="spotmarket"></a>

## SpotMarketModule

`KrakenEx.SpotMarketModule`

| Method                    | Documentation                                                 |
| ------------------------- | ------------------------------------------------------------- |
| `get_assets`              | https://docs.kraken.com/rest/#operation/getAssetInfo          |
| `get_tradable_asset_pair` | https://docs.kraken.com/rest/#operation/getTradableAssetPairs |
| `get_ticker`              | https://docs.kraken.com/rest/#operation/getTickerInformation  |
| `get_ohlc`                | https://docs.kraken.com/rest/#operation/getOHLCData           |
| `get_order_book`          | https://docs.kraken.com/rest/#operation/getOrderBook          |
| `get_recent_trades`       | https://docs.kraken.com/rest/#operation/getRecentTrades       |
| `get_recend_spreads`      | https://docs.kraken.com/rest/#operation/getRecentSpreads      |
| `get_system_status`       | checks if Kraken is online                                    |

<a name="spotfunding"></a>

## SpotFundingModule

`KrakenEx.SpotFundingModule`

| Method                       | Documentation                                                      |
| ---------------------------- | ------------------------------------------------------------------ |
| `get_deposit_methods`        | https://docs.kraken.com/rest/#operation/getDepositMethods          |
| `get_deposit_address`        | https://docs.kraken.com/rest/#operation/getDepositAddresses        |
| `get_recend_deposits_status` | https://docs.kraken.com/rest/#operation/getStatusRecentDeposits    |
| `get_withdrawal_info`        | https://docs.kraken.com/rest/#operation/getWithdrawalInformation   |
| `withdraw_funds`             | https://docs.kraken.com/rest/#operation/withdrawFund               |
| `get_recend_withdraw_status` | https://docs.kraken.com/rest/#operation/getStatusRecentWithdrawals |
| `cancel_withdraw`            | https://docs.kraken.com/rest/#operation/cancelWithdrawal           |
| `wallet_transfer`            | https://docs.kraken.com/rest/#operation/walletTransfer             |

<a name="spotstaking"></a>

## SpotStakingModule

`KrakenEx.SpotStakingModule`

| Method                             | Documentation                                                     |
| ---------------------------------- | ----------------------------------------------------------------- |
| `stake_asset`                      | https://docs.kraken.com/rest/#operation/stake                     |
| `unstake_asset`                    | https://docs.kraken.com/rest/#operation/unstake                   |
| `list_stakeable_assets`            | https://docs.kraken.com/rest/#operation/getStakingAssetInfo       |
| `get_pending_staking_transactions` | https://docs.kraken.com/rest/#operation/getStakingPendingDeposits |
| `list_staking_transactions`        | https://docs.kraken.com/rest/#operation/getStakingTransactions    |

<a name="spotwsclient"></a>

## SpotWebSocketModule

`KrakenEx.SpotWebSocketModule`

| Method                    | Documentation                                                              |
| ------------------------- | -------------------------------------------------------------------------- |
| `SpotWebSocketClient`     | structure to store data - this is needed for the `connect` function below. |
| `connect`                 | Can create a public and private websoket connection.                       |
| `subscribe`               | https://docs.kraken.com/websockets/#message-subscribe                      |
| `unsubscribe`             | https://docs.kraken.com/websockets/#message-unsubscribe                    |
| `create_order`            | https://docs.kraken.com/websockets/#message-addOrder                       |
| `edit_order`              | https://docs.kraken.com/websockets/#message-editOrder                      |
| `cancel_order`            | https://docs.kraken.com/websockets/#message-cancelOrder                    |
| `cancel_all_orders`       | https://docs.kraken.com/websockets/#message-cancelAll                      |
| `cancel_all_orders_after` | https://docs.kraken.com/websockets/#message-cancelAllOrdersAfter           |

---

<a name="futuresdocu"></a>

# 📖 Futures Client Documentation

<a name="futuresuser"></a>

## FuturesUserModule

`KrakenEx.FuturesUserModule`

| Method                | Documentation                                                                                                        |
| --------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `get_wallets`         | https://docs.futures.kraken.com/#http-api-trading-v3-api-account-information-get-wallets                             |
| `get_open_orders`     | https://docs.futures.kraken.com/#http-api-trading-v3-api-account-information-get-open-orders                         |
| `get_open_positions`  | https://docs.futures.kraken.com/#http-api-trading-v3-api-account-information-get-open-positions                      |
| `get_subaccounts`     | https://docs.futures.kraken.com/#http-api-trading-v3-api-account-information-get-subaccounts                         |
| `get_unwindqueue`     | https://docs.futures.kraken.com/#http-api-trading-v3-api-account-information-get-position-percentile-of-unwind-queue |
| `get_notificatios`    | https://docs.futures.kraken.com/#http-api-trading-v3-api-general-get-notifications                                   |
| `get_account_log`     | https://docs.futures.kraken.com/#http-api-history-account-log                                                        |
| `get_account_log_csv` | https://docs.futures.kraken.com/#http-api-history-account-log-get-recent-account-log-csv                             |

<a name="futurestrade"></a>

## FuturesTradeModule

`KrakenEx.FuturesTradeModule`

| Method               | Documentation                                                                                                        |
| -------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `get_fills`          | https://docs.futures.kraken.com/#http-api-trading-v3-api-historical-data-get-your-fills                              |
| `create_batch_order` | https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-batch-order-management                     |
| `cancel_all_orders`  | https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-cancel-all-orders                          |
| `dead_mans_switch`   | https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-dead-man-39-s-switch                       |
| `cancel_order`       | https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-cancel-order                               |
| `edit_order`         | https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-edit-order                                 |
| `get_orders_status`  | https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-get-the-current-status-for-specific-orders |
| `create_order`       | https://docs.futures.kraken.com/#http-api-trading-v3-api-order-management-send-order                                 |

<a name="futuresmarket"></a>

## FuturesMarketModule

`KrakenEx.FuturesMarketModule`

| Method                         | Documentation                                                                                                                                                                                               |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `get_ohlc`                     | https://docs.futures.kraken.com/#http-api-charts-ohlc-get-ohlc                                                                                                                                              |
| `get_tick_types`               | https://docs.futures.kraken.com/#http-api-charts-ohlc-get-tick-types                                                                                                                                        |
| `get_tradeable_products`       | https://docs.futures.kraken.com/#http-api-charts-ohlc-get-tradeable-products                                                                                                                                |
| `get_resolutions`              | https://docs.futures.kraken.com/#http-api-charts-ohlc-get-resolutions                                                                                                                                       |
| `get_fee_schedules`            | https://docs.futures.kraken.com/#http-api-trading-v3-api-fee-schedules-get-fee-schedules                                                                                                                    |
| `get_fee_schedules_vol`        | https://docs.futures.kraken.com/#http-api-trading-v3-api-fee-schedules-get-fee-schedule-volumes                                                                                                             |
| `get_orderbook`                | https://docs.futures.kraken.com/#http-api-trading-v3-api-market-data-get-orderbook                                                                                                                          |
| `get_tickers`                  | https://docs.futures.kraken.com/#http-api-trading-v3-api-market-data-get-tickers                                                                                                                            |
| `get_instruments`              | https://docs.futures.kraken.com/#http-api-trading-v3-api-instrument-details-get-instruments                                                                                                                 |
| `get_instruments_status`       | https://docs.futures.kraken.com/#http-api-trading-v3-api-instrument-details-get-instrument-status-list and https://docs.futures.kraken.com#http-api-trading-v3-api-instrument-details-get-instrument-status |
| `get_trade_history`            | https://docs.futures.kraken.com/#http-api-trading-v3-api-market-data-get-trade-history                                                                                                                      |
| `get_leverage_preference`      | https://docs.futures.kraken.com/#http-api-trading-v3-api-multi-collateral-get-the-leverage-setting-for-a-market                                                                                             |
| `set_leverage_preference`      | https://docs.futures.kraken.com/#http-api-trading-v3-api-multi-collateral-set-the-leverage-setting-for-a-market                                                                                             |
| `get_pnl_preference`           | https://docs.futures.kraken.com/#http-api-trading-v3-api-multi-collateral-get-pnl-currency-preference-for-a-market                                                                                          |
| `set_pnl_preference`           | https://docs.futures.kraken.com/#http-api-trading-v3-api-multi-collateral-set-pnl-currency-preference-for-a-market                                                                                          |
| `get_execution_events`         | https://docs.futures.kraken.com/#http-api-history-market-history-get-execution-events                                                                                                                       |
| `get_public_execution_events`  | https://docs.futures.kraken.com/#http-api-history-market-history-get-public-execution-events and https://support.kraken.com/hc/en-us/articles/4401755685268-Market-History-Executions                       |
| `get_public_order_events`      | https://docs.futures.kraken.com/#http-api-history-market-history-get-public-order-events and https://support.kraken.com/hc/en-us/articles/4401755906452-Market-History-Orders                               |
| `get_public_mark_price_events` | https://docs.futures.kraken.com/#http-api-history-market-history-get-public-mark-price-events and https://support.kraken.com/hc/en-us/articles/4401748276116-Market-History-Mark-Price                      |
| `get_order_events`             | https://docs.futures.kraken.com/#http-api-history-market-history-get-order-events                                                                                                                           |
| `get_trigger_events`           | https://docs.futures.kraken.com/#http-api-history-market-history-get-trigger-events                                                                                                                         |

<a name="futuresfunding"></a>

## FuturesFundingModule

`KrakenEx.FuturesFundingModule`

| Method                               | Documentation                                                                                            |
| ------------------------------------ | -------------------------------------------------------------------------------------------------------- |
| `get_historical_funding_rates`       | https://docs.futures.kraken.com/#http-api-trading-v3-api-historical-funding-rates-historicalfundingrates |
| `initiate_wallet_transfer`           | https://docs.futures.kraken.com/#http-api-trading-v3-api-transfers-initiate-wallet-transfer              |
| `initiate_subccount_transfer`        | https://docs.futures.kraken.com/#http-api-trading-v3-api-transfers-initiate-sub-account-transfer         |
| `initiate_withdrawal_to_spot_wallet` | https://docs.futures.kraken.com/#http-api-trading-v3-api-transfers-initiate-withdrawal-to-spot-wallet    |

<a name="futureswsclient"></a>

## FuturesWebSocketModule

`KrakenEx.FuturesWebSocketModule`

| Method                   | Documentation                                                  |
| ------------------------ | -------------------------------------------------------------- |
| `FuturesWebSocketClient` | structure which is needed to use the `connect` function below. |
| `subscribe`              | subscribe to a feed                                            |
| `unsubscribe`            | unsubscribe from a feed                                        |
| `connect`                | function to establish websock connections                      |

---

<a name="trouble"></a>

# 🚨 Troubleshooting

- Check if your version of <b>KrakenEx.jl version</b> is the newest.
- Check the <b>permissions of your API keys</b> and the required permissions on the respective endpoints.
- If you get some cloudflare or <b>rate limit errors</b>, please check your Kraken Tier level and maybe apply for a higher rank if required.
- <b>Use different API keys for different algorithms</b>, because the nonce calculation is based on timestamps and a sent nonce must always be the highest nonce ever sent of that API key. Having multiple algorithms using the same keys will result in invalid nonce errors.

---

<a name="notes"></a>

# 📝 Notes:

- Pull requests will be ignored until the owner finished the core idea

- Coding standards are not always followed to make arguments and function names as similar as possible to those in the Kraken API documentations.

- When calling endpoints for examlpe the futures funding endpoint and you submit spaces, braces,... in strings like `" )|] "` a KrakenAuthenticationError will be raised.

<a name="references"></a>

# 🔭 References

- https://docs.kraken.com/rest
- https://docs.kraken.com/websockets
- https://docs.futures.kraken.com
- https://support.kraken.com/hc/en-us/sections/360012894412-Futures-API

---
