module spot_rest_exmaples

using DotEnv

include("../src/KrakenEx.jl")
using .KrakenEx: SpotBaseRESTAPI
using .KrakenEx.ExceptionsModule
using .KrakenEx.SpotMarketModule:
    get_server_time,
    get_assets,
    get_tradable_asset_pair,
    get_ticker,
    get_ohlc,
    get_order_book,
    get_recent_trades,
    get_recend_spreads,
    get_system_status

using .KrakenEx.SpotUserModule:
    get_account_balance,
    get_trade_balance,
    get_open_orders,
    get_closed_orders,
    get_orders_info,
    get_trades_history,
    get_trades_info,
    get_open_positions,
    get_ledgers_info,
    get_ledgers,
    get_trade_volume,
    request_export_report,
    get_export_report_status,
    retrieve_export,
    delete_export_report,
    get_websockets_token

using .KrakenEx.SpotTradeModule:
    create_order,
    create_order_batch,
    edit_order,
    cancel_order,
    cancel_all_orders,
    cancel_all_orders_after_x,
    cancel_order_batch

using .KrakenEx.SpotFundingModule:
    get_deposit_methods,
    get_deposit_address,
    get_recend_deposits_status,
    withdraw_funds,
    get_withdrawal_info,
    get_recend_withdraw_status,
    cancel_withdraw,
    wallet_transfer

using .KrakenEx.SpotStakingModule:
    stake_asset,
    unstake_asset,
    list_stakeable_assets,
    get_pending_staking_transactions,
    list_staking_transactions

function market_endpoints(client::SpotBaseRESTAPI)
    #====== M A R K E T ======#
    println(get_assets(client))
    println(get_tradable_asset_pair(client, pair=["XBTUSD", "DOTUSD"]))
    println(get_ticker(client, pair="DOTUSD"))
    println(get_ticker(client, pair=["DOTUSD", "XBTUSD"]))
    println(get_ohlc(client, pair="XBTUSD"))
    println(get_order_book(client, pair="XBTUSD"))
    println(get_recent_trades(client, pair="XBTUSD"))
    println(get_recend_spreads(client, pair="XBTUSD"))
    println(get_system_status(client))
end

function user_endpoints(private_client::SpotBaseRESTAPI)
    #====== U S E R ======#
    println(get_account_balance(private_client))

    println(get_trade_balance(private_client))
    println(get_trade_balance(private_client, asset="DOT"))

    println(get_open_orders(private_client))
    println(get_open_orders(private_client, trades=true))

    println(get_closed_orders(private_client))
    println(get_closed_orders(private_client, trades=true))
    for closetime ∈ ["close", "open", "both"]
        println(
            get_closed_orders(
                private_client,
                trades=true,
                start=1668431675,
                end_=1668455555,
                ofs=1,
                closetime=closetime
            )
        )
    end
    sleep(5)

    println(get_orders_info(private_client, txid="OXBBSK-EUGDR-TDNIEQ"))
    println(
        get_orders_info(
            private_client,
            txid="OXBBSK-EUGDR-TDNIEQ",
            trades=true
        )
    )
    println(
        get_orders_info(
            private_client,
            txid=["OXBBSK-EUGDR-TDNIEQ", "O23GOI-WZDVD-XWGC3R"],
            trades=true
        )
    )

    for type ∈ ["all", "any position", "closed position", "closing position", "no position"]
        println(get_trades_history(private_client, type=type, start=1668431675, trades=true))
        println(get_trades_history(private_client, type=type, end_=1668431675, ofs=1, trades=false))
    end

    try
        println(get_trades_info(private_client, txid="OQQYNL-FXCFA-FBFVD7"))
    catch err
        if isa(err, KrakenException)
            println(err.message)
            if !isa(err, KrakenInvalidOrderError)
                throw(err)
            end
        end
    end
    sleep(5)

    println(get_open_positions(private_client))
    println(get_open_positions(private_client, txid="OQQYNL-FXCFA-FBFVD7"))
    println(get_open_positions(private_client, txid="OQQYNL-FXCFA-FBFVD7", docalcs=true))

    println(get_ledgers_info(private_client))
    println(get_ledgers_info(private_client, asset="DOT"))
    println(get_ledgers_info(private_client, asset="DOT,EUR"))
    println(get_ledgers_info(private_client, asset=["DOT", "EUR"]))
    sleep(5)

    for type ∈ [
        "all", "deposit", "withdrawal",
        "trade", "margin", "rollover",
        "credit", "transfer", "settled",
        "staking", "sale"
    ]
        println(
            get_ledgers_info(
                private_client,
                type=type,
                aclass="currency",
                start=1668431675,
                end_=1668455555,
                ofs=1
            )
        )
    end
    sleep(5)
    println(get_ledgers(private_client, id="LNYQGU-SUR5U-UXTOWM"))
    println(get_ledgers(private_client, id=["LNYQGU-SUR5U-UXTOWM", "LTCMN2-5DZHX-6CPRC4"], trades=false))

    println(get_trade_volume(private_client))
    println(get_trade_volume(private_client, pair="DOTUSD"))
    println(get_trade_volume(private_client, pair="DOTUSD", fee_info=false))

    # how to export a report?
    response = request_export_report(private_client, report="ledgers", description="myLedgersExport", format="CSV") # returns e.g.: Dict{String, Any}("id" => "WSDS")
    println(get_export_report_status(private_client, report="ledgers"))
    report = retrieve_export(private_client, id=response["id"])
    open("myExport.zip", "w") do io
        write(io, report)
    end
    println(delete_export_report(private_client, type="delete", id=response["id"]))
end

