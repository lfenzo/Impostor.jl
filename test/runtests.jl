using Impostor
using Test
using CSV
using DataFrames


include("utils.jl")
include(joinpath(pkgdir(Impostor), "src", "providers", "relation_restrictions.jl"))

# common aliases to test 
const OPTIONLESS::String = "Random Values"
const MASK_LOADING::String = "Mask-Based Loading"
const OPTION_LOADING::String = "Option-Based Loading"

# list of all available locales to be checked for intetritty
const ALL_LOCALES::Vector{String} = _get_all_locales(; root = pkgdir(Impostor, "src", "data"))

testsets = Dict{String, String}(
   "Data Interface" => "test_data_interface.jl",
   "Data Integrity" => "test_data_integrity.jl",
   "Localization" => "test_localization.jl",
   "Identity" => "test_identity.jl",
)

@testset "Impostor" begin
    for (testset, file) in testsets
        @testset "$testset" begin
            include(file)
        end
    end
end
