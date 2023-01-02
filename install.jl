import Pkg

Pkg.add("HTTP")
Pkg.add("JSON")
Pkg.add("PkgTemplates")
Pkg.add("Nettle")
using PkgTemplates


t = Template(;
    user="btschwertfeger",
    authors=["Benjamin Thomas Schwertfeger"],
    plugins=[
        Git(),
    ]
)

t("KrakenEx")