using Documenter
using KrakenEx

makedocs(
    sitename="KrakenEx.jl",
    format=Documenter.HTML(prettyurls=get(ENV, "CI", nothing) == "true"),
    pages=[
        "Introduction" => "index.md",
        "Spot Trading" => "spot.md",
        "Spot Examples" => "spot_examples.md",
        "Futures Trading" => "futures.md",
        "Futures Examples" => "futures_examples.md",
    ]
)

deploydocs(
    repo="github.com/btschwertfeger/KrakenEx.jl.git",
    devbranch="master"
)