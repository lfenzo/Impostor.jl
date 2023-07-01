# TODO replace target-level with target_provider
# TODO replace options_level with optionlevel
function _hierarchical_localization_fallback(target_level, option_level, locale)
    target_found = false  # helps identify the correct element in 'hiarchical_order'
    hiarchical_order = [
        ["district", nothing],
        ["city", :city_name],
        ["state", :state_code],
        ["country", :country_code],
    ]

    df = load!("localization", target_level, locale)

    for hiarchy_member in hiarchical_order

        level = hiarchy_member[begin]
        mergekey = hiarchy_member[end]

        if target_found
            level_df = load!("localization", level, locale) 
            df = innerjoin(level_df, df; on = mergekey)
            mergekey == option_level && break  # upper limit for the iteractive "merge process"
        end

        if level == target_level
            target_found = true
        end
    end
    return df
end



"""

"""
function country(n::Integer = 1; locale = session_locale())
    return rand(load!("localization", "country", locale)[:, :country_name], n) |> coerse_string_type
end

"""

"""
function country(options::Vector{<:AbstractString}, n::Integer; optionlevel::Symbol = :country_code, locale = session_locale())

    # for the 'country' functions the only possible mask/option level is the country
    # because there is nothing higher in the hiarchy, so the only option
    # when selecting values from the country provider is the country_code
    @assert optionlevel == :country_code "invalid 'masklevel' provided: \"$optionlevel\""

    countries = load!("localization", "country", locale)
    filter!(r -> r[:country_code] in options, countries)
    return rand(countries[:, :country_name], n) |> coerse_string_type
end

"""

"""
function country(mask::Vector{<:AbstractString}; masklevel::Symbol = :country_code, locale = session_locale())

    # for the 'country' functions the only possible mask/option level is the country
    # because there is nothing higher in the hiarchy, so the only option
    # when selecting values from the country provider is the country_code
    @assert masklevel == :country_code "invalid 'masklevel' provided: \"$masklevel\""

    multi_locale_countries = load!("localization", "country", locale)
    gb = groupby(multi_locale_countries, masklevel)

    selected_values = Vector{String}()

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :country_name]))
    end
    return selected_values |> coerse_string_type
end



"""

"""
function country_code(n::Integer = 1; locale = session_locale())
    return rand(load!("localization", "country", locale)[:, :country_code], n) |> coerse_string_type
end

"""

"""
function country_code(options::Vector{<:AbstractString}, n::Integer; optionlevel::Symbol = :country_code, locale = session_locale())

    # for the 'country' functions the only possible mask/option level is the country
    # because there is nothing higher in the hiarchy, so the only option
    # when selecting values from the country provider is the country_code
    @assert optionlevel == :country_code "invalid 'masklevel' provided: \"$optionlevel\""

    countries = load!("localization", "country", locale)
    filter!(r -> r[:country_code] in options, countries)
    return rand(countries[:, :country_code], n) |> coerse_string_type
end

"""

"""
function country_code(mask::Vector{<:AbstractString}; masklevel::Symbol = :country_code, locale = session_locale())

    # for the 'country' functions the only possible mask/option level is the country
    # because there is nothing higher in the hiarchy, so the only option
    # when selecting values from the country provider is the country_code
    @assert masklevel == :country_code "invalid 'masklevel' provided: \"$masklevel\""

    multi_locale_countries = load!("localization", "country", locale)
    gb = groupby(multi_locale_countries, masklevel)

    selected_values = Vector{String}()

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :country_code]))
    end
    return selected_values |> coerse_string_type
end



"""

"""
function state(n::Integer = 1; locale = session_locale())
    return rand(load!("localization", "state", locale)[:, :state_name], n) |> coerse_string_type
end

