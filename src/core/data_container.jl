const ASSETS_ROOT::String = joinpath("data")


mutable struct DataContainer
    data::Dict
end

DataContainer() = DataContainer(Dict())


Base.empty!(d::DataContainer) = empty!(d.data)


@inline get(d::DataContainer, locale::T) where {T <: AbstractString} = d.data[locale]

@inline get(d::DataContainer, locale::T, provider::T) where {T <: AbstractString} = d.data[locale][provider]

@inline get(d::DataContainer, locale::T, provider::T, content::T) where {T <: AbstractString} = d.data[locale][provider][content]


"""

"""
@inline function haslocale(d::DataContainer, locale) 
    return haskey(d.data, locale)
end

"""

"""
@inline function hasprovider(d::DataContainer, locale, provider)
    return haslocale(d, locale) && haskey(get(d, locale), provider)
end

"""

"""
@inline function hascontent(d::DataContainer, locale, provider, content)
    return hasprovider(d, locale, provider) && haskey(get(d, locale, provider), content)
end


"""

"""
function load!(d::DataContainer; locale::T, provider::T, content::T) where {T <: AbstractString}

    _verify_load_parameters(locale, provider, content)

    # adding the locale to the data container in case it doesn't have it
    !haslocale(d, locale) && merge!(d.data, Dict(locale => Dict()))

    # adding the provider to the data container in case it doesn't have it
    !hasprovider(d, locale, provider) && merge!(d.data[locale], Dict(provider => Dict()))

    # adding the provider to the data container in case it doesn't have it
    if !hascontent(d, locale, provider, content)
        open(joinpath(ASSETS_ROOT, locale, provider, content) * ".json", "r") do file
            merge!(d.data[locale], Dict(provider => JSON3.read(file, Dict{String, Any})))
        end
    end

    return d.data[locale][provider][content]
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
