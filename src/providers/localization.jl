# TODO replace target-level with target_provider
# TODO replace options_level with optionlevel
function _hierarchical_localization_fallback(target_level, level, locale)
    target_found = false  # helps identify the correct element in 'hiarchical_order'
    hiarchical_order = [
        ["district", nothing],
        ["city", :city_name],
        ["state", :state_code],
        ["country", :country_code],
    ]

    df = _load!("localization", target_level, locale)

    for hiarchy_member in hiarchical_order

        current_level = hiarchy_member[begin]
        mergekey = hiarchy_member[end]

        if target_found
            level_df = _load!("localization", current_level, locale) 
            df = innerjoin(level_df, df; on = mergekey)
            mergekey == level && break  # upper limit for the iteractive "merge process"
        end

        if current_level == target_level
            target_found = true
        end
    end
    return df
end



"""
    country(n::Integer = 1; kwargs...)
    country(options::Vector{<:AbstractString}, n::Integer; level::Symbol, kwargs...)
    country(mask::Vector{<:AbstractString}; level::Symbol, kwargs...)

Generate `n` or `length(mask)` country names.

# Parameters
- `n::Integer = 1`: number of country name entries to generate.
- `options::Vector{<:AbstractString}`: vector with with options restricting the possible values generated.
- `mask::Vector{<:AbstractString}`: mask vector with element-wise option restrictions.

# Kwargs
- `level::Symbol = :country_code`: Level of values in `options` or `mask` when using option-based or mask-based generation. Valid `level` values are:
    - `:country_code`
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function country(n::Integer = 1; locale = session_locale())
    return rand(_load!("localization", "country", locale)[:, :country_name], n) |> coerse_string_type
end

function country(options::Vector{<:AbstractString}, n::Integer;
    level::Symbol = :country_code,
    locale = session_locale()
)
    # for the 'country' functions the only possible mask/option level is the country
    # because there is nothing higher in the hiarchy, so the only option
    # when selecting values from the country provider is the country_code
    @assert level == :country_code "invalid 'level' provided: \"$level\""

    countries = _load!("localization", "country", locale)
    filter!(r -> r[:country_code] in options, countries)
    return rand(countries[:, :country_name], n) |> coerse_string_type
end

function country(mask::Vector{<:AbstractString};
    level::Symbol = :country_code,
    locale = session_locale()
)
    # for the 'country' functions the only possible mask/option level is the country
    # because there is nothing higher in the hiarchy, so the only option
    # when selecting values from the country provider is the country_code
    @assert level == :country_code "invalid 'level' provided: \"$level\""

    multi_locale_countries = _load!("localization", "country", locale)
    gb = groupby(multi_locale_countries, level)

    selected_values = Vector{String}()

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :country_name]))
    end
    return selected_values |> coerse_string_type
end



"""
    country_code(n::Integer = 1; kwargs...)
    country_code(options::Vector{<:AbstractString}, n::Integer; level::Symbol, kwargs...)
    country_code(mask::Vector{<:AbstractString}; level::Symbol, keargs...)

Generate `n` or `length(mask)` country codes.

# Parameters
- `n::Integer = 1`: number of country codes to generate.
- `options::Vector{<:AbstractString}`: vector with options restricting the possible values generated.
- `mask::Vector{<:AbstractString}`: mask vector with element-wise option restrictions.

# Kwargs
- `level::Symbol = :country_code`: Level of values in `options` or `mask` when using option-based or mask-based eneration. Valid `level` values are:
    - `:country_code`
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function country_code(n::Integer = 1; locale = session_locale())
    return rand(_load!("localization", "country", locale)[:, :country_code], n) |> coerse_string_type
end

function country_code(options::Vector{<:AbstractString}, n::Integer;
    level::Symbol = :country_code,
    locale = session_locale()
)
    # for the 'country' functions the only possible mask/option level is the country
    # because there is nothing higher in the hiarchy, so the only option
    # when selecting values from the country provider is the country_code
    @assert level == :country_code "invalid 'level' provided: \"$level\""

    countries = _load!("localization", "country", locale)
    filter!(r -> r[:country_code] in options, countries)
    return rand(countries[:, :country_code], n) |> coerse_string_type