"""

"""
function state(options::Vector{<:AbstractString}, n::Integer; optionlevel::Symbol = :state_code, locale = session_locale())

    @assert optionlevel in (:state_code, :country_code) "invalid 'optionlevel' provided: \"$optionlevel\""

    df = _hierarchical_localization_fallback("state", optionlevel, locale)
    filter!(r -> r[optionlevel] in options, df)

    return rand(df[:, :state_name], n) |> coerse_string_type
end

"""

"""
function state(mask::Vector{<:AbstractString}; masklevel::Symbol = :state_code, locale = session_locale())

    @assert masklevel in (:state_code, :country_code) "invalid 'masklevel' provided: \"$masklevel\""

    df = _hierarchical_localization_fallback("state", masklevel, locale)
    gb = groupby(df, masklevel)

    selected_values = Vector{String}()

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :state_name]))
    end
    return selected_values |> coerse_string_type
end



"""

"""
function state_code(n::Integer = 1; locale = session_locale())
    return rand(load!("localization", "state", locale)[:, :state_code], n) |> coerse_string_type
end

function state_code(options::Vector{<:AbstractString}, n::Integer; optionlevel::Symbol = :state_code, locale = session_locale())

    @assert optionlevel in (:state_code, :country_code) "invalid 'optionlevel' provided: \"$optionlevel\""

    df = _hierarchical_localization_fallback("state", optionlevel, locale)
    filter!(r -> r[optionlevel] in options, df)

    return rand(df[:, :state_code], n) |> coerse_string_type
end

"""

"""
function state_code(mask::Vector{<:AbstractString}; masklevel::Symbol = :state_code, locale = session_locale())

    @assert masklevel in (:state_code, :country_code) "invalid 'masklevel' provided: \"$masklevel\""

    df = _hierarchical_localization_fallback("state", masklevel, locale)
    gb = groupby(df, masklevel)

    selected_values = Vector{String}()

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :state_code]))
    end
    return selected_values |> coerse_string_type
end



"""

"""
function city(n::Integer = 1; locale = session_locale())
    return rand(load!("localization", "city", locale)[:, :city_name], n) |> coerse_string_type
end

"""

"""
function city(options::Vector{<:AbstractString}, n::Integer; optionlevel = :city_name, locale = session_locale())

    @assert optionlevel in (:city_name, :state_code, :country_code) "invalid 'optionlevel' provided: \"$optionlevel\""

    df = _hierarchical_localization_fallback("city", optionlevel, locale)
    filter!(r -> r[optionlevel] in options, df)

    return rand(df[:, :city_name], n) |> coerse_string_type
end

"""

"""
function city(mask::Vector{<:AbstractString}; masklevel::Symbol = :city_name, locale = session_locale())

    @assert masklevel in (:city_name, :state_code, :country_code) "invalid 'masklevel' provided: \"$masklevel\""

    df = _hierarchical_localization_fallback("city", masklevel, locale)
    gb = groupby(df, masklevel)

    selected_values = Vector{String}()

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :city_name]))
    end
    return selected_values |> coerse_string_type
end



"""

"""
function district(n::Integer = 1; locale = session_locale())
    return rand(load!("localization", "district", locale)[:, :district_name], n) |> coerse_string_type
end

function district(options::Vector{<:AbstractString}, n::Integer; optionlevel::Symbol = :district_name, locale = session_locale())

    @assert(
        optionlevel in (:district_name, :city_name, :state_code, :country_code),
        "invalid 'optionlevel' provided: \"$optionlevel\""
    )

    df = _hierarchical_localization_fallback("district", optionlevel, locale)
    filter!(r -> r[optionlevel] in options, df)

    return rand(df[:, :district_name], n) |> coerse_string_type
end

"""

"""
function district(mask::Vector{<:AbstractString}; masklevel::Symbol = :district_name, locale = session_locale())

    @assert(
        masklevel in (:district_name, :city_name, :state_code, :country_code),
        "invalid 'masklevel' provided: \"$masklevel\""
    )

    df = _hierarchical_localization_fallback("district", masklevel, locale)
    gb = groupby(df, masklevel)

    selected_values = Vector{String}()

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :district_name]))
    end
    return selected_values |> coerse_string_type
