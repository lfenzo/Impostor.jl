const ASSETS_ROOT::String = pkgdir(Impostor, "src", "data")
const DEFAULT_SESSION_LOCALE::Vector{String} = ["en_US"]


Base.@kwdef mutable struct DataContainer
    data::Dict = Dict()
    locale::Vector{<:AbstractString} = DEFAULT_SESSION_LOCALE
end

DataContainer(s::String) = DataContainer(Dict(), [s])
DataContainer(s::Vector{<:AbstractString}) = DataContainer(Dict(), s)


Base.empty!(d::DataContainer) = empty!(d.data)

"""
    session_locale() :: Vector{String}

Return the current session locale
"""
session_locale() = SESSION_CONTAINER.locale


"""
    setlocale!(loc::String)
    setlocale!(locs::Vector{<:AbstractString})

Set `loc` as the default locale for the current session.
"""
setlocale!(loc::String) = setproperty!(SESSION_CONTAINER, :locale, [loc])
setlocale!(locs::Vector{<:AbstractString}) = setproperty!(SESSION_CONTAINER, :locale, locs)

"""
    resetlocale!()

Reset the current session locale to `"en_US"`.
"""
function resetlocale!() :: Nothing
    empty!(SESSION_CONTAINER)
    SESSION_CONTAINER.locale = DEFAULT_SESSION_LOCALE
    return nothing
end


"""
    provider_exists(p::AbstractString) :: Bool

Return whether the provided `p` is available.

# Parameters
- `p::AbstractString`: provider name
"""
@inline function provider_exists(p::AbstractString) :: Bool
    return p in readdir(joinpath(ASSETS_ROOT))
end


"""
    content_exists(p::T, c::T) :: Bool where {T <: AbstractString}

Return whether the content `c` is available for provider `p`.

# Parameters
- `p::AbstractString`: provider name
- `c::AbstractString`: content name
"""
@inline function content_exists(p::T, c::T) :: Bool where {T <: AbstractString}
    return provider_exists(p) && c in readdir(joinpath(ASSETS_ROOT, p))
end


"""
    locale_exists(p::T, c::T, l::T) :: Bool where {T <: AbstractString}

Return whether the provided locale `l` is available for content `c` from provider `p`.

# Parameters
- `p::AbstractString`: provider name
- `c::AbstractString`: content name
- `l::AbstractString`: locale name
"""
@inline function locale_exists(p::T, c::T, l::T) :: Bool where {T <: AbstractString}
    return (
        content_exists(p, c)
        && l * ".csv" in readdir(joinpath(ASSETS_ROOT, p, c))
    )
end



@inline function _provider_loaded(d::DataContainer, provider::AbstractString) :: Bool
    return haskey(d.data,  provider)
end

@inline function _content_loaded(d::DataContainer, provider::T, content::T) :: Bool where {T <: AbstractString}
    return _provider_loaded(d, provider) && haskey(d.data[provider], content)
end

@inline function _locale_loaded(d::DataContainer, provider::T, content::T, locale::T) :: Bool where {T <: AbstractString}
    return _content_loaded(d, provider, content) && haskey(d.data[provider][content], locale)
end


"""
    _load!(provider::T, content::T, locale::Vector{T}) :: DataFrame where {T <: AbstractString}
    _load!(provider::T, content::T, locale::T = "noloc") :: DataFrame where {T <: AbstractString}

# Parameters
- `provider::AbstractString`:
- `content::AbstractString`:
- `locale::Union{AbstractString, Vector{AbstractString}}`:
"""
function _load!(provider::T, content::T, locale::Vector{T}) :: DataFrame where {T <: AbstractString}
    df = DataFrame()
    for loc in locale
        append!(df, _load!(provider, content, loc); promote = true)
    end
    return df
end

function _load!(provider::T, content::T, locale::T = "noloc") :: DataFrame where {T <: AbstractString}

    @assert(provider_exists(provider),
        "Provider '$provider' is not available.")

    @assert(content_exists(provider, content),
        "Content '$content' not available for provider '$provider'")

    @assert(locale_exists(provider, content, locale),
        "Locale '$locale' not available for content '$content' of provider '$provider'")

    if !_provider_loaded(SESSION_CONTAINER, provider)
        merge!(SESSION_CONTAINER.data, Dict(provider => Dict()))
    end

    if !_content_loaded(SESSION_CONTAINER, provider, content)
        merge!(SESSION_CONTAINER.data[provider], Dict(content => Dict()))
    end

    if !_locale_loaded(SESSION_CONTAINER, provider, content, locale)
    
        data_path = joinpath(ASSETS_ROOT, provider, content, locale * ".csv")
        header = joinpath(ASSETS_ROOT, provider, content, "HEADER.txt") |> readlines

        merge!(
            SESSION_CONTAINER.data[provider][content],
            Dict(locale => CSV.read(data_path, DataFrame; header, delim = ','))
        )
    end

    return SESSION_CONTAINER.data[provider][content][locale]
end
