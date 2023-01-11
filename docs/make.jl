using Documenter
using KrakenEx

DocMeta.setdocmeta!(KrakenEx, :DocTestSetup, :(using KrakenEx); recursive=true)

About = "Introduction" => "index.md"

SpotAPI = "Spot API" => [
    "spot/spot.md",
    "spot/spot_websocket.md",
    "spot/spot_examples.md",
]

FuturesAPI = "Futures API" => [
    "futures/futures.md",
    "futures/futures_websocket.md",
    "futures/futures_examples.md",
]

Exceptions = "Exceptions" => "exceptions.md"
License = "License" => "license.md"

PAGES = [
    About,
    SpotAPI,
    FuturesAPI,
    Exceptions,
    License
]

FORMAT = Documenter.HTML(
    prettyurls=get(ENV, "CI", nothing) == "true",
    # assets=["assets/favicon.ico"],
)

makedocs(
    modules=[KrakenEx],
    sitename="KrakenEx.jl",
    authors="Benjamin Thomas Schwertfeger",
    format=FORMAT,
    checkdocs=:exports,
    pages=PAGES
)


deploydocs(
    repo="github.com/btschwertfeger/KrakenEx.jl.git",
    devbranch="master"
)