end

function country_code(mask::Vector{<:AbstractString};
    level::Symbol = :country_code,
    locale = session_locale()
)
    # for the 'country' functions the only possible mask/option level is the country
    # because there is nothing higher in the hiarchy, so the only option
    # when selecting values from the country provider is the country_code
    @assert level == :country_code "invalid 'level' provided: \"$level\""

    multi_locale_countries = _load!("localization", "country", locale)
    gb = groupby(multi_locale_countries, level)

    selected_values = Vector{String}()

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :country_code]))
    end
    return selected_values |> coerse_string_type
end



"""
    state(n::Integer = 1; kwargs...)
    state(options::Vector{<:AbstractString}, n::Integer; level::Symbol, kwargs...)
    state(mask::Vector{<:AbstractString}; level::Symbol, kwargs...)

# Parameters
- `n::Integer = 1`: number of country codes to generate.
- `options::Vector{<:AbstractString}`: vector with options restricting the possible values generated.
- `mask::Vector{<:AbstractString}`: mask vector with element-wise option restrictions.

# Kwargs
- `level::Symbol = :state_code`: Level of values in `options` or `mask` when using option-based or mask-based eneration. Valid `level` values are:
    - `:country_code`
    - `:state_code`
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function state(n::Integer = 1; locale = session_locale())
    return rand(_load!("localization", "state", locale)[:, :state_name], n) |> coerse_string_type
end

function state(options::Vector{<:AbstractString}, n::Integer;
    level::Symbol = :state_code,
    locale = session_locale()
)
    @assert(
        level in (:state_code, :country_code),
        "invalid 'level' provided: \"$level\""
    )

    df = _hierarchical_localization_fallback("state", level, locale)
    filter!(r -> r[level] in options, df)

    return rand(df[:, :state_name], n) |> coerse_string_type
end

function state(mask::Vector{<:AbstractString};
    level::Symbol = :state_code,
    locale = session_locale()
)
    @assert(
        level in (:state_code, :country_code),
        "invalid 'level' provided: \"$level\""
    )

    df = _hierarchical_localization_fallback("state", level, locale)
    gb = groupby(df, level)

    selected_values = Vector{String}()

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :state_name]))
    end
    return selected_values |> coerse_string_type
end



"""
    state_code(n::Integer = 1; kwargs...)
    state_code(options::Vector{<:AbstractString}, n::Integer; level::Symbol, kwargs...)
    state_code(mask::Vector{<:AbstractString}; level::Symbol, kwargs...)

# Parameters
- `n::Integer = 1`: number of state codes to generate.
- `options::Vector{<:AbstractString}`: vector with options restricting the possible values generated.
- `mask::Vector{<:AbstractString}`: mask vector with element-wise option restrictions.

# Kwargs
- `level::Symbol = :state_code`: Level of values in `options` or `mask` when using option-based or mask-based eneration. Valid `level` values are:
    - `:country_code`
    - `:state_code`
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function state_code(n::Integer = 1; locale = session_locale())
    return rand(_load!("localization", "state", locale)[:, :state_code], n) |> coerse_string_type
end

function state_code(options::Vector{<:AbstractString}, n::Integer;
    level::Symbol = :state_code,
    locale = session_locale()
)
    @assert(
        level in (:state_code, :country_code),
        "invalid 'level' provided: \"$level\""
    )

    df = _hierarchical_localization_fallback("state", level, locale)
    filter!(r -> r[level] in options, df)

    return rand(df[:, :state_code], n) |> coerse_string_type
end

function state_code(mask::Vector{<:AbstractString};
    level::Symbol = :state_code,
    locale = session_locale()
)
    @assert(
        level in (:state_code, :country_code),
        "invalid 'level' provided: \"$level\""
    )

    df = _hierarchical_localization_fallback("state", level, locale)
    gb = groupby(df, level)

    selected_values = Vector{String}()

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :state_code]))
    end
    return selected_values |> coerse_string_type
end



