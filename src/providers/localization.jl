"""
    

"""
function materialize_localization_map(; src = nothing, dst = nothing, locale = nothing, joinhow = :outer)

    joinfunc = Dict(
        :inner => DataFrames.innerjoin,
        :outer => DataFrames.outerjoin,
    )

    locales = _load!("localization", "locale", "noloc")
    all_locales = convert.(String, unique(locales[:, :locale]))

    df = @chain begin
        locales
        joinfunc[joinhow](_load!("localization", "country", all_locales); on = ["country_code", "locale"])
        joinfunc[joinhow](_load!("localization", "state", all_locales); on = "country_code")
        joinfunc[joinhow](_load!("localization", "city", all_locales); on = "state_code")
        joinfunc[joinhow](_load!("localization", "district", all_locales); on = "city")
    end

    if !isnothing(locale)
        df = filter(r -> r[:locale] in locale, df)
    end

    if !isnothing(src) && !isnothing(dst)
        df = @chain df unique([src, dst]) select([src, dst])
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
    level::Symbol = :state_code,
    locale = session_locale()
)
    df = materialize_localization_map(; src = "country", dst = string(level), locale)
    filter!(r -> r[level] in options, df)
    return rand(convert.(String, df[:, :country]), n) |> coerse_string_type
end

function country(mask::Vector{<:AbstractString};
    level::Symbol = :state_code,
    locale = session_locale()
)
    selected_values = Vector{String}()

    gb = @chain begin
        materialize_localization_map(; src = "country", dst = string(level), locale)
        groupby([level])
    end

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :country]))
    end
    return selected_values |> coerse_string_type
end



