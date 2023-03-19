const ASSETS_ROOT::String = pkgdir(Impostor, "src", "data")

Base.@kwdef mutable struct DataContainer
    data::Dict = Dict()
    locale::Vector{String} = ["en_US"]
end

DataContainer(s::String) = DataContainer(Dict(), [s])

DataContainer(s::Vector{String}) = DataContainer(Dict(), s)


Base.empty!(d::DataContainer) = empty!(d.data)

getlocale() = GLOBAL_CONTAINER.locale

setlocale!(loc::String) = setproperty!(GLOBAL_CONTAINER, :locale, [loc])

setlocale!(loc::Vector{String}) = setproperty!(GLOBAL_CONTAINER, :locale, loc)


"""

"""
@inline function haslocale(d::DataContainer, locale) 
    return haskey(d.data, locale)
end

"""

"""
@inline function hasprovider(d::DataContainer, locale, provider)
    return haslocale(d, locale) && haskey(d.data[locale], provider)
end

"""

"""
@inline function hascontent(d::DataContainer, locale, provider, content)
    return hasprovider(d, locale, provider) && haskey(d.data[locale][provider], content)
end


"""

"""
function load!(option_mask::AbstractVector, content::T, provider::T, locale::Vector{T} = getlocale()) where {T <: AbstractString}

    value_pools = Dict()
    for mask_value in unique(option_mask)
        value_pools[mask_value] = vcat([load!(content, provider, loc)[mask_value] for loc in locale]...)
    end

    selected_values = Vector{String}()
    for value in option_mask
        push!(selected_values, rand(value_pools[value]))
    end

    return selected_values
end


"""

"""
function load!(content::T, provider::T, locale::Vector{T} = getlocale();
    options::Union{Vector{T}, NTuple{N, T}, Nothing} = nothing) where {N, T <: AbstractString}

    values = Vector{String}()
    for loc in locale
        if isnothing(options)
            values = vcat(values, load!(content, provider, loc))
        else
            for option in options
                values = vcat(values, load!(content, provider, loc)[option])
            end
        end
    end
    return values
end


"""
    load!(content::T, provider::T, locale::T) where {T <: AbstractString}

Load the requested `content` from a given `provider` in the specified `locale`. This is the
common fallback for the `load!` method which will ultimatelly load 

"""
function load!(content::T, provider::T, locale::T) where {T <: AbstractString}

    _verify_load_parameters(locale, provider, content)

    # adding the locale to the data container in case it doesn't have it
    if !haslocale(GLOBAL_CONTAINER, locale)
        merge!(GLOBAL_CONTAINER.data, Dict(locale => Dict()))
    end

    # adding the provider to the data container in case it doesn't have it
    if !hasprovider(GLOBAL_CONTAINER, locale, provider)
        merge!(GLOBAL_CONTAINER.data[locale], Dict(provider => Dict()))
    end

    # adding the content to the data container in case it doesn't have it
    if !hascontent(GLOBAL_CONTAINER, locale, provider, content)
        open(joinpath(ASSETS_ROOT, locale, provider, content) * ".json", "r") do file
            merge!(
                GLOBAL_CONTAINER.data[locale],
                Dict(
                    provider => JSON3.read(file, Dict{String, Union{Dict, Vector{String}}})
                )
            )
        end
    end

    return GLOBAL_CONTAINER.data[locale][provider][content]
end


"""

"""
function _verify_load_parameters(locale::T, provider::T, content::T) where {T <: AbstractString}

    @assert(locale in readdir(joinpath(ASSETS_ROOT)),
        "Locale '$locale' not available.")

    @assert(provider in readdir(joinpath(ASSETS_ROOT, locale)),
        "Provider '$provider' not available for locale '$locale'")

    @assert(content * ".json" in readdir(joinpath(ASSETS_ROOT, locale, provider)),
        "Content '$content' not available for locale '$locale' and provider '$provider'")

    return nothing
end
