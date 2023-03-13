using JSON3
using Random
using Distributions


include("core/impostor.jl")
include("core/data_container.jl")

include("providers/base.jl")
include("providers/identity.jl")


container::DataContainer = DataContainer()


function main()

    println("....................")
    #a = load!(container; locale = "en_US", provider = "identity", content = "names")

    println("test ", haslocale(container, "en_US"))
    println("test ", hasprovider(container, "en_US", "identity"))
    println("test ", hascontent(container, "en_US", "identity", "name"))

    rand(names([:firstname]; sex = "both"), 200) |> println

    #println(rand(imp, 30))
end


main()
