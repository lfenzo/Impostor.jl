using JSON3
using Random
using Base.Iterators
using Dates
using DataFrames


include("core/data_interface.jl")
include("core/utils.jl")

include("providers/identity.jl")


container::DataContainer = DataContainer()



function main()
    #println(firstname("female", 7))
    #println(load!(["male", "male", "female", "female"], "firstnames", "identity", ["en_US"]))
    #println(surname(7))
    features = [
        :prefix,
        :firstname,
        :surname, 
        :sex,
        :birthdate,
        :occupation,
        :bloodtype,
        :highschool,
        :university,
        :knowledge_field,
    ]

    return identity(30, features, DataFrame; sex = ["male", "female"])
end


main()
