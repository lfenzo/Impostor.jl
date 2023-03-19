# set of available values for the "knowledge filds", used in the occupation and 
# the university functions
const KNOWLEDGE_FIELDS::NTuple{T, String} where {T} = (
    "business",
    "humanities",
    "social-sciences",
    "natural-sciences",
    "formal-sciences",
    "public-administration",
    "military",
)


"""

"""
function identity(n::Int, formats::Union{Vector{Symbol}, Nothing}, sink = Dict;
    sex::Vector{T} = ["male", "female"],
    fields::Union{NTuple, Vector{T}} = KNOWLEDGE_FIELDS,
    locale::Vector{T} = getlocale(container)
) where {T <: AbstractString}

    for field in fields
        @assert field in KNOWLEDGE_FIELDS "Knowlege field '$field' not available"
    end

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

"""
function highschool(n::Int = 1; locale = getlocale(container)) :: Union{String, Vector{String}}
    return rand(load!("highschool", "identity", locale), n) |> return_unpacker
end


"""

"""
function bloodtype(n::Int = 1) :: Union{String, Vector{String}}
    return [rand(["A", "B", "AB", "O"]) * rand(["+", "-"]) for _ in 1:n] |> return_unpacker
end

"""

"""
function occupation(n::Int = 1; locale = getlocale(container)) :: Union{String, Vector{String}}
    return rand(load!("occupation", "identity", locale), n) |> return_unpacker
end


"""

"""
function birthdate(n::Int; start::Date = Date(1900, 1, 1), stop::Date = today()) :: Union{Date, Vector{Date}}
    return random_date(n, start = start, stop = stop) |> return_unpacker
end


"""

"""
function firstname(n::Int = 1; locale = getlocale(container)) :: Union{String, Vector{String}}
    return rand(load!("firstnames", "identity", locale; options = ["female", "male"]), n) |> return_unpacker
end

function firstname(sex::String, n::Int = 1; locale = getlocale(container)) :: Union{String, Vector{String}}
    return rand(load!("firstnames", "identity", locale; options = [sex]), n) |> return_unpacker
end

function firstname(sex_mask::Vector{String}, n::Int = 1; locale = getlocale(container)) :: Union{String, Vector{String}}
    return load!(sex_mask, "firstnames", "identity", locale) |> return_unpacker
end


"""

"""
function prefix(n::Int = 1; locale = getlocale(container)) :: Union{String, Vector{String}}
    return rand(load!("prefixes", "identity", locale; options = ["female", "male"]), n) |> return_unpacker
end

function prefix(sex::String, n::Int = 1; locale = getlocale(container)) :: Union{String, Vector{String}}
    return rand(load!("prefixes", "identity", locale; options = [sex]), n) |> return_unpacker
end

function prefix(sex_mask::Vector{String}, n::Int = 1; locale = getlocale(container)) :: Union{String, Vector{String}}
    return load!(sex_mask, "prefixes", "identity", locale) |> return_unpacker
end


"""

"""
function surname(n::Int = 1; locale = getlocale(container)) :: Union{String, Vector{String}}
    return rand(load!("surnames", "identity", locale), n) |> return_unpacker
end



"""

"""
function occupation(n::Int = 1; locale = getlocale(container)) :: Union{String, Vector{String}}
    return rand(load!("occupation", "identity", locale; options = KNOWLEDGE_FIELDS), n) |> return_unpacker
end

function occupation(field::String, n::Int = 1; locale = getlocale(container)) :: Union{String, Vector{String}}
    return rand(load!("occupation", "identity", locale; options = [field]), n) |> return_unpacker
end

function occupation(field_mask::Vector{String}, n::Int = 1; locale = getlocale(container)) :: Union{String, Vector{String}}
    return load!(field_mask, "occupation", "identity", locale) |> return_unpacker
end



"""

"""
function university(n::Int = 1; locale = getlocale(container)) :: Union{String, Vector{String}}
    return rand(load!("university", "identity", locale; options = KNOWLEDGE_FIELDS), n) |> return_unpacker
end

function university(field::String, n::Int = 1; locale = getlocale(container)) :: Union{String, Vector{String}}
    return rand(load!("university", "identity", locale; options = [field]), n) |> return_unpacher
end

function university(field_mask::Vector{String}, n::Int = 1; locale = getlocale(container)) :: Union{String, Vector{String}}
    return load!(field_mask, "university", "identity", locale) |> return_unpacker
end
