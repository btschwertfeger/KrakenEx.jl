
#=This file only contains private notes=#


## Activate project
## julia> ]
## pkg> activate .

## Build project
## julia> using Pkg; Pkg.build()

## Buikd documentation
## julia> using Documenter
## julia> ]
## pkg> activate .
## julia> include("docs/make.jl")


# import Pkg

# Pkg.add("HTTP")
# Pkg.add("JSON")
# Pkg.add("PkgTemplates")
# Pkg.add("Nettle")
# Pkg.add("StringEncodings")

# using PkgTemplates
# t = Template(;
#     user="btschwertfeger",
#     authors=["Benjamin Thomas Schwertfeger"],
#     plugins=[
#         Git(),
#     ]
# )

# t("KrakenEx")

# using Pkg
# activate ~/repositories/Finance/Kraken/KrakenEx.jl
# # adding packages
# add Nettle