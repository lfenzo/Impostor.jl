const KNOWLEDGE_FIELDS::Dict{Symbol, Vector} = Dict(
    :providers => [
        "identity"
    ],
    :provider_functions => [
        :occupation,
        :university,
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

const SEXES::Dict{Symbol, Vector} = Dict(
    :provider => [
        "identity",
    ],
    :provider_functions => [
        :firstname,
        :fullname,
        :prefix,
    ],
    :options => [
        "M", # male
        "F", # female
    ]
)
