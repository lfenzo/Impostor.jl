"""
    highschool(n::Integer = 1; kwargs...)

# Parameters
- `n::Integer = 1`: number of highschool names to generate.

# Kwargs
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function highschool(n::Integer = 1; locale = session_locale())
    df = _load!("identity", "highschool", locale)
    return rand(df[:, :highschool], n) |> coerse_string_type
end



"""
    bloodtype(n::Integer = 1)

Generate `n` blood type entries *e.g.* `"AB-"`, `"O+"` and `"A+"`.

# Parameters
- `n::Integer = 1`: number blood type entries to be generated
"""
function bloodtype(n::Integer = 1; kwargs...)
    return [rand(["A", "B", "AB", "O"]) * rand(["+", "-"]) for _ in 1:n] |> coerse_string_type
end



"""
    birthdate(n::Integer = 1; start::Date, stop::Date)

Generate `n` birth date entries between the `start` and `stop` dates.

# Parameters
- `n::Int = 1`: number of dates to generate.
- `start::Date = Date(1900, 1, 1)`: start of the sampling period.
- `stop::Date = Dates.today()`: end of the sampling period.
"""
function birthdate(n::Integer = 1; start::Date = Date(1900, 1, 1), stop::Date = today(), kwargs...)
    return Dates.format.(rand(start:Day(1):stop, n), "yyyy-mm-dd") |> coerse_string_type
end



"""
    prefix(n::Integer = 1; kws...)
    prefix(options::Vector{String}, n::Integer; kws...)
    prefix(mask::Vector{<:AbstractString}; kws...)

Generate `n` name prefixes, *e.g.* `"Mr."` and `"Ms."`, from a given locale.

# Parameters
- `n::Integer = 1`: number of prefixes to generate.
- `options::Vector{<:AbstractString}`: vector with options restricting the possible values generated.
- `mask::Vector{<:AbstractString}`: mask vector with element-wise option restrictions.

# Options
The valid options values for `options` and `mask` are:
- `"M"` for "male"
- `"F"` for "female"

# Kwargs
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.

# Example
```@juliarepl
julia> prefix(["F", "M", "F"])
3-element Vector{String}:
"Ms."
"Mr."
"Ms."
```
"""
function prefix(n::Integer = 1; locale = session_locale())
    df = _load!("identity", "prefix", locale)
    return rand(df[:, :prefix], n) |> coerse_string_type
end

function prefix(sexes::Vector{<:AbstractString}, n::Integer; locale = session_locale())
    df = _load!("identity", "prefix", locale)
    filter!(r -> r[:sex] in sexes, df)
    return rand(df[:, :prefix], n) |> coerse_string_type
end

function prefix(mask::Vector{<:AbstractString}; locale = session_locale())
    multi_locale_prefixes = _load!("identity", "prefix", locale)
    @assert [m in multi_locale_prefixes[:, :sex] for m in mask] |> all

    gb = groupby(multi_locale_prefixes, [:sex])
    selected_values = Vector{String}()

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :prefix]))
    end
    return selected_values |> coerse_string_type
end



"""
    firstname(n::Integer = 1; kws...)
    firstname(sexes::Vector{<:AbstractString}, n::Integer; kws...)
    firstname(sexes::Vector{<:AbstractString}; kws...))

Generate `n` or `length(mask)` first names.

# Parameters
- `n::Integer = 1`: number of first names to generate.
- `options::Vector{<:AbstractString}`: vector with options restricting the possible values generated.
- `mask::Vector{<:AbstractString}`: mask vector with element-wise option restrictions.

# Options
The valid options values for `options` and `mask` are:
- `"M"` for "male"
- `"F"` for "female"

# Kwargs
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.

