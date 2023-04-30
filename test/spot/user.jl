using KrakenEx: SpotBaseRESTAPI
import KrakenEx.SpotUserModule as SpotUser
using Test


client = SpotBaseRESTAPI(key=ENV["SPOT_API_KEY"], secret=ENV["SPOT_SECRET_KEY"])

@testset verbose = true "Account" begin
    @test typeof(SpotUser.get_account_balance(client)) == Dict{String,Any}
    @test typeof(SpotUser.get_websockets_token(client)) == Dict{String,Any}
    @test typeof(SpotUser.get_trade_balance(client, asset="USD")) == Dict{String,Any}
    @test typeof(SpotUser.get_ledgers_info(client, start=1675066107, end_=1675166107)) == Dict{String,Any}
    @test typeof(SpotUser.get_ledgers(client, id="LBXJQL-BRYFU-7ZIMEA", trades=true)) == Dict{String,Any}
    @test typeof(SpotUser.get_trade_volume(client, pair="XBTUSD")) == Dict{String,Any}
end

@testset verbose = true "Orders and positions" begin
    @test typeof(SpotUser.get_trades_history(client, trades=true, start=1675066107, end_=1675166107)) == Dict{String,Any}
    @test typeof(SpotUser.get_open_orders(client, trades=true)) == Dict{String,Any}
    @test typeof(SpotUser.get_closed_orders(client, trades=true, start=1675066107, ofs="1")) == Dict{String,Any}
    @test typeof(SpotUser.get_orders_info(client, txid="OFRQKY-YOKNY-YLN5BM")) == Dict{String,Any}
    @test typeof(SpotUser.get_trades_info(client, txid="TKH2SE-M7IF5-CFI7LT")) == Dict{String,Any}
    @test typeof(SpotUser.get_open_positions(client, txid="TKH2SE-M7IF5-CFI7LT")) == Vector{Any}
end

@testset verbose = true "Report export" begin

    result = SpotUser.request_export_report(client, report="trades", description="myExport", format="CSV")
    @test typeof(result) == Dict{String,Any}

    sleep(4)
    @test typeof(SpotUser.get_export_report_status(client, report="trades")) == Vector{Any}

    report = SpotUser.retrieve_export(client, id=result["id"])
    @test typeof(report) == Vector{UInt8}

    @test typeof(SpotUser.delete_export_report(client, id=result["id"], type="delete")) == Dict{String,Any}
end


sleep(3)

