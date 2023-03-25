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

"""
function prefix(n::Int = 1; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("prefix", "identity", locale; options = SEXES[:options]), n) |> return_unpacker
end

function prefix(sex::Vector{String}, n::Int; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("prefix", "identity", locale; options = sex), n) |> return_unpacker
end

function prefix(sex_mask::Vector{String}; locale = getlocale()) :: Union{String, Vector{String}}
    return load!(sex_mask, "prefix", "identity", locale) |> return_unpacker
end



"""
"""
function firstname(n::Int = 1; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("firstname", "identity", locale; options = SEXES[:options]), n) |> return_unpacker
end

"""
"""
function firstname(sex::Vector{String}, n::Int; locale = getlocale()) :: Union{String, Vector{String}}
    return rand(load!("firstname", "identity", locale; options = sex), n) |> return_unpacker
end

"""
"""
function firstname(sex_mask::Vector{String}; locale = getlocale()) :: Union{String, Vector{String}}
    return load!(sex_mask, "firstname", "identity", locale) |> return_unpacker
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
function fullname(n::Int = 1; locale = getlocale()) :: Union{String, Vector{String}}
    fullnames = Vector{String}()
    for _ in 1:n
        fname = Impostor.firstname(; locale = locale)
        surnames = sample(load!("surname", "identity", locale), rand(1:3))
        push!(fullnames, fname * " "* join(surnames, " "))
    end
    return fullnames |> return_unpacker
end

"""

"""
function fullname(sex::Vector{String}, n::Int; locale = getlocale()) :: Union{String, Vector{String}}
    fullnames = Vector{String}()
    for _ in 1:n
        fname = Impostor.firstname(sex; locale = locale)
        surnames = sample(load!("surname", "identity", locale), rand(1:3))
        push!(fullnames, fname * " "* join(surnames, " "))
    end
    return fullnames |> return_unpacker
end

"""

"""
function fullname(sex_mask::Vector{String}; locale = getlocale()) :: Union{String, Vector{String}}
    fullnames = Vector{String}()
    for sex in sex_mask
        fname = Impostor.firstname([sex]; locale = locale)
        surnames = sample(load!("surname", "identity", locale), rand(1:3))
        push!(fullnames, fname * " "* join(surnames, " "))
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
