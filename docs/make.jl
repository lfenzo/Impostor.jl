using Impostor
using Documenter


makedocs(
    sitename = "Impostor.jl",
    modules = [Impostor],
    pages = [
        "Home" => "index.md",
        "Providers" => [
            "Identity" => "providers/identity.md"
        ]
    ]
)
