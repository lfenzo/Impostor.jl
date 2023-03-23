module Impostor


using JSON3
using Dates

export getlocale
export setlocale!
export resetlocale!

export identity
export birthdate
export bloodtype
export firstname
export highschool
export name
export occupation
export prefix
export surname
export university


include("core/utils.jl")
include("core/data_interface.jl")

include("providers/identity.jl")
include("providers/relation_restrictions.jl")


SESSION_CONTAINER::DataContainer = DataContainer()


end # Impostor
