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
    load!(option_mask::Vector{T}, content::T, provider::T, locale::Vector{T} = getlocale())

Corresponds to a special case in the option-based loading in which *the options provided in the 
`option_mask` are garanteed to have the same set of possible values across the `content` and
`provider`. See the functions which fit in this case in the file `src/core/data_restrictions.jl`.

When the possible set of options is not the same for the provided `content` and `provider`, as in
`state` the method `load!(content, provider, locale = getlocale(); options = String[])` is the 
only alternative.

# Parameters
- `option_mask::Vector{AbstractString}`: 
- `content::AbstractString`: 
- `provider::AbstractString`: 
- `locale::AbstractString`: 
"""
# TODO: benchmark this against load!(content, provider, locale::Vector; options) when we have
# reasonable amount of data. Theoretically, this should be an optimized version for the case in
# which the keys are garanteed to be the same.
function load!(option_mask::Vector{T}, content::T, provider::T, locale::Vector{T} = getlocale()) where {T <: AbstractString}

    value_pools = Dict()

    for loc in locale
        loaded_content = load!(content, provider, loc)
        for mask_value in unique(option_mask)
            if mask_value in keys(loaded_content)
                if !(mask_value in keys(value_pools))
                    value_pools[mask_value] = []
                end
                value_pools[mask_value] = vcat(value_pools[mask_value], loaded_content[mask_value])
            end
        end
    end

    selected_values = Vector{String}()
    for value in option_mask
        push!(selected_values, rand(value_pools[value]))
    end

    return selected_values
end


"""
    load!(content, provider, locale = getlocale(); options = String[])

Provide "option-based" loading implementation. This function is responsible for loading data from
multiple locales with the optional filter specified in `options`, i.e. select only the entries
associated with the provided options.

When `options` are provided for a single locale, the content associated to that locale and provider
is loaded into a Dict object and the provided `options` are searched inside the returned dict.
If no such `options` are found in the dictionary an exception will be thrown.

When multiple locales are provided, it is possible that the set of `options` provided during this
function call fits in the following situations:
    - The keys in `options` are only valid for one of the locales. For example, when calling the 
    function passing `options = ["CA"]` as state code and `locale = ["en_US", "pt_BR"]` indicating
    the selected locales for the `city` function, this `load!` method will only return the
    entries associated to the `"CA"` option in `"en_US"` (for the "`pt_BR`" locale there are no 
    "CA" options). Despite being unable to find entries for this option in the `"pt_BR` locale 
    the method returns without throwing any exception, because *some* entries were found in
    another locale.
    - The keys in `options` are not valid for neither of the provided locales. In this case an
    exception is thrown, for that no entries were retrieved from the data corresponding to the
    provided `options`.
In other words, this `load!` method will try its best to find matches for whatever values of
`options` and `locales` provided, when it fails to find *any* match it throws an exception.

When no `options` are provided, all keys associated to each of the contents in each of the locales
are 'flattened' returned in single `Vector{String}` object.

# Parameters 
- `content::AbstractString`:
- `provider::AbstractString`:
- `locale::Vector{<:AbstractString}`:
- `options::Vector{<:AbstractString}`:
"""
function load!(content::T, provider::T, locale::Vector{T} = getlocale(); options::Vector{T} = String[]) where {T <: AbstractString}

    values = Vector{String}()

    for loc in locale
        loaded = load!(content, provider, loc)
        # if the loaded content is a dictionary (e.g. 'firstname' or 'occupation') which keys specify
        # options to be chosen, then we must 'flatten' these dicts pushing their values to a Vector.
        if loaded isa Dict 
            selected_keys = isempty(options) ? keys(loaded) : options
            for key in selected_keys
                # consider the situation in which we are passing the "IL" (Illinois) state for 
                # the locales ["en_US", "pt_BR"]. We have this state in the keys of "en_US", but
                # not in the keys of "pt_BR". So here we only return the values of the entries
                # for existing keys in the respective JSON files
                if key in keys(loaded)
                    values = vcat(values, convert(Vector{String}, loaded[key]))  # 'convert' ensures type-stabilty
                end
            end
        else
            values = vcat(values, loaded)
        end
    end

    isempty(values) && throw(
        KeyError(
            "No entries found for content '$content', provider '$provider', locale\
            $locale with options '$options'"
        )
    )

    return values
end


"""
    load!(content::T, provider::T, locale::T) where {T <: AbstractString}

Load the smallest retrieveble data from the `src/data/` directory associated to `content`,
a `provider` and a `locale`, which is either a:
    - `Dict{String, Vector{String}}`: a dictionary with the only key as the name of the content 
    to be retrieved or;
    - `Dict{String, Dict{String, Vector{String}}}`: a dictionary with other "sub-dictionaries" each
    of them mapping an `option` value to a `Vector{String}` containing the entries.

All checks on `content`, `provider` and `locale` validity are centered in this method it is 
used as the common fallback for the other `load!` methods.
"""
function load!(content::T, provider::T, locale::T) where {T <: AbstractString}

    _verify_load_parameters(locale, provider, content)

    # when not present, add the locale to the session data container
    if !haslocale(SESSION_CONTAINER, locale)
        merge!(SESSION_CONTAINER.data, Dict(locale => Dict()))
    end

    # when not present, add the provider to the provided locale in the sessions data container
    if !hasprovider(SESSION_CONTAINER, locale, provider)
        merge!(SESSION_CONTAINER.data[locale], Dict(provider => Dict()))
    end

    # adding the content to the data container in the respective locale and 
    # provider in case it doesn't have it
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
