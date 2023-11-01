module Impostor


using CSV
using DataFrames
using DataStructures
using StatsBase
using Dates
using Tokenize


# utilities
export session_locale
export setlocale!
export resetlocale!
export provider_exists
export content_exists
export locale_exists
export materialize_template
export materialize_numeric_template
export materialize_numeric_range_template

# identity
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
export bank_name
export bank_official_name
export credit_card_cvv
export credit_card_expiry
export credit_card_number
export credit_card_vendor

# Impostor-template related
export ImpostorTemplate
export addfield!


include("providers/relation_restrictions.jl")

include("core/utils.jl")
include("core/data_interface.jl")

include("providers/finance.jl")
include("providers/identity.jl")
include("providers/localization.jl")

include("impostor_template.jl")

SESSION_CONTAINER::DataContainer = DataContainer()


end # Impostor
