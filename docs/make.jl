using Documenter
using KrakenEx

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

format = Documenter.HTML(prettyurls=get(ENV, "CI", nothing) == "true")

makedocs(
    modules=[KrakenEx],
    sitename="KrakenEx.jl",
    authors="Benjamin Thomas Schwertfeger",
    format=format,
    checkdocs=:exports,
    pages=PAGES
)


# makedocs(
#     sitename="KrakenEx.jl",
#     format=Documenter.HTML(prettyurls=get(ENV, "CI", nothing) == "true"),
#     authors="Benjamin Thomas Schwertfeger",
#     pages=[
#         "Introduction" => "index.md",
#         "Spot REST API" => "spot/spot.md",
#         "Spot WebSocket API" => "spot/spot_websocket.md",
#         "Spot Examples" => "spot/spot_examples.md",
#         "Futures REST API" => "futures/futures.md",
#         "Futures WebSocket API" => "futures/futures_websocket.md",
#         "Futures Examples" => "futures/futures_examples.md",
#         "Exceptions/Errors" => "exceptions.md"
#     ]
# )

deploydocs(
    repo="github.com/btschwertfeger/KrakenEx.jl.git",
    devbranch="master"
)