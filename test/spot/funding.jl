using KrakenEx: SpotBaseRESTAPI
import KrakenEx.SpotFundingModule as SpotFunding
import KrakenEx.ExceptionsModule as exc
using Test


client = SpotBaseRESTAPI(key=ENV["SPOT_API_KEY"], secret=ENV["SPOT_SECRET_KEY"])


@testset verbose = true "Deposit methods" begin
    @test typeof(SpotFunding.get_deposit_methods(client, asset="DOT")) == Vector{Any}
    @test typeof(SpotFunding.get_deposit_address(client, asset="DOT", method="Polkadot")) == Vector{Any}
    @test typeof(SpotFunding.get_recent_deposits_status(client, asset="DOT", method="Polkadot")) == Vector{Any}
end

@testset verbose = true "Withdraw methods" begin
    @test_throws exc.KrakenPermissionDeniedError SpotFunding.withdraw_funds(client, asset="DOT", amount="10", key="myPolkadotWallet")
    @test_throws exc.KrakenPermissionDeniedError SpotFunding.get_withdrawal_info(client, asset="DOT", amount="10", key="myPolkadotWallet")
    @test typeof(SpotFunding.get_recent_withdraw_status(client, asset="DOT", method="Polkadot")) == Vector{Any}
    @test_throws exc.KrakenPermissionDeniedError SpotFunding.cancel_withdraw(client, asset="DOT", refid="123456789")
    @test_throws exc.KrakenPermissionDeniedError SpotFunding.wallet_transfer(client, asset="DOT", from="Spot Wallet", to="Futures Wallet", amount=200)
end

sleep(5)