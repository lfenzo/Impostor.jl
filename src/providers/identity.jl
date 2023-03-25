"""
    highschool(n::Int = 1; locale = getlocale())

Generate `n` high-school names from a given `locale`. If no `locale` is provided, the locale
from the session is used.

# Parameters
- `n::Int = 1`: number high-school names to be generated
- `locale::Vector{String}`: locale(s) from which the high-school names are sampled.
"""
function highschool(n::Int = 1; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("highschool", "identity", locale), n) |> return_unpacker
end


"""
    bloodtype(n::Int = 1)

Generate `n` blood type entries *e.g.* `"AB-"`, `"O+"` and `"A+"`.

# Parameters
- `n::Int = 1`: number blood type entries to be generated
"""
function bloodtype(n::Int = 1) :: Union{String, Vector{String}}
    return [rand(["A", "B", "AB", "O"]) * rand(["+", "-"]) for _ in 1:n] |> return_unpacker
end



"""
    birthdate(n::Int = 1; start::Date, stop::Date)

Generate `n` birth date entries between the `start` and `stop` dates.

# Parameters
- `n::Int = 1`: number of dates to generate.
- `start::Date = Date(1900, 1, 1)`: start of the sampling period.
- `stop::Date = Dates.today()`: end of the sampling period.
"""
function birthdate(n::Int = 1; start::Date = Date(1900, 1, 1), stop::Date = today()) :: Union{Date, Vector{Date}}
    return random_date(n, start = start, stop = stop) |> return_unpacker
end


"""
    prefix(n::Int = 1; locale = getlocale())

Generate `n` name prefixes, *e.g.* `"Mr."` and `"Ms."`, from a given locale. If no `locale` is
provided, the locale from the session is used.

# Parameters
- `n::Int = 1`: number of prefixes to be generated.
- `locale::Vector{String}`: locale(s) from which the prefixes are sampled.
"""
function prefix(n::Int = 1; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("prefix", "identity", locale; options = SEXES[:options]), n) |> return_unpacker
end

"""
    prefix(sex::Vector{String}, n::Int; locale = getlocale())

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
function prefix(sex::Vector{String}, n::Int; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("prefix", "identity", locale; options = sex), n) |> return_unpacker
end

"""
    prefix(sex_mask::Vector{String}; locale = getlocale())

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
function prefix(sex_mask::Vector{String}; locale = getlocale()) :: Union{String, Vector{String}}
    return load!(sex_mask, "prefix", "identity", locale) |> return_unpacker
end


"""
    firstname(n::Int = 1; locale = getlocale())

Generate `n` first names from a given locale.
If no `locale` is provided, the locale from the session is used.

# Parameters
- `n::Int = 1`: number of first names to be generated.
- `locale::Vector{String}`: locale(s) from which the first names are sampled.
"""
function firstname(n::Int = 1; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("firstname", "identity", locale; options = SEXES[:options]), n) |> return_unpacker
end

"""
    firstname(sex::Vector{String}, n::Int; locale = getlocale())

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
function firstname(sex::Vector{String}, n::Int; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("firstname", "identity", locale; options = sex), n) |> return_unpacker
end

"""
    firstname(sex_mask::Vector{String}; locale = getlocale())

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
function firstname(sex_mask::Vector{String}; locale = getlocale()) :: Union{String, Vector{String}}
    return load!(sex_mask, "firstname", "identity", locale) |> return_unpacker
end


"""
    surname(n::Int = 1; locale = getlocale())

Generate a `surname` using the provided `locale` as source. If no `locale` is provided,
the locale from the session will be used.

# Parameters

- `n::Int = 1`: number of surnames to be generated
- `locale::Vector{String}`: locale(s) to be used when generating the surnames
"""
function surname(n::Int = 1; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("surname", "identity", locale), n) |> return_unpacker
end



"""
    fullname(n::Int = 1; locale = getlocale())

Generate `n` full names from a given locale.
If no `locale` is provided, the locale from the session is used.

# Parameters
- `n::Int = 1`: number of full names to be generated.
- `locale::Vector{String}`: locale(s) from which the first names are sampled.
"""
function fullname(n::Int = 1; locale = getlocale()) :: Union{String, Vector{String}}
    fullnames = Vector{String}()
    for _ in 1:n
        fname = Impostor.firstname(; locale = locale)
        surnames = sample(load!("surname", "identity", locale), rand(1:3); replace = False)
        push!(fullnames, fname * " " * join(surnames, " "))
    end
    return fullnames |> return_unpacker
end

"""
    fullname(sex::Vector{String}, n::Int; locale = getlocale())

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
julia> Impostor.fullname(["male"], 5)
5-element Vector{String}:
"Paul Cornell Fraser Collins"
"Paul Jameson"
"Carl Fraser Sheffard Collins"
"Daniel Cornell"
"Alfred Collins"
```
```julia
julia> Impostor.fullname(["female"], 5)
5-element Vector{String}:
"Melissa Sheffard"
"Kate Collins"
"Melissa Cornell Fraser"
"Abgail Cornell"
"Abgail Fraser Jameson"
```
"""
function fullname(sex::Vector{String}, n::Int; locale = getlocale()) :: Union{String, Vector{String}}
    fullnames = Vector{String}()
    for _ in 1:n
        fname = Impostor.firstname(sex, 1; locale = locale)
        surnames = sample(load!("surname", "identity", locale), rand(1:3); replace = false)
        push!(fullnames, fname * " " * join(surnames, " "))
    end
    return fullnames |> return_unpacker
end

"""
    fullname(sex_mask::Vector{String}; locale = getlocale())

Generate full names from a `sex_mask`. For example, if `sex_mask = ["female", "female",
"male", "female"]` four full names will be generated corresponding to the sexes
female, female, male and female, respectively.
If no `locale` is provided, the locale from the session is used.

# Parameters
- `sex_mask::Vector{String}`: sexes to be used when generating the full names. Available options:
    - `"male"`
    - `"female"`
- `locale::Vector{String}`: locale(s) from which the full names are sampled.

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
function fullname(sex_mask::Vector{String}; locale = getlocale()) :: Union{String, Vector{String}}
    fullnames = Vector{String}()
    for sex in sex_mask
        fname = Impostor.firstname([sex]; locale = locale)
        surnames = sample(load!("surname", "identity", locale), rand(1:3); replace = false)
        push!(fullnames, fname * " " * join(surnames, " "))
    end
    return fullnames |> return_unpacker
end




"""

"""
function occupation(n::Int = 1; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("occupation", "identity", locale; options = KNOWLEDGE_FIELDS[:options]), n) |> return_unpacker
end

function occupation(field::Vector{String}, n::Int; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("occupation", "identity", locale; options = field), n) |> return_unpacker
end

function occupation(field_mask::Vector{String}; locale = getlocale()) :: Union{String, Vector{String}}
    return load!(field_mask, "occupation", "identity", locale) |> return_unpacker
end



"""

"""
function university(n::Int = 1; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("university", "identity", locale; options = KNOWLEDGE_FIELDS[:options]), n) |> return_unpacker
end

function university(field::Vector{String}, n::Int; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("university", "identity", locale; options = field), n) |> return_unpacker
end

function university(field_mask::Vector{String}; locale = getlocale()) :: Union{String, Vector{String}}
    return load!(field_mask, "university", "identity", locale) |> return_unpacker
end