"""
    city(n::Integer = 1; kwargs...)
    city(options::Vector{<:AbstractString}, n::Integer; level, kwargs...)
    city(mask::Vector{<:AbstractString}; level::Symbol, kwargs...)

# Parameters
- `n::Integer = 1`: number of country codes to generate.
- `options::Vector{<:AbstractString}`: vector with options restricting the possible values generated.
- `mask::Vector{<:AbstractString}`: mask vector with element-wise option restrictions.

# Kwargs
- `level::Symbol = :city_name`: Level of values in `options` or `mask` when using option-based or mask-based eneration. Valid `level` values are:
    - `:country_code`
    - `:state_code`
    - `:city_name`
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function city(n::Integer = 1; locale = session_locale())
    return rand(_load!("localization", "city", locale)[:, :city_name], n) |> coerse_string_type
end

function city(options::Vector{<:AbstractString}, n::Integer;
    level::Symbol = :city_name,
    locale = session_locale()
)
    @assert(
        level in (:city_name, :state_code, :country_code),
        "invalid 'level' provided: \"$level\""
    )

    df = _hierarchical_localization_fallback("city", level, locale)
    filter!(r -> r[level] in options, df)

    return rand(df[:, :city_name], n) |> coerse_string_type
end

function city(mask::Vector{<:AbstractString};
    level::Symbol = :city_name,
    locale = session_locale()
)
    @assert(
        level in (:city_name, :state_code, :country_code),
        "invalid 'level' provided: \"$level\""
    )

    df = _hierarchical_localization_fallback("city", level, locale)
    gb = groupby(df, level)

    selected_values = Vector{String}()

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :city_name]))
    end
    return selected_values |> coerse_string_type
end



"""
    district(n::Integer = 1; kwargs...)
    district(options::Vector{<:AbstractString}, n::Integer; level::Symbol, kwargs...)
    district(mask::Vector{<:AbstractString}; level::Symbol, kwargs...)

# Parameters
- `n::Integer = 1`: number of district names to generate.
- `options::Vector{<:AbstractString}`: vector with options restricting the possible values generated.
- `mask::Vector{<:AbstractString}`: mask vector with element-wise option restrictions.

# Kwargs
- `level::Symbol = :district_name`: Level of values in `options` or `mask` when using option-based or mask-based eneration. Valid `level` values are:
    - `:country_code`
    - `:state_code`
    - `:city_name`
    - `:district_name`
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function district(n::Integer = 1; locale = session_locale())
    return rand(_load!("localization", "district", locale)[:, :district_name], n) |> coerse_string_type
end

function district(options::Vector{<:AbstractString}, n::Integer;
    level::Symbol = :district_name,
    locale = session_locale()
)
    @assert(
        level in (:district_name, :city_name, :state_code, :country_code),
        "invalid 'level' provided: \"$level\""
    )

    df = _hierarchical_localization_fallback("district", level, locale)
    filter!(r -> r[level] in options, df)

    return rand(df[:, :district_name], n) |> coerse_string_type
end

function district(mask::Vector{<:AbstractString};
    level::Symbol = :district_name,
    locale = session_locale()
)
    @assert(
        level in (:district_name, :city_name, :state_code, :country_code),
        "invalid 'level' provided: \"$level\""
    )

    df = _hierarchical_localization_fallback("district", level, locale)
    gb = groupby(df, level)

    selected_values = Vector{String}()

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :district_name]))
    end
    return selected_values |> coerse_string_type
end



"""
    street(n::Integer = 1; kwargs...)

Generate `n` street names.

# Kwargs
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function street(n::Integer = 1; locale = session_locale())
    streets = String[]

    # this operation is necessary because not all street formats are identical across
    # all the different locales. So the strategy here is to segregate the formats by
    # locale and then randomly pull them in order to materialize the strings
    street_formats = Dict(
        loc => _load!("localization", "street_format", loc)[:, :street_format]
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
    street_prefix(n::Integer = 1; kwargs...)

# Kwargs
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function street_prefix(n::Integer = 1; locale = session_locale())
    df = _load!("localization", "street_prefix", locale)
    return rand(df[:, :street_prefix], n) |> coerse_string_type
end



"""
    street_suffix(n::Integer = 1; kwargs...)

