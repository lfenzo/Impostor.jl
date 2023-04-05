"""

"""
function country(n::Int = 1; locale = getlocale(), ignore_locale::Bool = false)
    # available countries in each of the directoreis in `data/*/localization/country.json`
    if ignore_locale
        countries = Vector{String}()
        for locale in readdir(ASSETS_ROOT)
            locale == "template" && continue
            # assuming for now that each locale is associated to only one country
            push!(countries, only(load!("country", "localization", locale)))
        end
        return rand(countries, n) |> return_unpacker
    else
        return rand(load!("country", "localization", locale), n) |> return_unpacker
    end
end



"""

"""
# the following two 'state' methods are equivalent. In practice, they mimic the same functionality
# with two different behaviors: 'state(n; locale = ["foo", "bar"])' and 'state(["foo", "bar"], n)'
function state(n::Int = 1; locale = getlocale())
    return rand(load!("state", "localization", locale), n) |> return_unpacker
end

"""

"""
state(locales::Vector{String}, n::Int) = state(n; locale = locales)

"""

"""
# notice that since state takes locales as mask values, we don't need to specify
# the locale in the function header
function state(locale_mask::Vector{String})
    return load!(locale_mask, "state", "localization", unique(locale_mask))
end



"""

"""
function state_code(n::Int = 1; locale = getlocale())
    return rand(load!("state_code", "localization", locale), n) |> return_unpacker
end

"""

"""
state_code(locales::Vector{String}, n::Int) = state_code(n; locale = locales)

"""

"""
function state_code(locale_mask::Vector{String})
    return load!(locale_mask, "state_code", "localization", unique(locale_mask))
end



"""

"""
function city(n::Int = 1; locale = getlocale())
    return rand(load!("city", "localization", locale), n) |> return_unpacker
end

"""

"""
function city(states::Vector{String}, n::Int; locale = getlocale())
    return rand(load!("city", "localization", locale; options = states), n) |> return_unpacker
end

"""

"""
function city(mask::Vector{String}; masklevel::Symbol = :state, locale = getlocale())

    @assert masklevel in [:state, :locale] "provided mask level '$masklevel' not recognized."

    # if masklevel == :locale we must generate a state_mask so that we can forward this
    # mask to the load! method. In the end this 'city' methods accepts both 'state' and 'locale'
    # valued masks, but the data loading is performed providing only the state mask.
    _mask = masklevel == :state ? mask : state_code(mask)

    return load!(_mask, "city", "localization", locale)
end



"""

"""
function district(n::Int = 1; locale = getlocale())
    return rand(load!("district", "localization", locale), n) |> return_unpacker
end

"""

"""
function district(options::Vector{String}, n::Int; option_level::Symbol = :city, locale = getlocale())

    @assert option_level in [:city, :state] "provided mask level '$option_level' not recognized."
    districts = Vector{String}()

    if option_level == :city
        districts = load!("district", "localization", locale; options = options)
    elseif option_level == :state
        cities = city(options, n; locale = locale) |> return_unpacker
        districts = load!("district", "localization", locale; options = cities)
    end

    return rand(districts, n) |> return_unpacker
end

"""

"""
function district(mask::Vector{String}; masklevel::Symbol = :city, locale = getlocale())

    @assert masklevel in [:city, :state] "provided mask level '$masklevel' not recognized."

    # if masklevel == :city then we can forward this mask to the respective load! method in
    # order to load the districts restricted by the cities, but if masklevel == :state we need
    # first to generate a city mask from this state mask in order to load the districts. This
    # happens because the mask-based load!-ing for the district content uses only the city name
    # as a selector for the entries
    _mask = masklevel == :city ? mask : city(mask, masklevel = masklevel, locale = locale)

    return load!(_mask, "district", "localization", locale)
end


"""
    _country_name2locale()

Return a dictionary mapping the Country name to the respective Locale
"""
function _country_name2locale() :: Dict{String, String}
    dict = Dict{String, String}()
    for locale in readdir(ASSETS_ROOT)
        locale == "template" && continue
        country_name = only(load!("country", "localization", locale))
        dict[country_name] = locale
    end
    return dict
end
