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
            "Templatization" => "utilities/templatization.md",
        ],
        "Developer Guide" => [
            "Quick Tour (Start Here)" => "developer_guide/quick_tour.md",
            "Data Interface" => "developer_guide/data_interface.md",
        ],
        "API Reference" => "api_reference.md",
    ]
)

deploydocs(
    repo = "github.com/lfenzo/Impostor.jl.git",
)
