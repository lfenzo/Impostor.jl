using Impostor
using Test
using CSV
using DataFrames
using Tokenize


include("utils.jl")
include(joinpath(pkgdir(Impostor), "src", "providers", "relation_restrictions.jl"))

# common aliases to test 
const VALUE_BASED::String = "Value-based Loading"
const OPTION_BASED::String = "Option-based Loading"
const MASK_BASED::String = "Mask-based Loading"

# list of all available locales to be checked for intetritty
const ALL_LOCALES::Vector{String} = Impostor.get_all_locales(; root = pkgdir(Impostor, "src", "data"), to_skip = ["HEADER"])

testsets = Dict{String, Any}(
   "Data Interface" => "test_data_interface.jl",
   "Data Integrity" => readdir("./data_integrity/"; join = true),
   "Utils" => "test_utils.jl",
)

@testset "Impostor" begin
    for (testset, target) in testsets
        @testset "$testset" begin
            if target isa Vector{String}
                for file in target
                    include(file)
                end
            else
                include(target)
            end
        end
    end
end
