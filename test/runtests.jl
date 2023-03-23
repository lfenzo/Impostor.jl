using Impostor
using Test
using JSON3


include("test_utils.jl")


# common aliases to test 
const OPTIONLESS::String = "Random Values (neither Options nor Mask)"
const MASK_LOADING::String = "Mask-Based Loading"
const OPTION_LOADING::String = "Option-Based Loading"


testsets = Dict{String, String}(
   "Data Interface" => "data_interface.jl",
   "Identity" => "identity.jl",
)

@testset "Impostor" begin
    for (testset, test_file) in testsets
        @testset "$testset" begin
            include(test_file)
        end
    end
end
