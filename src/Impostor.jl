using JSON3
using Random
using Dates
using DataFrames


include("core/data_interface.jl")
include("core/utils.jl")

include("providers/identity.jl")


container::DataContainer = DataContainer()


function main()

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

    #return identity(30, features, DataFrame; sex = ["male", "female"])

    setlocale!(container, ["pt_BR", "en_US"])
    return surname(23)
end


main()
