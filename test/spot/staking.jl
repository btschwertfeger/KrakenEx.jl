using KrakenEx: SpotBaseRESTAPI
import KrakenEx.SpotStakingModule as SpotStaking
import KrakenEx.ExceptionsModule as exc
using Test


client = SpotBaseRESTAPI(key=ENV["SPOT_API_KEY"], secret=ENV["SPOT_SECRET_KEY"])

@testset verbose = true "Stake" begin
    @test_throws exc.KrakenPermissionDeniedError SpotStaking.stake_asset(client, asset="DOT", method="polkadot-staked", amount=200)
end
sleep(2)

@testset verbose = true "Unstake" begin
    @test_throws exc.KrakenPermissionDeniedError SpotStaking.unstake_asset(client, asset="DOT", amount=200)
end
sleep(2)

@testset verbose = true "Misc" begin
    @test_throws exc.KrakenPermissionDeniedError SpotStaking.list_stakeable_assets(client)
    @test typeof(SpotStaking.get_pending_staking_transactions(client)) == Vector{Any}
    @test typeof(SpotStaking.list_staking_transactions(client)) == Vector{Any}
end
sleep(2)