# Examples
```@juliarepl
julia> firstname(["F"], 4)
4-element Vector{String}:
"Sophie"
"Abgail"
"Sophie"
"Mary"

julia> firstname(["F", "M", "F", "F", "M"])
5-element Vector{String}:
"Sophie"
"Carl"
"Milly"
"Amanda"
"John"
```
"""
function firstname(n::Integer = 1; locale = session_locale())
    df = _load!("identity", "firstname", locale)
    return rand(df[:, :firstname], n) |> coerse_string_type
end

function firstname(sexes::Vector{<:AbstractString}, n::Integer; locale = session_locale())
    df = _load!("identity", "firstname", locale)
    filter!(r -> r[:sex] in sexes, df)
    return rand(df[:, :firstname], n) |> coerse_string_type
end

function firstname(mask::Vector{<:AbstractString}; locale = session_locale())
    df = _load!("identity", "firstname", locale)
    @assert [m in df[:, :sex] for m in mask] |> all

    gb = groupby(df, [:sex])
    selected_values = Vector{String}()

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :firstname]))
    end
    return selected_values |> coerse_string_type
end



"""
    surname(n::Integer = 1; kws...)

Generate a `surname` using the provided `locale` as source.

# Parameters
- `n::Integer = 1`: number of surnames to generate.

# Kwargs
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function surname(n::Integer = 1; locale = session_locale())
    df = _load!("identity", "surname", locale)
    return rand(df[:, :surname], n) |> coerse_string_type
end



"""
    complete_name(n::Integer = 1; kws...)
    complete_name(options::Vector{<:AbstractString}, n::Integer; kws...)
    complete_name(mask::Vector{<:AbstractString}; kws...)

Generate `n` or `length(mask)` full (complete) names from a given locale.

# Parameters
- `n::Integer = 1`: number of complete names to generate.

# Options
The valid options values for `options` and `mask` are:
- `"M"` for "male"
- `"F"` for "female"

# Kwargs
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
- `max_surnames::Integer = 3`: maximum number of surnames in each of the generated entries, note that the actual number may be smaller than `max_surnames`.

# Examples
```@juliarepl
julia> Impostor.complete_name(["F"], 5)
5-element Vector{String}:
"Melissa Sheffard"
"Kate Collins"
"Melissa Cornell Fraser"
"Abgail Cornell"
"Abgail Fraser Jameson"

julia> complete_name(["F", "M", "F", "F", "M"])
5-element Vector{String}:
"Melissa Sheffard Jameson Cornell"
"Alfred Collins"
"Mary Sheffard Fraser"
"Milly Jameson Fraser"
"Alfred Fraser Collins"
```
"""
function complete_name(n::Integer = 1; locale = session_locale(), max_surnames::Integer = 3)
    complete_names = Vector{String}()
    for _ in 1:n
        fname = Impostor.firstname(; locale = locale)
        surnames = sample(
            _load!("identity", "surname", locale)[:, :surname], rand(1:max_surnames);
            replace = false
        )
        push!(complete_names, fname * " " * join(surnames, " "))
    end
    return complete_names |> coerse_string_type
end

function complete_name(sexes::Vector{<:AbstractString}, n::Integer;
    locale = session_locale(),
    max_surnames::Integer = 3,
)
    complete_names = Vector{String}()
    for _ in 1:n
        fname = Impostor.firstname(sexes, 1; locale = locale)
        surnames = sample(
            _load!("identity", "surname", locale)[:, :surname], rand(1:max_surnames);
            replace = false
        )
        push!(complete_names, fname * " " * join(surnames, " "))
    end
    return complete_names |> coerse_string_type
end

function complete_name(mask::Vector{<:AbstractString};
    locale = session_locale(),
    max_surnames::Integer = 3,
)
    complete_names = Vector{String}()
    for value in mask
        fname = Impostor.firstname([value]; locale = locale)
        surnames = sample(
            _load!("identity", "surname", locale)[:, :surname], rand(1:max_surnames);
            replace = false
        )
        push!(complete_names, fname * " " * join(surnames, " "))
    end
    return complete_names |> coerse_string_type
end



