using JSON3
using Random
using Distributions


include("core/loading.jl")
include("core/impostor.jl")


function main()
    imp = Impostor(["en_US", "pt_BR"]; providers = [:ae_porra])
    println(rand(imp, 30))
end


main()
