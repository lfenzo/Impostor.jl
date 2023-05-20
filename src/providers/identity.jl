"""
    highschool(n::Integer = 1; locale = getlocale())

Generate `n` high-school names from a given `locale`. If no `locale` is provided, the locale
from the session is used.

# Parameters
- `n::Int = 1`: number high-school names to be generated
- `locale::Vector{String}`: locale(s) from which the high-school names are sampled.
"""
function highschool(n::Integer = 1; locale = getlocale())
    df = load!("identity", "highschool", locale)
    return rand(df[:, :highschool], n) |> coerse_string_type
end


"""
    bloodtype(n::Integer = 1)

Generate `n` blood type entries *e.g.* `"AB-"`, `"O+"` and `"A+"`.

# Parameters
- `n::Int = 1`: number blood type entries to be generated
"""
function bloodtype(n::Integer = 1)
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
function birthdate(n::Integer = 1; start::Date = Date(1900, 1, 1), stop::Date = today())
    return Dates.format.(rand(start:Day(1):stop, n), "yyyy-mm-dd") |> coerse_string_type
end


"""
    prefix(n::Integer = 1; locale = getlocale())

Generate `n` name prefixes, *e.g.* `"Mr."` and `"Ms."`, from a given locale. If no `locale` is
provided, the locale from the session is used.

# Parameters
- `n::Int = 1`: number of prefixes to be generated.
- `locale::Vector{String}`: locale(s) from which the prefixes are sampled.
"""
function prefix(n::Integer = 1; locale = getlocale())
    df = load!("identity", "prefix", locale)
    return rand(df[:, :prefix], n) |> coerse_string_type
end

"""
    prefix(sex::Vector{String}, n::Integer; locale = getlocale())

Generate `n` name prefixes, *e.g.* `"Mr."` and `"Ms."`, from a given locale restricting the `sex` of
the generated prefixes. For example, if `sex = ["female"]`, only female prefixes are generated.
If no `locale` is provided, the locale from the session is used.

# Parameters
- `sex::Vector{String}`: sexes to be used when generating the prefixes. Available options:
    - `"male"`
    - `"female"`
- `n::Int = 1`: number of prefixes to be generated.
- `locale::Vector{String}`: locale(s) from which the prefixes are sampled.
"""
function prefix(sex::Vector{<:AbstractString}, n::Integer; locale = getlocale())
    df = load!("identity", "prefix", locale)
    filter!(r -> r[:sex] in sex, df)
    return rand(df[:, :prefix], n) |> coerse_string_type
end

"""
    prefix(sex_mask::Vector{<:AbstractString}; locale = getlocale())

Generate name prefixes, *e.g.* `"Mr."` and `"Ms."`, from a `sex_mask`. For example, if
`sex_mask = ["female", "female", "male", "female"]` four name prefixes will be generated
corresponding to the sexes female, female, male and female, respectively.
If no `locale` is provided, the locale from the session is used.

# Parameters
- `sex_mask::Vector{String}`: sexes to be used when generating the prefixes. Available options:
    - `"male"`
    - `"female"`
- `locale::Vector{String}`: locale(s) from which the prefixes are sampled.

# Example
```julia
julia> prefix(["female", "male", "female"])
3-element Vector{String}:
"Ms."
"Mr."
"Ms."
```
"""
function prefix(mask::Vector{<:AbstractString}; locale = getlocale())
    
    multi_locale_prefixes = load!("identity", "prefix", locale)
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
    firstname(n::Integer = 1; locale = getlocale())

Generate `n` first names from a given locale.
If no `locale` is provided, the locale from the session is used.

# Parameters
- `n::Int = 1`: number of first names to be generated.
- `locale::Vector{String}`: locale(s) from which the first names are sampled.
"""
function firstname(n::Integer = 1; locale = getlocale())
    df = load!("identity", "firstname", locale)
    return rand(df[:, :firstname], n) |> coerse_string_type
end


"""
    firstname(sex::Vector{<:AbstractString}, n::Integer; locale = getlocale())

Generate `n` first names from a given locale restricting the `sex` of the generated names.
For example, if `sex = ["female"]`, only female first names are generated.
If no `locale` is provided, the locale from the session is used.

# Parameters
- `sex::Vector{String}`: sexes to be used when generating the first names. Available options:
    - `"male"`
    - `"female"`
- `n::Int = 1`: number of first names to be generated.
- `locale::Vector{String}`: locale(s) from which the first names are sampled.

# Example
```julia
julia> firstname(["female"], 4)
4-element Vector{String}:
"Sophie"
"Abgail"
"Sophie"
"Mary"
```
```julia
julia> firstname(["male", "female"], 5)
4-element Vector{String}:
"Carl"
"James"
"Mary"
"Melissa"
"Paul"
```
"""
function firstname(sex::Vector{<:AbstractString}, n::Integer; locale = getlocale())
    df = load!("identity", "firstname", locale)
    filter!(r -> r[:sex] in sex, df)
    return rand(df[:, :firstname], n) |> coerse_string_type
end

"""
    firstname(sex_mask::Vector{<:AbstractString}; locale = getlocale())

