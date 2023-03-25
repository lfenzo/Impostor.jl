const KNOWLEDGE_FIELDS::Dict{Symbol, Vector{String}} = Dict(
    :providers => [
        "identity"
    ],
    :provider_functions => [
        "occupation",
        "univsersity",
    ],
    :options => [
        "business",
        "humanities",
        "social-sciences",
        "natural-sciences",
        "formal-sciences",
        "public-administration",
        "military",
    ]
)

const SEXES::Dict{Symbol, Vector{String}} = Dict(
    :provider => [
        "identity",
    ],
    :provider_functions => [
        "firstname",
        "fullname",
        "prefix",
    ],
    :options => [
        "male",
        "female",
    ]
)
