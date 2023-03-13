mutable struct Identity <: Provider
    options::Vector{Symbol}
end


"""
    names(format::Vector{Symbol} = []; sex::T = "both", locale::T = "en_US") where {T <: AbstractString}

# Parameters

- `format`
- 
- 
"""
function names(format::Vector{Symbol} = []; sex::T = "both", locale::T = "en_US") where {T <: AbstractString}
    load!(container; locale = locale, provider = "identity", content = "names")
    names = get(container, locale, "identity", "names")

    if sex == "both"
        return vcat(names["male"], names["female"])
    end
end


