using Impostor
using Documenter


makedocs(
    sitename = "Impostor.jl",
    modules = [Impostor],
    pages = [
        "Introduction" => "index.md",
        "Providers" => [
            "Identity" => "providers/identity.md"
            "Localization" => "providers/localization.md"
        ],
        "Developer Guide" => "developer_guide.md",
        "API Reference" => "api_reference.md",
    ]
)
