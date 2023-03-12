using JSON3
using Random
using Distributions


include("core/loading.jl")
include("core/impostor.jl")
include("core/data_container.jl")

include("providers/base.jl")
include("providers/identity.jl")





function main()
    imp = Impostor(["en_US", "pt_BR"]; providers = [:ae_porra])

    container = DataContainer()
#    println(haslocale(container, "en_US"))
#    println(hasprovider(container, "en_US", "identity"))
#    println(hascontent(container, "en_US", "identity", :name))

    println("....................")
    a = load!(container; locale = "en_US", provider = "identity", content = "name")


    println("test ", haslocale(container, "en_US"))
    println("test ", hasprovider(container, "en_US", "identity"))
    println("test ", hascontent(container, "en_US", "identity", "name"))

    return a
    #rand(names([:prefix, :firstname, :surname]; locale = "pt_BR"), 200) |> println

    #println(rand(imp, 30))
end


main()