Generate first names from a `sex_mask`. For example, if `sex_mask = ["female", "female",
"male", "female"]` four first names will be generated corresponding to the sexes
female, female, male and female, respectively.
If no `locale` is provided, the locale from the session is used.

# Parameters
- `sex_mask::Vector{String}`: sexes to be used when generating the first names. Available options:
    - `"male"`
    - `"female"`
- `locale::Vector{String}`: locale(s) from which the first names are sampled.

# Example
Note that the length of the generated `Vector` is equal to the length of the mask.
```julia
julia> firstname(["female", "male", "female", "female", "male"])
5-element Vector{String}:
"Sophie"
"Carl"
"Milly"
"Amanda"
"John"
```
"""
function firstname(mask::Vector{<:AbstractString}; locale = getlocale())

    df = load!("identity", "firstname", locale)
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
    surname(n::Integer = 1; locale = getlocale())

Generate a `surname` using the provided `locale` as source. If no `locale` is provided,
the locale from the session will be used.

# Parameters

- `n::Int = 1`: number of surnames to be generated
- `locale::Vector{String}`: locale(s) to be used when generating the surnames
"""
function surname(n::Integer = 1; locale = getlocale())
    df = load!("identity", "surname", locale)
    return rand(df[:, :surname], n) |> coerse_string_type
end



"""
    complete_name(n::Integer = 1; locale = getlocale())

Generate `n` full names from a given locale.
If no `locale` is provided, the locale from the session is used.

# Parameters
- `n::Int = 1`: number of full names to be generated.
- `locale::Vector{String}`: locale(s) from which the first names are sampled.
"""
function complete_name(n::Integer = 1; locale = getlocale())
    complete_names = Vector{String}()
    for _ in 1:n
        fname = Impostor.firstname(; locale = locale)
        surnames = sample(load!("identity", "surname", locale)[:, :surname], rand(1:3); replace = false)
        push!(complete_names, fname * " " * join(surnames, " "))
    end
    return complete_names |> coerse_string_type
end

"""
    complete_name(sex::Vector{<:AbstractString}, n::Integer; locale = getlocale())

Generate `n` first names from a given locale restricting the `sex` of the generated names.
For example, if `sex = ["female"]`, only female first names are generated.
If no `locale` is provided, the locale from the session is used.

# Parameters
- `sex::Vector{String}`: sexes to be used when generating the full names. Available options:
    - `"male"`
    - `"female"`
- `n::Int = 1`: number of full names to be generated.
- `locale::Vector{String}`: locale(s) from which the full names are sampled.

# Example
```julia
julia> Impostor.complete_name(["male"], 5)
5-element Vector{String}:
"Paul Cornell Fraser Collins"
"Paul Jameson"
"Carl Fraser Sheffard Collins"
"Daniel Cornell"
"Alfred Collins"
```
```julia
julia> Impostor.complete_name(["female"], 5)
5-element Vector{String}:
"Melissa Sheffard"
"Kate Collins"
"Melissa Cornell Fraser"
"Abgail Cornell"
"Abgail Fraser Jameson"
```
"""
function complete_name(sex::Vector{<:AbstractString}, n::Integer; locale = getlocale())
    complete_names = Vector{String}()
    for _ in 1:n
        fname = Impostor.firstname(sex, 1; locale = locale)
        surnames = sample(load!("identity", "surname", locale)[:, :surname], rand(1:3); replace = false)
        push!(complete_names, fname * " " * join(surnames, " "))
    end
    return complete_names |> coerse_string_type
end

"""
    complete_name(sex_mask::Vector{<:AbstractString}; locale = getlocale())

Generate full names (complete names) from a `sex_mask`. For example, if `sex_mask = ["female",
"female", "male", "female"]` four complete names will be generated corresponding to the sexes
female, female, male and female, respectively.
If no `locale` is provided, the locale from the session is used.

# Parameters
- `sex_mask::Vector{String}`: sexes to be used when generating the complete names. Available options:
    - `"male"`
    - `"female"`
- `locale::Vector{String}`: locale(s) from which the full names are sampled.

# Example
Note that the length of the generated `Vector` is equal to the length of the mask.
```julia
julia> complete_name(["female", "male", "female", "female", "male"])
5-element Vector{String}:
"Melissa Sheffard Jameson Cornell"
"Alfred Collins"
"Mary Sheffard Fraser"
"Milly Jameson Fraser"
"Alfred Fraser Collins"
```
"""
function complete_name(mask::Vector{<:AbstractString}; locale = getlocale())
    complete_names = Vector{String}()
    for value in mask
        fname = Impostor.firstname([value]; locale = locale)
        surnames = sample(load!("identity", "surname", locale)[:, :surname], rand(1:3); replace = false)
        push!(complete_names, fname * " " * join(surnames, " "))
    end
    return complete_names |> coerse_string_type
end


