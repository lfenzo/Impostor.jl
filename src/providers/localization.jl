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



function state(n::Int = 1; locale = getlocale())
    return rand(load!("state", "localization", locale), n) |> return_unpacker
end

state(locales::Vector{String}, n::Int) = state(n; locale = locales)

function state(locale_mask::Vector{String})
    states = String[]
    for locale in locale_mask
        push!(states, state([locale], 1))
    end
    return states
end



function city(n::Int = 1; locale = getlocale())
    return rand(load!("city", "localization", locale), n) |> return_unpacker
end

function city(states::Vector{String}, n::Int; locale = getlocale())
    return rand(load!("city", "localization", locale; options = states), n) |> return_unpacker
end

function city(mask::Vector{String}; masklevel::Symbol = :state, locale = getlocale())

    if !(masklevel in [:state, :locale])
        throw(ArgumentError("provided mask level '$masklevel' not recognized."))
    end

    cities = Vector{String}()

    if masklevel == :state
        for value in mask
            push!(cities, city([value], 1; locale = locale))
        end
    elseif masklevel == :locale
        for value in mask
            push!(cities, city(1; locale = [value]))
        end
    end

    return cities
end



function district(n::Int = 1; locale = getlocale())
    return rand(load!("district", "localization", locale), n) |> return_unpacker
end

function district(options::Vector{String}, n::Int; masklevel::Symbol = :city, locale = getlocale())

    if !(masklevel in [:city, :state])
        throw(ArgumentError("provided mask level '$masklevel' not recognized."))
    end

    districts = Vector{String}()

    if level == :city
        districts = load!("district", "localization", locale; options = options)
    elseif level == :state
        cities = city(options, n; locale = locale)
        _cities = cities isa String ? [cities] : cities
        districts = load!("district", "localization", locale; options = _cities)
    end

    return rand(districts, n) |> return_unpacker
end

function district(mask::Vector{String}; level::Symbol = :city, locale = getlocale())

    if !(level in [:city, :state])
        throw(ArgumentError("provided mask level '$masklevel' not recognized."))
    end

    districts = Vector{String}()
    for value in mask
        push!(districts, district([value], 1; level = level, locale = locale))
    end

    return districts
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
