module Impostor


using JSON3
using Dates
using StatsBase


export ImpostorTemplate

export getlocale
export setlocale!
export resetlocale!
export locale_exists
export provider_exists
export content_exists

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
export district
export state
export state_code

include("providers/relation_restrictions.jl")

include("core/utils.jl")
include("core/data_interface.jl")
include("core/impostor_template.jl")

include("providers/identity.jl")
include("providers/localization.jl")


SESSION_CONTAINER::DataContainer = DataContainer()


end # Impostor
