using Documenter
using DocumenterMermaid
using Impostor


makedocs(
    warnonly = true,
    sitename = "Impostor.jl",
    modules = [Impostor],
    pages = [
        "Introduction" => "index.md",
        "Providers" => [
            "Identity" => "providers/identity.md",
            "Finance" => "providers/finance.md",
            "Localization" => "providers/localization.md",
        ],
        "Developer Guide" => [
            "Developer Guider" => "developer_guide.md",
            "Internals" => "core/internals.md",
            "Utilities" => "core/utilities.md",
        ],
        "API Reference" => "api_reference.md",
    ]
)

deploydocs(
    repo = "github.com/lfenzo/Impostor.jl.git",
)
