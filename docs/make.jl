using Documenter
using Impostor


makedocs(
    warnonly = true,
    sitename = "Impostor.jl",
    modules = [Impostor],
    pages = [
        "Introduction" => "index.md",
        "Providers" => [
            "Identity" => "providers/identity.md"
            "Finance" => "providers/finance.md"
            "Localization" => "providers/localization.md"
        ],
        "Utilities" => "core/utilities.md",
        "Developer Guide" => "developer_guide.md",
        "API Reference" => "api_reference.md",
    ]
)