"""
    country_official_name(n::Integer = 1; kwargs...)
    country_official_name(options::Vector{<:AbstractString}, n::Integer; level::Symbol, kwargs...)
    country_official_name(mask::Vector{<:AbstractString}; level::Symbol, kwargs...)

Generate `n` or `length(mask)` country offiical names.

# Parameters
- `n::Integer = 1`: number of country official names entries to generate.
- `options::Vector{<:AbstractString}`: vector with with options restricting the possible values generated.
- `mask::Vector{<:AbstractString}`: mask vector with element-wise option restrictions.

# Kwargs
- `level::Symbol = :country_code`: Level of values in `options` or `mask` when using option-based or mask-based generation. Valid `level` values are:
    - `:country_code`
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function country_official_name(n::Integer = 1; locale = session_locale())
    return rand(_load!("localization", "country", locale)[:, :country_official_name], n) |> coerse_string_type
end

function country_official_name(options::Vector{<:AbstractString}, n::Integer;
    level::Symbol = :state_code,
    locale = session_locale()
)
    df = materialize_localization_map(; src = "country_official_name", dst = string(level), locale)
    filter!(r -> r[level] in options, df)
    return rand(convert.(String, df[:, :country_official_name]), n) |> coerse_string_type
end

function country_official_name(mask::Vector{<:AbstractString}; level::Symbol = :state_code, locale = session_locale())
    selected_values = Vector{String}()

    gb = @chain begin
        materialize_localization_map(; src = "country_official_name", dst = string(level), locale)
        groupby([level])
    end

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :country_official_name]))
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

function country_code(options::Vector{<:AbstractString}, n::Integer; level::Symbol = :state_code, locale = session_locale())
    df = materialize_localization_map(; src = "country_code", dst = string(level), locale)
    filter!(r -> r[level] in options, df)
    return rand(convert.(String, df[:, :country_code]), n) |> coerse_string_type
end

function country_code(mask::Vector{<:AbstractString}; level::Symbol = :state_code, locale = session_locale())
    gb = @chain begin
        materialize_localization_map(; src = "country_code", dst = string(level), locale)
        groupby([level])
    end

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
- `level::Symbol = :country_code`: Level of values in `options` or `mask` when using option-based or mask-based eneration.
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function state(n::Integer = 1; locale = session_locale())
    return rand(_load!("localization", "state", locale)[:, :state], n) |> coerse_string_type
end

function state(options::Vector{<:AbstractString}, n::Integer;
    level::Symbol = :country_code,
    locale = session_locale()
)
    df = materialize_localization_map(; src = "state", dst = string(level), locale)
    filter!(r -> r[level] in options, df)
    return rand(convert.(String, df[:, :state]), n) |> coerse_string_type
end

function state(mask::Vector{<:AbstractString};
    level::Symbol = :country_code,
    locale = session_locale()
)
    gb = @chain begin
        materialize_localization_map(; src = "state", dst = string(level), locale)
        groupby([level])
    end

    selected_values = Vector{String}()

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :state]))
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
- `level::Symbol = :country_code`: Level of values in `options` or `mask` when using option-based or mask-based eneration.
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function state_code(n::Integer = 1; locale = session_locale())
    return rand(_load!("localization", "state", locale)[:, :state_code], n) |> coerse_string_type
end

function state_code(options::Vector{<:AbstractString}, n::Integer;
    level::Symbol = :country_code,
    locale = session_locale()
)
    df = materialize_localization_map(; src = "state_code", dst = string(level), locale)
    filter!(r -> r[level] in options, df)
    return rand(convert.(String, df[:, :state_code]), n) |> coerse_string_type
end

function state_code(mask::Vector{<:AbstractString};
    level::Symbol = :country_code,
    locale = session_locale()
)
    gb = @chain begin
        materialize_localization_map(; src = "state_code", dst = string(level), locale)
        groupby([level])
    end

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
- `level::Symbol = :state_code`: Level of values in `options` or `mask` when using option-based or mask-based eneration.
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function city(n::Integer = 1; locale = session_locale())
    return rand(_load!("localization", "city", locale)[:, :city], n) |> coerse_string_type
end

function city(options::Vector{<:AbstractString}, n::Integer;
    level::Symbol = :state_code,
    locale = session_locale()
)
    df = materialize_localization_map(; src = "city", dst = string(level), locale)
    filter!(r -> r[level] in options, df)
    return rand(convert.(String, df[:, :city]), n) |> coerse_string_type
end

function city(mask::Vector{<:AbstractString}; level::Symbol = :city, locale = session_locale())
    gb = @chain begin
        materialize_localization_map(; src = "city", dst = string(level), locale)
        groupby([level])
    end

    selected_values = Vector{String}()

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :city]))
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
    level::Symbol = :city_name,
    locale = session_locale()
)
    df = materialize_localization_map(; src = "district", dst = string(level), locale)
    filter!(r -> r[level] in options, df)
    return rand(convert.(String, df[:, :district]), n) |> coerse_string_type
end

function district(mask::Vector{<:AbstractString};
    level::Symbol = :district_name,
    locale = session_locale()
)
    gb = @chain begin
        materialize_localization_map(; src = "district", dst = string(level), locale)
        groupby([level])
    end

    selected_values = Vector{String}()

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :district]))
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
        format = rand(street_formats[loc]) |> String
        push!(streets, materialize_template(format; locale = loc))
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
- `level::Symbol = :state_code`: option level to be used when using option-based generation.
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function address(n::Integer = 1; locale = session_locale())
    addresses = String[]

    locale_address_formats = Dict(
        loc => _load!("localization", "address_format", loc)[:, :address_format]
        for loc in locale
    )
    
    gb = @chain begin
        materialize_localization_map(; locale, joinhow = :inner)
        groupby(:locale)
    end

    for _ in 1:n
        loc = rand(locale)
        associated_rows = get(gb, (loc,), nothing)
        address_format = rand(locale_address_formats[loc])
        reference_localization_dfrow = rand(eachrow(associated_rows))
        push!(addresses, materialize_template(address_format, reference_localization_dfrow; locale = loc))
    end

    return addresses |> coerse_string_type
end

function address(options::Vector{<:AbstractString}, n::Integer;
    level::Symbol = :state_cide,
    locale = session_locale()
)
    addresses = String[]

    locale_address_formats = Dict(
        loc => _load!("localization", "address_format", loc)[:, :address_format]
        for loc in locale
    )

    gb = @chain begin
        materialize_localization_map(; locale, joinhow = :inner)
        filter(row -> row[level] in options, _)  # that's the difference of the option-based version
        groupby(:locale)
    end

    for _ in 1:n
        loc = rand(locale)
        associated_rows = get(gb, (loc,), nothing)
        address_format = rand(locale_address_formats[loc])
        reference_localization_dfrow = rand(eachrow(associated_rows))
        push!(addresses, materialize_template(address_format, reference_localization_dfrow; locale = loc))
    end

    return addresses |> coerse_string_type
end

function address(mask::Vector{<:AbstractString};
    level::Symbol = :state_code,
    locale = session_locale()
)
    addresses = String[]

    locale_address_formats = Dict(
        loc => _load!("localization", "address_format", loc)[:, :address_format]
        for loc in locale
    )

    df = @chain begin
        materialize_localization_map(; locale, joinhow = :inner)
        filter(row -> row[level] in unique(mask), _)
    end

    for value in mask
        value_reference_dfrow = rand(eachrow(filter(r -> r[level] == value, df)))
        value_locale = value_reference_dfrow[:locale] |> String
        address_format = rand(locale_address_formats[value_locale]) |> String
        push!(addresses, materialize_template(address_format, value_reference_dfrow; locale = value_locale))
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
        push!(postcodes, materialize_numeric_template(format))
    end
    return postcodes |> coerse_string_type
end
