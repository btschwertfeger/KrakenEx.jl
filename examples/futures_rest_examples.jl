module futures_rest_exmaples

using DotEnv

include("../src/KrakenEx.jl")
using .KrakenEx: FuturesBaseRESTAPI
using .KrakenEx.ExceptionsModule
using .KrakenEx.FuturesMarketModule:
    get_ohlc,
    get_tick_types,
    get_tradeable_products,
    get_resolutions,
    get_fee_schedules,
    get_fee_schedules_vol,
    get_orderbook,
    get_tickers,
    get_instruments,
    get_instruments_status,
    get_trade_history,
    get_leverage_preference,
    set_leverage_preference,
    get_pnl_currency_preference,
    set_pnl_currency_preference,
    get_execution_events,
    get_public_execution_events,
    get_public_order_events,
    get_public_mark_price_events,
    get_order_events,
    get_trigger_events

using .KrakenEx.FuturesUserModule:
    get_wallets,
    get_open_orders,
    get_open_positions,
    get_subaccounts,
    get_unwindqueue,
    get_notificatios,
    get_account_log,
    get_account_log_csv

using .KrakenEx.FuturesFundingModule:
    get_historical_funding_rates,
    initiate_wallet_transfer,
    initiate_subccount_transfer,
    initiate_withdrawal_to_spot_wallet

using .KrakenEx.FuturesTradeModule:
    get_fills,
    create_batch_order,
    cancel_all_orders,
    dead_mans_switch,
    cancel_order,
    edit_order,
    get_orders_status,
    create_order

function market_endpoints(client::FuturesBaseRESTAPI, private_client::FuturesBaseRESTAPI)
    println(get_ohlc(client,
        tick_type="trade",
        symbol="PI_XBTUSD",
        resolution="1m",
        from=1668989233,
        to=1668999233
    ))

    println(get_tick_types(client))

    println(get_tradeable_products(client, tick_type="mark")) # mark, spot, trade

    println(get_resolutions(
        client,
        tradeable="PI_XBTUSD",
        tick_type="spot"
    ))

    println(get_fee_schedules(client))
    println(get_fee_schedules_vol(private_client))

    println(get_orderbook(client, symbol="PI_XBTUSD"))

    println(get_tickers(client))

    println(get_instruments(client))
    println(get_instruments_status(client))
    println(get_instruments_status(client, instrument="PI_XBTUSD"))

    println(get_trade_history(client, symbol="PI_XBTUSD"))

    println(get_trade_history(client, lastTime=string(1668989233)))

    if false
        # note: This only work in sanbox environment. I may need a higher Tier 
        # println(get_leverage_preference(private_client))
        # todo: PUT request not working
        # println(set_leverage_preference(private_client, symbol="PI_XBTUSD", maxLeverage=1))

        # reset leverage settings
        # todo: PUT request not working
        # println(set_leverage_preference(private_client, symbol="PI_XBTUSD"))

        # println(get_pnl_currency_preference(private_client))
        # todo: PUT request not working
        # println(set_pnl_currency_preference(private_client, symbol="PI_XBTUSD", pnlPreference="XBT"))
    end

    println(get_execution_events(private_client))
    println(get_public_execution_events(client, tradeable="PI_XBTUSD"))
    println(get_public_order_events(client, tradeable="PI_XBTUSD"))

    println(get_public_mark_price_events(client, tradeable="PI_XBTUSD"))

    println(get_order_events(private_client))
    println(get_order_events(private_client, tradeable="PI_XBTUSD", sort="asc", before="1668989233"))

    println(get_trigger_events(private_client))
    println(get_trigger_events(private_client, tradeable="PI_XBTUSD", sort="desc", before="1668989233"))

end

function user_endpoints(client::FuturesBaseRESTAPI)
    println(get_wallets(client))
    println(get_open_orders(client))
    println(get_open_positions(client))
    println(get_subaccounts(client))
    println(get_unwindqueue(client))
    println(get_notificatios(client))
    println(get_account_log(client, before="1604937694000", info="futures liquidation"))

    log = get_account_log_csv(client)
    open("myAccountLog.csv", "w") do io
        write(io, log)
    end
end

