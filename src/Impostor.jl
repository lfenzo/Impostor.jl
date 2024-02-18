module Impostor


using CSV
using DataFrames
using DataStructures
using StatsBase
using Dates
using Tokenize
using Chain


include("core/utils.jl")
include("core/data_interface.jl")
include("providers/relation_restrictions.jl")

# utilities
export session_locale
export setlocale!
export resetlocale!
export is_provider_available
export is_content_available
export is_locale_available
export render_template
export render_alphanumeric
export render_alphanumeric_range

# identity
include("providers/identity.jl")
export birthdate
export bloodtype
export complete_name
export firstname
export highschool
export nationality
export occupation
export prefix
export surname
export university

# localization
include("providers/localization.jl")
export address
export address_complement
export city
export country
export country_official_name
export country_code
export district
export state
export state_code
export street
export street_number
export street_prefix
export street_suffix
export postcode

# finance
include("providers/finance.jl")
export bank_name
export bank_official_name
export credit_card_cvv
export credit_card_expiry
export credit_card_number
export credit_card_vendor

# miscellaneous
include("providers/miscellaneous.jl")
export locale_code

# Impostor-template related
include("impostor_template.jl")
export ImpostorTemplate
export addfield!


SESSION_CONTAINER::DataContainer = DataContainer()


end # Impostor
