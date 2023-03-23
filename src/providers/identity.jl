"""

"""
function identity(n::Int, formats::Union{Vector{Symbol}, Nothing}, sink = Dict;
    sex::Vector{T} = SEXES[:options],
    fields::Union{NTuple, Vector{T}} = KNOWLEDGE_FIELDS[:options],
    locale::Vector{T} = getlocale()
) where {T <: AbstractString}

    sex_mask = rand(sex, n)
    knowledge_field_mask = rand(fields, n)

    generated_names = Dict() 

    for f in formats
        if f == :prefix
            generated_names[f] = prefix(sex_mask, n; locale)
        end
        if f == :firstname
            generated_names[f] = firstname(sex_mask, n; locale)
        end
        if f == :surname
            generated_names[f] = surname(n)
        end
        if f == :sex
            generated_names[f] = sex_mask
        end
        if f == :birthdate
            generated_names[f] = birthdate(n)
        end
        if f == :occupation
            generated_names[f] = occupation(knowledge_field_mask, n; locale)
        end
        if f == :bloodtype
            generated_names[f] = bloodtype(n)
        end
        if f == :highschool
            generated_names[f] = highschool(n; locale)
        end
        if f == :university
            generated_names[f] = university(knowledge_field_mask, n; locale)
        end
        if f == :knowledge_field
            generated_names[f] = knowledge_field_mask
        end
    end

    return generated_names |> sink
end


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

"""
function bloodtype(n::Int = 1) :: Union{String, Vector{String}}
    return [rand(["A", "B", "AB", "O"]) * rand(["+", "-"]) for _ in 1:n] |> return_unpacker
end



"""

"""
function birthdate(n::Int; start::Date = Date(1900, 1, 1), stop::Date = today()) :: Union{Date, Vector{Date}}
    return random_date(n, start = start, stop = stop) |> return_unpacker
end



"""

Generate 

# Parameters
- `n::Int = 1`: number of firstnames to be generated
- `locale::Vector{String}`: locale(s) from which the first names are sampled.
"""
function firstname(n::Int = 1; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("firstname", "identity", locale; options = SEXES[:options]), n) |> return_unpacker
end

"""

Generate `n` first names from a given `locale`, optionally provide a `sex` specifying the genres of
the first names to be generated. If no `locale` is provided, the locale from the session is used.

# Parameters
- `n::Int = 1`: number of firstnames to be generated
- `sex::String`: string specifying the sex of the first names with the following options:
    - `"female"`
    - `"male"`
- `locale::Vector{String}`: locale(s) from which the first names are sampled.

# Example
"""
function firstname(sexes::Vector{String}, n::Int = 1; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("firstname", "identity", locale; options = sexes), n) |> return_unpacker
end

"""
    firstname(sex_mask::Vector{String}, n::Int = 1; locale = getlocale())

Generate a vector of first names, but instead of randomly sampling names from both sexes, use a
predefined `sex_mask` to generate names according to their sexes in the order specified in
`sex_mask`.

# Parameters
- `n::Int = 1`: number of firstnames to be generated
- `sex_mask::Vector{String}`: sex mask specified by a string with the following options:
    - `"female"`
    - `"male"`
"""
function firstname(sex_mask::Vector{String}; locale = getlocale()) :: Union{String, Vector{String}}
    return load!(sex_mask, "firstname", "identity", locale) |> return_unpacker
end



"""

"""
function prefix(n::Int = 1; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("prefix", "identity", locale; options = SEXES[:options]), n) |> return_unpacker
end

function prefix(sexes::Vector{String}, n::Int = 1; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("prefix", "identity", locale; options = sexes), n) |> return_unpacker
end

function prefix(sex_mask::Vector{String}; locale = getlocale()) :: Union{String, Vector{String}}
    return load!(sex_mask, "prefix", "identity", locale) |> return_unpacker
end



"""
    surname(n::Int = 1; locale = getlocale())

Generate a random `surname` using the provided `locale` as source. If no `locale` is provided,
the locale from the session will be used.

# Parameters

- `n::Int = 1`: number of surnames to be generated
- `locale::Vector{String}`: locale(s) to be used when generating the surnames
"""
function surname(n::Int = 1; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("surname", "identity", locale), n) |> return_unpacker
end



"""

"""
function occupation(n::Int = 1; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("occupation", "identity", locale; options = KNOWLEDGE_FIELDS[:options]), n) |> return_unpacker
end

function occupation(fields::Vector{String}, n::Int = 1; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("occupation", "identity", locale; options = fields), n) |> return_unpacker
end

function occupation(field_mask::Vector{String}; locale = getlocale()) :: Union{String, Vector{String}}
    return load!(field_mask, "occupation", "identity", locale) |> return_unpacker
end



"""

"""
function university(n::Int = 1; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("university", "identity", locale; options = KNOWLEDGE_FIELDS[:options]), n) |> return_unpacker
end

function university(fields::Vector{String}, n::Int = 1; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("university", "identity", locale; options = fields), n) |> return_unpacker
end

function university(field_mask::Vector{String}; locale = getlocale()) :: Union{String, Vector{String}}
    return load!(field_mask, "university", "identity", locale) |> return_unpacker
end
