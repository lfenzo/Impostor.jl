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

const LOCALIZATIONS::Dict{Symbol, Vector} = Dict(
    :provider => [
        "localization",
    ],
    :provider_functions => [
        :country,
        :country_official_name,
        :country_code,
        :state,
        :state_code,
        :city,
        :district,
        :address,
    ],
)

const CREDIT_CARDS::Dict{Symbol, Vector} = Dict(
    :provider => [
        "finance",
    ],
    :provider_functions => [
        :credit_card_vendor,
        :credit_card_number,
    ],
)
