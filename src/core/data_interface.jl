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
@inline function provider_exists(provider::AbstractString) :: Bool
    return provider in readdir(joinpath(ASSETS_ROOT))
end

"""

"""
@inline function content_exists(provider::T, content::T) where {T <: AbstractString}
    return provider_exists(provider) && content in readdir(joinpath(ASSETS_ROOT, provider))
end

"""

"""
@inline function locale_exists(provider::T, content::T, locale::T) where {T <: AbstractString}
    return (
        content_exists(provider, content)
        && locale * ".csv" in readdir(joinpath(ASSETS_ROOT, provider, content))
    )
end





"""

"""
@inline function provider_loaded(d::DataContainer, provider::AbstractString) :: Bool
    return haskey(d.data,  provider)
end

"""

"""
@inline function content_loaded(d::DataContainer, provider::T, content::T) where {T <: AbstractString}
    return provider_loaded(d, provider) && haskey(d.data[provider], content)
end

"""

"""
@inline function locale_loaded(d::DataContainer, provider::T, content::T, locale::T) where {T <: AbstractString}
    return content_loaded(d, provider, content) && haskey(d.data[provider][content], locale)
end


"""

"""
function load!(provider::T, content::T, locale::Vector{T}) where {T <: AbstractString}
    df = DataFrame()
    for loc in locale
        append!(df, load!(provider, content, loc); promote = true)
    end
    return df
end


"""

"""
function load!(provider::T, content::T, locale::T = "noloc") :: DataFrame where {T <: AbstractString}

    @assert(provider_exists(provider), "Provider '$provider' is not available.")

    @assert(content_exists(provider, content),
        "Content '$content' not available for provider '$provider'")

    @assert(locale_exists(provider, content, locale),
        "Locale '$locale' not available for content '$content' of provider '$provider'")

    if !provider_loaded(SESSION_CONTAINER, provider)
        merge!(SESSION_CONTAINER.data, Dict(provider => Dict()))
    end

    if !content_loaded(SESSION_CONTAINER, provider, content)
        merge!(SESSION_CONTAINER.data[provider], Dict(content => Dict()))
    end

    if !locale_loaded(SESSION_CONTAINER, provider, content, locale)
        file = joinpath(ASSETS_ROOT, provider, content, locale * ".csv")
        merge!(
            SESSION_CONTAINER.data[provider][content],
            Dict(locale => CSV.read(file, DataFrame))
        )
    end

    return SESSION_CONTAINER.data[provider][content][locale]
end