"""
    occupation(n::Integer = 1; locale = getlocale())

Generate `n` occupation entries from a given locale.
If no `locale` is provided, the locale from the session is used.

# Parameters
- `n::Int = 1`: number of occupations to be generated.
- `locale::Vector{String}`: locale(s) from which the occupations are sampled.
"""
function occupation(n::Integer = 1; locale = getlocale())
    df = load!("identity", "occupation", locale)
    return rand(df[:, :occupation], n) |> coerse_string_type
end


"""
    occupation(field::Vector{<:AbstractString}, n::Integer; locale = getlocale())

Generate `n` occupation entries from a given locale restricting the `field` of thegenerated
generated occupations. For example, if `fields = ["business", "humanities"]`, only occupations
belonging the "business" and "humanities" categories from `locale` are generated.
If no `locale` is provided, the locale from the session is used.

# Parameters
- `field::Vector{String}`: fields to be used when generating the occupations. Available options:
    - `"business"`
    - `"humanities"`
    - `"social-sciences"`
    - `"natural-sciences"`
    - `"formal-sciences"`
    - `"public-administration"`
    - `"military"`
- `n::Int = 1`: number of occupations to be generated.
- `locale::Vector{String}`: locale(s) from which the occupations are sampled.
"""
function occupation(options::Vector{<:AbstractString}, n::Integer; locale = getlocale())
    df = load!("identity", "occupation", locale)
    filter!(r -> r[:knowledge_field] in options, df)
    return rand(df[:, :occupation], n) |> coerse_string_type
end

"""
    occupation(field_mask::Vector{<:AbstractString}; locale = getlocale())

Generate occupations from a `field_mask`. For example, if `fields_mask = ["business", "humanities",
"humanities", "business"]` four occupations will be generated corresponding to the fields
business, humanities, humanities and business, respectively.
If no `locale` is provided, the locale from the session is used.

# Parameters
- `field_mask::Vector{String}`: fields to be used when generating the occupations. Available options:
    - `"business"`
    - `"humanities"`
    - `"social-sciences"`
    - `"natural-sciences"`
    - `"formal-sciences"`
    - `"public-administration"`
    - `"military"`
- `locale::Vector{String}`: locale(s) from which the occupations are sampled.
"""
function occupation(mask::Vector{<:AbstractString}; locale = getlocale())
    df = load!("identity", "occupation", locale)
    @assert [m in df[:, :knowledge_field] for m in mask] |> all

    gb = groupby(df, [:knowledge_field])

    selected_values = Vector{String}()

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :occupation]))
    end
    return selected_values |> coerse_string_type
end



"""
    university(n::Integer = 1; locale = getlocale())

Generate `n` university entries from a given locale.
If no `locale` is provided, the locale from the session is used.

# Parameters
- `n::Int = 1`: number of universities to be sampled.
- `locale::Vector{String}`: locale(s) from which the universities are sampled.
"""
function university(n::Integer = 1; locale = getlocale())
    df = load!("identity", "university", locale)
    return rand(df[:, :university], n) |> coerse_string_type
end

"""
    university(field::Vector{<:AbstractString}, n::Integer; locale = getlocale())

Generate `n` universites entries from a given locale restricting the `field` of the generated
generated universities. For example, if `fields = ["business", "humanities"]`, only universities
belonging the "business" and "humanities" categories from `locale` are sampled.
If no `locale` is provided, the locale from the session is used.

# Parameters
- `field::Vector{String}`: fields to be used when generating the occupations. Available options:
    - `"business"`
    - `"humanities"`
    - `"social-sciences"`
    - `"natural-sciences"`
    - `"formal-sciences"`
    - `"public-administration"`
    - `"military"`
- `n::Int = 1`: number of universities to be generated.
- `locale::Vector{String}`: locale(s) from which the universities are sampled.
"""
function university(options::Vector{<:AbstractString}, n::Integer; locale = getlocale())
    df = load!("identity", "university", locale)
    filter!(r -> r[:knowledge_field] in options, df)
    return rand(df[:, :university], n) |> coerse_string_type
end

"""
    university(field_mask::Vector{<:AbstractString}; locale = getlocale())

Generate universities from a `field_mask`. For example, if `fields_mask = ["business", "humanities",
"humanities", "business"]` four university entries  will be smpled corresponding to the fields
business, humanities, humanities and business, respectively.
If no `locale` is provided, the locale from the session is used.

# Parameters
- `field_mask::Vector{String}`: fields to be used when generating the universities. Available options:
    - `"business"`
    - `"humanities"`
    - `"social-sciences"`
    - `"natural-sciences"`
    - `"formal-sciences"`
    - `"public-administration"`
    - `"military"`
- `locale::Vector{String}`: locale(s) from which the universities are sampled.
"""
function university(mask::Vector{<:AbstractString}; locale = getlocale())
    df = load!("identity", "university", locale)
    @assert [m in df[:, :knowledge_field] for m in mask] |> all

    gb = groupby(df, [:knowledge_field])

    selected_values = Vector{String}()

    for value in mask
        associated_mask_rows = get(gb, (value,), nothing)
        push!(selected_values, rand(associated_mask_rows[:, :university]))
    end
    return selected_values |> coerse_string_type
end