function trade_endpoints(private_client::SpotBaseRESTAPI)
    #===> T R A D E <===#
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
    println(
        create_order(
            private_client,
            ordertype="take-profit-limit",
            side="buy",
            volume=2,
            pair="XBTUSD",
            price=12000,
            price2=13000,
            oflags="fciq",
            validate=true
        )
    )
    println(
        create_order(
            private_client,
            ordertype="market",
            side="buy",
            volume=5,
            pair="XBTUSD",
            validate=true
        )
    )
    println(
        create_order_batch(
            private_client,
            orders=[
                Dict{String,Any}(
                    "close" => Dict{String,Any}(
                        "ordertype" => "stop-loss-limit",
                        "price" => 1000,
                        "price2" => 900
                    ),
                    "ordertype" => "limit",
                    "price" => 40000,
                    "timeinforce" => "GTC",
                    "type" => "buy",
                    "userref" => Int32(123),
                    "volume" => 2
                ),
                Dict{String,Any}(
                    "ordertype" => "limit",
                    "price" => 42000,
                    "starttm" => "1668455555",
                    "timeinforce" => "GTC",
                    "type" => "sell",
                    "userref" => Int32(999),
                    "volume" => 5
                ),
                Dict{String,Any}(
                    "ordertype" => "market",
                    "volume" => 2,
                    "type" => "buy"
                ),
                Dict{String,Any}(
                    "ordertype" => "limit",
                    "price" => 43000,
                    "starttm" => "1668455555",
                    "timeinforce" => "GTC",
                    "type" => "sell",
                    "userref" => Int32(999),
                    "volume" => 5
                )
            ],
            pair="XBTUSD",
            # deadline="2022-31-12T00:18:45Z",
            validate=true
        )
    )
    sleep(5)

    println(
        edit_order(
            private_client,
            txid="O2JLFP-VYFIW-35ZAAE",
            pair="XBTUSD",
            volume=4.2,
            price=17000,
            validate=true
        )
    )

    try
        println(cancel_order(private_client, txid="O2JLFP-VYFIW-35ZAAE"))
    catch err
        if isa(err, KrakenException)
            println(err.message)
            if !isa(err, KrakenInvalidOrderError)
                throw(err)
            end
        end
    end

    # if false println(cancel_all_orders(private_client)) end
    println(cancel_all_orders_after_x(private_client, timeout=60))
    println(cancel_all_orders_after_x(private_client, timeout=0)) # reset timeout
    try
        println(cancel_order_batch(private_client, orders=["O2JLFP-VYFIW-35ZAAE", "O523KJ-DO4M2-KAT243", "OCDIAL-YC66C-DOF7HS", "OVFPZ2-DA2GV-VBFVVI"]))
    catch err
        if isa(err, KrakenException)
            println(err.message)
            if !isa(err, KrakenInvalidOrderError)
                throw(err)
            end
        end
    end
end

function funding_endpoints(private_client::SpotBaseRESTAPI)
    #===> F U N D I N G <===#
    println(get_deposit_methods(private_client, asset="DOT"))
    println(get_deposit_address(private_client, asset="DOT", method="Polkadot"))
    println(get_recend_deposits_status(private_client, asset="DOT", method="Polkadot"))
    # if false println(withdraw_funds(private_client, asset="DOT", key="pwallet1", amount=200)) end

    try
        println(get_withdrawal_info(private_client, asset="DOT", key="pwallet1", amount="200"))
    catch err
        if isa(err, KrakenException)
            println(err.message)
            if !isa(err, KrakenUnknownWithdrawKeyError)
                throw(err)
            end
        end
    end
    println(get_recend_withdraw_status(private_client, asset="DOT"))

    try
        println(cancel_withdraw(private_client, asset="DOT", refid="1234"))
    catch err
        if isa(err, KrakenException)
            println(err.message)
            if !isa(err, KrakenUnknownReferenceIdError)
                throw(err)
            end
        end
    end

    try
        println(wallet_transfer(private_client, asset="XLM", from="Spot Wallet", to="Futures Wallet", amount=200))
    catch err
        if isa(err, KrakenException)
            println(err.message)
            if !isa(err, KrakenUnknownWithdrawKeyError)
                throw(err)
            end
        end
    end
end

function staking_endpoints(private_client::SpotBaseRESTAPI)
    #===> S T A K I N G <===#
    println(list_stakeable_assets(private_client))
    println(get_pending_staking_transactions(private_client))
    println(list_staking_transactions(private_client))

    # try
    #     println(stake_asset(private_client, asset="DOT", amount=20000, method="polkadot-staked"))
    # catch err
    #     if isa(err, KrakenException)
    #         println(err.message)
    #         if !isa(err, KrakenInvalidAmountError)
    #             throw(err)
    #         end
    #     end
    # end

    # try
    #     println(unstake_asset(private_client, asset="XXBT", amount=20000))
    # catch err
    #     if isa(err, KrakenException)
    #         println(err.message)
    #         if !isa(err, KrakenInvalidAmountError)
    #             throw(err)
    #         end
    #     end
    # end
end

function main()
    #===== G E N E R A L =====#
    client = SpotBaseRESTAPI()
    # println(client.BASE_URL)
    # println(get_server_time(client))

    DotEnv.config(path=".env")
    private_client = SpotBaseRESTAPI(
        key=ENV["SPOT_API_KEY"],
        secret=ENV["SPOT_SECRET_KEY"]
    )

    market_endpoints(client)
    # user_endpoints(private_client)
    # trade_endpoints(private_client)
    # funding_endpoints(private_client)
    staking_endpoints(private_client)
end

main()

end