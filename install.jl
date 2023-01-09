import Pkg

Pkg.add("HTTP")
Pkg.add("JSON")
Pkg.add("PkgTemplates")
Pkg.add("Nettle")
Pkg.add("StringEncodings")


# using PkgTemplates
# t = Template(;
#     user="btschwertfeger",
#     authors=["Benjamin Thomas Schwertfeger"],
#     plugins=[
#         Git(),
#     ]
# )

# t("KrakenEx")

using Pkg
activate ~/repositories/Finance/Kraken/KrakenEx.jl
# adding packages
add Nettle