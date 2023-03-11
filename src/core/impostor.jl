"""

"""
Base.@kwdef mutable struct Impostor <: Sampleable{Univariate, Discrete}
    locale::Vector{String} = []
    providers::Vector{Symbol} = []

    function Impostor(locale; providers = [])
        return new(
            locale isa AbstractArray ? locale : [locale],
            providers isa AbstractArray ? providers : [providers],
        )
    end
end

#Impostor(locale::AbstractString) = Impostor([locale], [])


"""

"""
function Base.rand(rng::AbstractRNG, i::Impostor; unique::Bool = false)
    return 10
end
