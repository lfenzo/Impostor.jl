const ASSETS_ROOT::String = pkgdir(Impostor, "src", "data")
const DEFAULT_SESSION_LOCALE::Vector{String} = ["en_US"]


Base.@kwdef mutable struct DataContainer
    data::Dict = Dict()
    locale::Vector{String} = DEFAULT_SESSION_LOCALE
end

DataContainer(s::String) = DataContainer(Dict(), [s])

DataContainer(s::Vector{String}) = DataContainer(Dict(), s)


Base.empty!(d::DataContainer) = empty!(d.data)

getlocale() = SESSION_CONTAINER.locale

setlocale!(loc::String) = setproperty!(SESSION_CONTAINER, :locale, [loc])

setlocale!(loc::Vector{String}) = setproperty!(SESSION_CONTAINER, :locale, loc)

function resetlocale!() :: Nothing
    empty!(SESSION_CONTAINER)
    SESSION_CONTAINER.locale = DEFAULT_SESSION_LOCALE
    return nothing
end


"""

"""
@inline function locale_exists(locale) 
    return locale in readdir(joinpath(ASSETS_ROOT))
end

"""

"""
@inline function provider_exists(locale, provider)
    return locale_exists(locale) && provider in readdir(joinpath(ASSETS_ROOT, locale))
end

"""

"""
@inline function content_exists(locale, provider, content)
    return provider_exists(locale, provider) && content * ".json" in readdir(joinpath(ASSETS_ROOT, locale, provider))
end



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
    options::Union{Vector{T}, Nothing} = nothing) where {T <: AbstractString}

    values = Vector{String}()
    for loc in locale
        loaded = load!(content, provider, loc)

        # if the loaded content is a dictionary (e.g. 'firstname' or 'occupation') which keys specify
        # options to be chosen, then we must 'flatten' these dicts pushing their values to a Vector.
        if loaded isa Dict 
            selected_keys = isnothing(options) ? keys(loaded) : options
            for key in selected_keys
                values = vcat(values, convert(Vector{String}, loaded[key]))  # 'convert' ensures type-stabilty
            end
        else
            values = vcat(values, loaded)
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
    if !haslocale(SESSION_CONTAINER, locale)
        merge!(SESSION_CONTAINER.data, Dict(locale => Dict()))
    end

    # adding the provider to the data container in case it doesn't have it
    if !hasprovider(SESSION_CONTAINER, locale, provider)
        merge!(SESSION_CONTAINER.data[locale], Dict(provider => Dict()))
    end

    # adding the content to the data container in case it doesn't have it
    if !hascontent(SESSION_CONTAINER, locale, provider, content)
        open(joinpath(ASSETS_ROOT, locale, provider, content) * ".json", "r") do file
            merge!(
                SESSION_CONTAINER.data[locale],
                Dict(
                    # TODO possible point of type instability
                    provider => JSON3.read(file, Dict{String, Union{Dict, Vector{String}}})
                )
            )
        end
    end

    return SESSION_CONTAINER.data[locale][provider][content]
end


"""

"""
function _verify_load_parameters(locale::T, provider::T, content::T) where {T <: AbstractString}

    @assert(locale_exists(locale),
        "Locale '$locale' not available.")

    @assert(provider_exists(locale, provider), 
        "Provider '$provider' not available for locale '$locale'")

    @assert(content_exists(locale, provider, content),
        "Content '$content' not available for locale '$locale' and provider '$provider'")

    return nothing
end
