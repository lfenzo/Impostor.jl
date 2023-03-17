using JSON3
using Random
using Base.Iterators


include("core/random_selection.jl")
include("core/data_interface.jl")

#include("providers/base.jl")
include("providers/identity.jl")


container::DataContainer = DataContainer()



function main()
    println(firstname("male", 7))
    println(load!(["male", "male", "female", "female"], "firstnames", "identity", ["en_US"]))
    println(surname(7))
end


main()
