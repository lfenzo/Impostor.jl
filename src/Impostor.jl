module Impostor


using CSV
using DataFrames
using Dates
using StatsBase
using Tokenize


export ImpostorTemplate

export session_locale
export setlocale!
export resetlocale!
export provider_exists
export content_exists
export locale_exists

export birthdate
export bloodtype
export complete_name
export firstname
export highschool
export occupation
export prefix
export surname
export university

export city
export country
export country_code
export district
export state
export state_code
export street
export street_prefix
export street_suffix


include("providers/relation_restrictions.jl")

include("core/utils.jl")
include("core/data_interface.jl")
include("core/impostor_template.jl")

include("providers/identity.jl")
include("providers/localization.jl")


SESSION_CONTAINER::DataContainer = DataContainer()


end # Impostor
