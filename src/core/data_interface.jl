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

Return the current session locale.
"""
session_locale() = SESSION_CONTAINER.locale



"""
    setlocale!(loc::String)
    setlocale!(loc::Vector{<:AbstractString})

Set `loc` as the default locale for the current session.
"""
setlocale!(loc::String) = setproperty!(SESSION_CONTAINER, :locale, [loc])
setlocale!(loc::Vector{<:AbstractString}) = setproperty!(SESSION_CONTAINER, :locale, loc)


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
    is_provider_available(p::AbstractString) :: Bool

Return whether the provided `p` is available.

# Parameters
- `p::AbstractString`: provider name
"""
@inline function is_provider_available(p::AbstractString) :: Bool
    return p in readdir(joinpath(ASSETS_ROOT))
end


"""
    is_content_available(p::T, c::T) :: Bool where {T <: AbstractString}

Return whether the content `c` is available for provider `p`.

# Parameters
- `p::AbstractString`: provider name
- `c::AbstractString`: content name
"""
@inline function is_content_available(p::T, c::T) :: Bool where {T <: AbstractString}
    return is_provider_available(p) && c in readdir(joinpath(ASSETS_ROOT, p))
end


"""
    is_locale_available(p::T, c::T, l::T) :: Bool where {T <: AbstractString}

Return whether the provided locale `l` is available for content `c` from provider `p`.

# Parameters
- `p::AbstractString`: provider name
- `c::AbstractString`: content name
- `l::AbstractString`: locale name
"""
@inline function is_locale_available(p::T, c::T, l::T) :: Bool where {T <: AbstractString}
    return (
        is_content_available(p, c)
        && l * ".csv" in readdir(joinpath(ASSETS_ROOT, p, c))
    )
end



"""
    is_provider_loaded(d::DataContainer, provider::AbstractString) :: Bool

Return whether the DataContainer `d` has already loaded the information associated to the content `c`.
"""
@inline function is_provider_loaded(d::DataContainer, provider::AbstractString) :: Bool
    return haskey(d.data,  provider)
end



"""
    is_content_loaded(d::DataContainer, provider::T, content::T) :: Bool 

Return whether the DataContainer `d` has already loaded the information associated to the content `c`
from provider `p`.
"""
@inline function is_content_loaded(d::DataContainer, provider::T, content::T) :: Bool where {T <: AbstractString}
    return is_provider_loaded(d, provider) && haskey(d.data[provider], content)
end



"""
    is_locale_loaded(d::DataContainer, provider::T, content::T, locale::T) :: Bool

Return whether the DataContainer `d` has already loaded the information associated to the content `c`
from provider `p` related to locale `l`.
"""
@inline function is_locale_loaded(d::DataContainer, provider::T, content::T, locale::T) :: Bool where {T <: AbstractString}
    return is_content_loaded(d, provider, content) && haskey(d.data[provider][content], locale)
end



"""
    _load!(provider::T, content::T, locale::Vector{T}) :: DataFrame where {T <: AbstractString}
    _load!(provider::T, content::T, locale::T = "noloc") :: DataFrame where {T <: AbstractString}

Fetch from the data archive the `content` associated to the provided `locale` and `provider`. Data
is returned as a DataFrame for further manipulation. Optionally provide `locale = "noloc` for the
specific contents without any locale assocated to them.

# Parameters
- `provider::AbstractString`: provider name, *e.g.* `"localization"`.
- `content::AbstractString`: content name, *e.g.* `"street_prefix"`.
- `locale::Union{AbstractString, Vector{AbstractString}} = "noloc"`: locale(s) associated to the `content` and `provider` provided. Defaults to the `"noloc"` placeholder for contents which are considered "locale-less".
"""
function _load!(provider::T, content::T, locale::Vector{T}) :: DataFrame where {T <: AbstractString}
    df = DataFrame()
    for loc in locale
        append!(df, _load!(provider, content, loc); promote = true)
    end
    return df
end

function _load!(provider::T, content::T, locale::T = "noloc") :: DataFrame where {T <: AbstractString}

    @assert(is_provider_available(provider),
        "Provider '$provider' is not available.")

    @assert(is_content_available(provider, content),
        "Content '$content' not available for provider '$provider'")

    @assert(is_locale_available(provider, content, locale),
        "Locale '$locale' not available for content '$content' of provider '$provider'")

    if !is_provider_loaded(SESSION_CONTAINER, provider)
        merge!(SESSION_CONTAINER.data, Dict(provider => Dict()))
    end

    if !is_content_loaded(SESSION_CONTAINER, provider, content)
        merge!(SESSION_CONTAINER.data[provider], Dict(content => Dict()))
    end

    if !is_locale_loaded(SESSION_CONTAINER, provider, content, locale)
        data_archive_location = joinpath(ASSETS_ROOT, provider, content)
        file = joinpath(data_archive_location, locale * ".csv")
        header = joinpath(data_archive_location, "HEADER.txt") |> readlines
        merge!(
            SESSION_CONTAINER.data[provider][content],
            Dict(locale => CSV.read(file, DataFrame; header, delim = ';'))
        )
    end

    return SESSION_CONTAINER.data[provider][content][locale]
end
