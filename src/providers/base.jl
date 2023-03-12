abstract type Provider <: Sampleable{Univariate, Discrete} end


"""

"""
function Base.rand(rng::AbstractRNG, i::Provider; unique::Bool = false)
    return 10
end





