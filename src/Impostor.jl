using JSON3
using Random
using Dates
#using DataFrames


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

    #identity(30, features; sex = ["female"], fields = ["formal-sciences"]) |> println
    identity(30, features) |> println

#    setlocale!(container, ["pt_BR", "en_US"])
#    return surname(23)
end


main()
