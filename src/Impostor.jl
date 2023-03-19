module Impostor


using JSON3
using Dates


export birthdate
export bloodtype
export firstname
export getlocale
export highschool
export identity
export name
export occupation
export prefix
export setlocale!
export surname
export university


include("core/data_interface.jl")
include("core/utils.jl")

include("providers/identity.jl")


GLOBAL_CONTAINER::DataContainer = DataContainer()


end # Impostor