"""
    occupation(n::Integer = 1; kws...)
    occupation(options::Vector{<:AbstractString}, n::Integer; kws...)
    occupation(mask::Vector{<:AbstractString}; kws...)

Generate `n` or `length(mask)` occupation entries.

# Parameters
- `n::Integer = 1`: number of prefixes to generate.
- `options::Vector{<:AbstractString}`: vector with options restricting the possible values generated.
- `mask::Vector{<:AbstractString}`: mask vector with element-wise option restrictions.

# Options
The valid options values for the elements in `options` and `mask` are:
- `"business"`
- `"humanities"`
- `"social-sciences"`
- `"natural-sciences"`
- `"formal-sciences"`
- `"public-administration"`
- `"military"`

# Kwargs
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function occupation(n::Integer = 1; locale = session_locale())
    df = _load!("identity", "occupation", locale)
    return rand(df[:, :occupation], n) |> coerse_string_type
end

function occupation(fields::Vector{<:AbstractString}, n::Integer; locale = session_locale())
    df = _load!("identity", "occupation", locale)
    filter!(r -> r[:knowledge_field] in fields, df)
    return rand(df[:, :occupation], n) |> coerse_string_type
end

function occupation(fields::Vector{<:AbstractString}; locale = session_locale())
    df = _load!("identity", "occupation", locale)
    @assert [m in df[:, :knowledge_field] for m in fields] |> all

    gb = groupby(df, [:knowledge_field])
    selected_values = Vector{String}()

    for mask_value in fields
        associated_mask_rows = get(gb, (mask_value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :occupation]))
    end
    return selected_values |> coerse_string_type
end



"""
    university(n::Integer = 1; kws...)
    university(fields::Vector{<:AbstractString}, n::Integer; kws...)
    university(field_mask::Vector{<:AbstractString}; kws...)

# Parameters
- `n::Integer = 1`: number of university entries to generate.
- `options::Vector{<:AbstractString}`: vector with options restricting the possible values generated.
- `mask::Vector{<:AbstractString}`: mask vector with element-wise option restrictions.

# Options
The valid options values for elements in `options` and `mask` are:
- `"business"`
- `"humanities"`
- `"social-sciences"`
- `"natural-sciences"`
- `"formal-sciences"`
- `"public-administration"`
- `"military"`

# Kwargs
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function university(n::Integer = 1; locale = session_locale())
    df = _load!("identity", "university", locale)
    return rand(df[:, :university], n) |> coerse_string_type
end

function university(options::Vector{<:AbstractString}, n::Integer; locale = session_locale())
    df = _load!("identity", "university", locale)
    filter!(r -> r[:knowledge_field] in options, df)
    return rand(df[:, :university], n) |> coerse_string_type
end

function university(mask::Vector{<:AbstractString}; locale = session_locale())
    df = _load!("identity", "university", locale)
    @assert [f in df[:, :knowledge_field] for f in mask] |> all

    gb = groupby(df, [:knowledge_field])
    selected_values = Vector{String}()

    for mask_value in mask
        associated_mask_rows = get(gb, (mask_value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :university]))
    end
    return selected_values |> coerse_string_type
end



"""
    nationality(n::Integer = 1; kws...)
    nationality(options::Vector{<:AbstractString}, n::Integer; level::Symbol, kws...)
    nationality(mask::Vector{<:AbstractString}; level::Symbol, kws...)

# Parameters
- `n::Integer = 1`: number of nationality entries to generate.
- `options::Vector{<:AbstractString}`: vector with options restricting the possible values generated.
- `mask::Vector{<:AbstractString}`: mask vector with element-wise option restrictions.

# Kwargs
- `level::Symbol = :district_name`: Level of values in `options` or `mask` when using option-based or mask-based eneration. Valid `level` values are:
    - `:sex`
    - `:country_code`
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function nationality(n::Integer = 1; locale = session_locale())
    nationalities = _load!("identity", "nationality", locale) 
    return rand(nationalities[:, :nationality], n) |> coerse_string_type
end

function nationality(options::Vector{<:AbstractString}, n::Integer;
    level::Symbol = :country_code,
    locale = session_locale()
)
    @assert(
        level in (:sex, :country_code),
        "invalid 'level' provided: \"$level\""
    )

    df = _load!("identity", "nationality", locale)
    filter!(r -> r[level] in options, df)

    return rand(df[:, :nationality], n) |> coerse_string_type
end

function nationality(mask::Vector{<:AbstractString};
    level::Symbol = :country_code,
    locale = session_locale()
)
    @assert(
        level in (:sex, :country_code),
        "invalid 'level' provided: \"$level\""
    )

    df = _load!("identity", "nationality", locale)
    gb = groupby(df, [level])

    selected_values = Vector{String}()

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :nationality]))
    end
    return selected_values |> coerse_string_type
end

