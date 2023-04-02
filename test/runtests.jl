using Impostor
using Test
using JSON3


include("utils.jl")
include(joinpath(pkgdir(Impostor), "src", "providers", "relation_restrictions.jl"))


# common aliases to test 
const OPTIONLESS::String = "Random Values (neither Options nor Mask)"
const MASK_LOADING::String = "Mask-Based Loading"
const OPTION_LOADING::String = "Option-Based Loading"

# list of all available locales to be checked for intetritty
const ALL_LOCALES::Vector{String} = [d for d in readdir(pkgdir(Impostor, "src", "data")) if d != "template"]


testsets = Dict{String, String}(
   "Data Interface" => "test_data_interface.jl",
   "Data Integrity" => "test_data_integrity.jl",
   "Localization" => "test_localization.jl",
   "Identity" => "test_identity.jl",
)

@testset "Impostor" begin
    for (testset, test_file) in testsets
        @testset "$testset" begin
            include(test_file)
        end
    end
end
