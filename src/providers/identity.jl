"""
    names(format::Vector{Symbol} = []; sex::T = "both", locale::T = "en_US") where {T <: AbstractString}

# Parameters

- `sex` 
- `locale`
"""
# possible return formats: Dict, Matrix, Dataframe 
function names(format::Vector{Symbol} = [], n::Int = 1; sex::T = "both", locale::T = "en_US") where {T <: AbstractString}

    sex_mask = rand(["male", "female"], n)
    generated_values = Dict()

    for f in format
        if f == :firstname
            generated_values[:firstname] = load!(sex_mask, "firstnames", "identity", locale)
        end
        if f == :surname
            generated_values[:surname] = load!(n, "surnames", "identity", locale)
        end
    end
end


"""

"""
function firstname(sex::T, n::Int = 1; locale::Vector{T} = ["en_US"]) :: Vector{T} where {T <: AbstractString}
    return rand(load!("firstnames", "identity", locale; options = [sex]), n)
end


"""

"""
function prefix(sex::T, n::Int = 1; locale::Vector{T} = ["en_US"]) :: Vector{T} where {T <: AbstractString}
    return rand(load!("prefixes", "identity", locale; options = [sex]), n)
end


"""

"""
function surname(n::Int = 1; locale::Vector{T} = ["en_US"]) :: Vector{T} where {T <: AbstractString}
    return rand(load!("surnames", "identity", locale), n)
end
