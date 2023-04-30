using KrakenEx: FuturesBaseRESTAPI
import KrakenEx.FuturesUserModule as FuturesUser
using Test


client = FuturesBaseRESTAPI(key=ENV["FUTURES_SANDBOX_KEY"], secret=ENV["FUTURES_SANDBOX_SECRET"], DEMO=true)

@testset verbose = true "Wallets and accounts" begin
    @test typeof(FuturesUser.get_wallets(client)) == Dict{String,Any}
    @test typeof(FuturesUser.get_subaccounts(client)) == Dict{String,Any}
    @test typeof(FuturesUser.get_account_log(client, info="all", sort="desc", since="1673066107", before="1675066107", count=100)) == Dict{String,Any}
    @test typeof(FuturesUser.get_account_log_csv(client)) == Vector{UInt8}
end

@testset verbose = true "Orders and positions" begin
    @test typeof(FuturesUser.get_open_orders(client)) == Dict{String,Any}
    @test typeof(FuturesUser.get_open_positions(client)) == Dict{String,Any}

end
@testset verbose = true "Misc" begin
    @test typeof(FuturesUser.get_unwindqueue(client)) == Dict{String,Any}
    @test typeof(FuturesUser.get_notificatios(client)) == Dict{String,Any}
end