# Kwargs
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function street_suffix(n::Integer = 1; locale = session_locale())
    df = _load!("localization", "street_suffix", locale)
    return rand(df[:, :street_suffix], n) |> coerse_string_type
end



"""
    address(n::Integer = 1; kwargs...)
    address(options::Vector{<:AbstractString}, n::Integer = 1; level::Symbol, kwargs...)
    address(mask::Vector{<:AbstractString}; level::Symbol, kwargs...)

# Parameters
- `n::Integer = 1`: number of addresses to generate.
- `options::Vector{<:AbstractString}`: vector with options restricting the possible values generated.
- `mask::Vector{<:AbstractString}`: mask vector with element-wise option restrictions.

# Kwargs
- `level::Symbol = :district_name`: option level to be used when using option-based generation. Valid `level` values are:
    - `:country_code`
    - `:state_code`
    - `:city_name`
    - `:district_name`
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function address(n::Integer = 1; locale = session_locale())
    addresses = String[]

    locale_address_formats = Dict(
        loc => _load!("localization", "address_format", loc)[:, :address_format]
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

function address(options::Vector{<:AbstractString}, n::Integer;
    level::Symbol = :district_name,
    locale = session_locale()
)
    # valid options here are the anmes of the columns in the hierarchical dataframes produced by the
    # _hierarchical_localization_fallback function.
    @assert(
        level in (:district_name, :city_name, :state_code, :country_code),
        "invalid 'level' provided: \"$level\""
    )

    addresses = String[]

    locale_address_formats = Dict(
        loc => _load!("localization", "address_format", loc)[:, :address_format]
        for loc in locale
    )

    locale_hiarchical_dfs = Dict{String, DataFrame}(
        loc => filter(_hierarchical_localization_fallback("district", "district", loc)) do row
            row[level] in options
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

function address(mask::Vector{<:AbstractString};
    level::Symbol = :district_name,
    locale = session_locale()
)
    # valid options here are the anmes of the columns in the hierarchical dataframes produced by the
    # _hierarchical_localization_fallback function.
    @assert(
        level in (:district_name, :city_name, :state_code, :country_code),
        "invalid 'level' provided: \"$level\""
    )

    addresses = String[]

    locale_address_formats = Dict(
        loc => _load!("localization", "address_format", loc)[:, :address_format]
        for loc in locale
    )

    dfs = [
        filter(_hierarchical_localization_fallback("district", "district", loc)) do row
            row[level] in unique(mask)
        end
        for loc in locale
    ]

    locale_hiarchical_dfs = vcat(dfs...)

    for value in mask
        value_reference_dfrow = rand(eachrow(filter(r -> r[level] == value, locale_hiarchical_dfs)))
        value_locale = value_reference_dfrow[:locale] |> String
        address_format = rand(locale_address_formats[value_locale]) |> String

        push!(addresses, _materialize_template(address_format, value_reference_dfrow; locale = value_locale))
    end

    return addresses |> coerse_string_type
end



"""
    address_complement(n::Integer = 1; kwargs...)
    
# Parameters
- `n::Integer = 1`: number of address complements to generate.

# Kwargs
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function address_complement(n::Integer = 1; locale = session_locale())
    df = _load!("localization", "address_complement", locale)
    return rand(df[:, :address_complement], n) |> coerse_string_type
end



"""
    street_number(n::Integer = 1)

# Parameters
- `n::Integer = 1`: number of street numbers to generate.
"""
function street_number(n::Integer = 1; kwargs...)
    generated = rand(30:9999, n)
    return n == 1 ? only(generated) : generated
end



"""
    postcode(n::Integer = 1; kwargs...)

# Parameters
- `n::Integer = 1`: number of postcodes to generate.

# Kwargs
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function postcode(n::Integer = 1; locale = session_locale())
    postcodes = String[]

    postcode_formats = Dict(
        loc => _load!("localization", "postcode", loc)[:, :postcode]
        for loc in locale
    )

    for _ in 1:n
        loc = rand(locale)
        format = rand(postcode_formats[loc])
        push!(postcodes, _materialize_numeric_template(format))
    end
    return postcodes |> coerse_string_type
end
