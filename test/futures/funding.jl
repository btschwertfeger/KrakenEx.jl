using KrakenEx: FuturesBaseRESTAPI
import KrakenEx.FuturesFundingModule as FuturesFunding
import KrakenEx.ExceptionsModule as exc
using HTTP
using Test


client = FuturesBaseRESTAPI(key=ENV["FUTURES_SANDBOX_KEY"], secret=ENV["FUTURES_SANDBOX_SECRET"], DEMO=true)

@testset verbose = true "Transfers" begin
    @test_throws exc.KrakenInvalidAccountError FuturesFunding.initiate_wallet_transfer(client, fromAccount="Multi-Collateral", toAccount="Single-Collateral", amount=2, unit="PI_XBTUSD")
    @test_throws exc.KrakenInvalidArgumentsError FuturesFunding.initiate_subccount_transfer(client, fromAccount="Multi-Collateral", toAccount="Single-Collateral", amount=2, fromUser="Dummy1", toUser="Dummy2", unit="PI_XBTUSD") # broken?
    @test_throws HTTP.Exceptions.StatusError FuturesFunding.initiate_withdrawal_to_spot_wallet(client, amount=5, currency="USD", sourceWallet="Single-Collateral") # CASH_ACCOUNT_TYPE_NOT_FOUND
end

@testset verbose = true "Misc" begin
    @test typeof(FuturesFunding.get_historical_funding_rates(client, symbol="PI_XBTUSD")) == Dict{String,Any}
end