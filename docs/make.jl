using Impostor
using Documenter


makedocs(
    sitename = "Impostor.jl",
    pages = [
        "Home" => "index.md",
        "Providers" => [
            "Identity" => "providers/identity.md"
        ]
    ]
)
