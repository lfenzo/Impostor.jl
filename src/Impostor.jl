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

export identity
export birthdate
export bloodtype
export firstname
export complete_name
export highschool
export occupation
export prefix
export surname
export university


include("core/utils.jl")
include("core/data_interface.jl")
include("core/impostor_template.jl")

include("providers/identity.jl")
include("providers/relation_restrictions.jl")


SESSION_CONTAINER::DataContainer = DataContainer()


end # Impostor
