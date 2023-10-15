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
        "Utilities" => [
            "Impostor Templates" => "utilities/impostor_templates.md",
            "Utility Functions" => "utilities/utility_functions.md",
        ],
        "Developer Guide" => [
            "Developer Guide" => "developer_guide.md",
            "Data Interface" => "core/data_interface.md",
            "Templatization" => "core/templatization.md",
        ],
        "API Reference" => "api_reference.md",
    ]
)

deploydocs(
    repo = "github.com/lfenzo/Impostor.jl.git",
)