end



"""

"""
function street(n::Integer = 1; locale = session_locale())
    streets = String[]

    # this operation is necessary because not all street formats are identical across
    # all the different locales. So the strategy here is to segregate the formats by
    # locale and then randomly pull them in order to materialize the strings
    street_formats = Dict(
        loc => load!("localization", "street_format", loc)[:, :street_format]
        for loc in locale
    )

    for _ in 1:n
        loc = rand(locale)
        format = rand(street_formats[loc])
        push!(streets, _materialize_template(format; locale = loc))
    end
    return streets |> coerse_string_type
end


"""

"""
function street_prefix(n::Integer = 1; locale = session_locale())
    df = load!("localization", "street_prefix", locale)
    return rand(df[:, :street_prefix], n) |> coerse_string_type
end


"""

"""
function street_suffix(n::Integer = 1; locale = session_locale())
    df = load!("localization", "street_suffix", locale)
    return rand(df[:, :street_suffix], n) |> coerse_string_type
end



"""

"""
function address(n::Integer = 1; locale = session_locale())
    addresses = String[]

    locale_address_formats = Dict(
        loc => load!("localization", "address_format", loc)[:, :address_format]
        for loc in locale
    )

    locale_hiarchical_dfs = Dict{String, DataFrame}(
        # here we must obtain this dataframe in the finest granularity possible, so we are
        # passing "district" and "district".
        loc => _hierarchical_localization_fallback("district", "district", loc)
        for loc in locale
    )

    for _ in 1:n
        loc = rand(locale)
        address_format = rand(locale_address_formats[loc])
        reference_localization_dfrow = rand(eachrow(locale_hiarchical_dfs[loc]))
        push!(addresses, _materialize_template(address_format, reference_localization_dfrow; locale = loc))
    end

    return addresses |> coerse_string_type
end


"""

"""
function address(options::Vector{<:AbstractString}, n::Integer = 1; optionlevel = :district_name, locale = session_locale())

    # valid options here are the anmes of the columns in the hierarchical dataframes produced by the
    # _hierarchical_localization_fallback function.
    @assert(
        optionlevel in (:district_name, :city_name, :state_code, :country_code),
        "invalid 'optionlevel' provided: \"$optionlevel\""
    )

    addresses = String[]

    locale_address_formats = Dict(
        loc => load!("localization", "address_format", loc)[:, :address_format]
        for loc in locale
    )

    locale_hiarchical_dfs = Dict{String, DataFrame}(
        loc => filter(_hierarchical_localization_fallback("district", "district", loc)) do row
            row[optionlevel] in options
        end
        for loc in locale
    )

    for _ in 1:n
        loc = rand(locale)
        address_format = rand(locale_address_formats[loc])
        reference_localization_dfrow = rand(eachrow(locale_hiarchical_dfs[loc]))
        push!(addresses, _materialize_template(address_format, reference_localization_dfrow; locale = loc))
    end

    return addresses |> coerse_string_type
end



"""

"""
function address_complement(n::Integer = 1; locale = session_locale())
    df = load!("localization", "address_complement", locale)
    return rand(df[:, :address_complement], n) |> coerse_string_type
end


"""

"""
function street_number(n::Integer = 1; locale = nothing)
    # locale is kept here for API consistency
    generated = rand(30:9999, n)
    return n == 1 ? only(generated) : generated
end


"""

"""
function postcode(n::Integer = 1; locale = session_locale())
    postcodes = String[]

    postcode_formats = Dict(
        loc => load!("localization", "postcode", loc)[:, :postcode]
        for loc in locale
    )

    for _ in 1:n
        loc = rand(locale)
        format = rand(postcode_formats[loc])
        push!(postcodes, _materialize_numeric_template(format))
    end
    return postcodes |> coerse_string_type
end