function funding_endpoints(client)
    println(get_historical_funding_rates(client, symbol="PI_XBTUSD"))

    try
        println(initiate_wallet_transfer(client,
            amount=100,
            fromAccount="some-cash-or-margin-account",
            toAccount="another-cash-or-margin-account",
            unit="the-currency-unit-to-transfer"
        ))
    catch err
        if isa(err, KrakenException)
            println(err.message)
            if !isa(err, KrakenInvalidAccountError)
                throw(err)
            end
        end
    end

    # todo: is not working because of invalid arguments error. But the kraken documentaion was followed
    # try
    #     println(initiate_subccount_transfer(client,
    #         amount=100,#"The-amonut-to-transfer",
    #         fromAccount="abcd",#"The-wallet-cash-or-margin-account-from-which-funds-should-be-debited",
    #         fromUser="abcd",#"The-user-account-this-or-a-sub-account-from-which-funds-should-be-debited",
    #         toAccount="abcd",#"The-wallet-cash-or-margin-account-to-which-funds-should-be-credited",
    #         toUser="abcd",#"The-user-account-this-or-a-sub-account-to-which-funds-should-be-credited",
    #         unit="abcd",#"The-currency-unit-to-transfer"
    #     ))
    # catch err
    #     if isa(err, KrakenException)
    #         println(err.message)
    #         if !isa(err, KrakenInvalidAccountError)
    #             throw(err)
    #         end
    #     end
    # end

    # this does only work on the live account, not in the demo futures environment

    # todo: is not working because of reponse.status 503
    # println(initiate_withdrawal_to_spot_wallet(client,
    #     amount=100,
    #     currency="USDT",
    #     # sourceWallet="cash"
    # ))
end

function trade_endpoints(client::FuturesBaseRESTAPI)
    error("make shure that you want to execute the trade endpoints!")
    return

    if false
        # println(get_fills(client))
        # println(get_fills(client, lastFillTime="2020-07-22T13:37:27.077Z"))
        # println(create_batch_order(client, batchorder_list=[
        #     Dict{String,Any}(
        #         "order" => "send",
        #         "order_tag" => "1",
        #         "orderType" => "lmt",
        #         "symbol" => "PI_XBTUSD",
        #         "side" => "buy",
        #         "size" => 1,
        #         "limitPrice" => 1.00,
        #         "cliOrdId" => "my-another-client-id"
        #     ),
        #     Dict{String,Any}(
        #         "order" => "send",
        #         "order_tag" => "2",
        #         "orderType" => "stp",
        #         "symbol" => "PI_XBTUSD",
        #         "side" => "buy",
        #         "size" => 1,
        #         "limitPrice" => 2.00,
        #         "stopPrice" => 3.00,
        #     ),
        #     Dict{String,Any}(
        #         "order" => "send",
        #         "order_tag" => "2",
        #         "orderType" => "stp",
        #         "symbol" => "PI_XBTUSD",
        #         "side" => "buy",
        #         "size" => 1,
        #         "limitPrice" => 2.00,
        #         "stopPrice" => 3.00,
        #     ),
        #     Dict{String,Any}(
        #         "order" => "cancel",
        #         "order_id" => "e35d61dd-8a30-4d5f-a574-b5593ef0c050",
        #     ),
        #     Dict{String,Any}(
        #         "order" => "cancel",
        #         "cliOrdId" => "my_client_id1234"
        #     )
        # ]))

        # println(cancel_all_orders(client))
        # println(cancel_all_orders(client, symbol="pi_xbtusd"))

        # println(dead_mans_switch(client, timeout=60))
        # println(dead_mans_switch(client, timeout=0)) # to deactivate

        # println(cancel_order(client, order_id="ahsh-12398123-a"))

        # println(edit_order(client,
        #     orderId="some-order-id",
        #     size=300,
        #     limitPrice=401,
        #     stopPrice=350
        # ))
        # println(get_orders_status(client, orderIds=["orderid1", "orderid2"]))

        # try
        #     println(create_order(client,
        #         orderType="lmt",
        #         side="buy",
        #         size=1,
        #         limitPrice=4,
        #         symbol="pf_bchusd",
        #     ))
        # catch err
        #     if !isa(err, KrakenInsufficientAvailableFundsError)
        #         throw(err)
        #     end
        # end

        # try
        #     println(create_order(client,
        #         orderType="take_profit",
        #         side="buy",
        #         size=1,
        #         symbol="pf_bchusd",
        #         stopPrice=100,
        #         triggerSignal="mark"
        #     ))
        # catch err
        #     if !isa(err, KrakenInsufficientAvailableFundsError)
        #         throw(err)
        #     end
        # end
    end
end

function main()
    #===== G E N E R A L =====#
    DotEnv.config(path=".env")

    client = FuturesBaseRESTAPI()
    private_client = FuturesBaseRESTAPI(
        key=ENV["FUTURES_API_KEY"],
        secret=ENV["FUTURES_SECRET_KEY"]
    )

    private_sandbox_client = FuturesBaseRESTAPI(
        key=ENV["FUTURES_SANDBOX_API_KEY"],
        secret=ENV["FUTURES_SANDBOX_SECRET_KEY"],
        DEMO=true
    )

    market_endpoints(client, private_sandbox_client)
    user_endpoints(private_client)
    # funding_endpoints(private_client)
    # trade_endpoints(private_client)

end

main()

end