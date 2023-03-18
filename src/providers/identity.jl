const KNOWLEDGE_FIELDS = (
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
function identity(n::Int, formats::Union{Vector{Symbol}, Nothing}, sink = Dict; sex::Vector{T}, locale::Vector{T} = ["en_US"]) where {T <: AbstractString}

    generated_names = Dict() 
    sex_mask = rand(sex, n)
    knowledge_field_mask = rand(KNOWLEDGE_FIELDS, n)

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
            generated_names[f] = occupation(knowledge_field_mask, n)
        end
        if f == :bloodtype
            generated_names[f] = bloodtype(n)
        end
        if f == :highschool
            generated_names[f] = highschool(n)
        end
        if f == :university
            generated_names[f] = university(knowledge_field_mask, n)
        end
        if f == :knowledge_field
            generated_names[f] = knowledge_field_mask
        end
    end

    return generated_names |> sink
end


"""

"""
function highschool(n::Int = 1; locale::Vector{T} = ["en_US"]) :: Vector{T} where {T <: AbstractString}
    return rand(load!("highschool", "identity", locale), n)
end


"""

"""
function bloodtype(n::Int = 1)
    return [rand(["A", "B", "AB", "O"]) * rand(["+", "-"]) for _ in 1:n]
end

"""

"""
function occupation(n::Int = 1; locale::Vector{T} = ["en_US"]) :: Vector{T} where {T <: AbstractString}
    return rand(load!("occupation", "identity", locale), n)
end


"""

"""
function birthdate(n::Int; start::Date = Date(1900, 1, 1), stop::Date = today())
    return random_date(n, start = start, stop = stop)
end


"""

"""
function firstname(n::Int = 1; locale::Vector{T} = ["en_US"]) :: Vector{T} where {T <: AbstractString}
    return rand(load!("firstnames", "identity", locale; options = ["female", "male"]), n)
end

function firstname(sex::T, n::Int = 1; locale::Vector{T} = ["en_US"]) :: Vector{T} where {T <: AbstractString}
    return rand(load!("firstnames", "identity", locale; options = [sex]), n)
end

function firstname(sex_mask::Vector{T}, n::Int = 1; locale::Vector{T} = ["en_US"]) :: Vector{T} where {T <: AbstractString}
    return load!(sex_mask, "firstnames", "identity", locale)
end


"""

"""
function prefix(n::Int = 1; locale::Vector{T} = ["en_US"]) :: Vector{T} where {T <: AbstractString}
    return rand(load!("prefixes", "identity", locale; options = ["female", "male"]), n)
end

function prefix(sex::T, n::Int = 1; locale::Vector{T} = ["en_US"]) :: Vector{T} where {T <: AbstractString}
    return rand(load!("prefixes", "identity", locale; options = [sex]), n)
end

function prefix(sex_mask::Vector{T}, n::Int = 1; locale::Vector{T} = ["en_US"]) :: Vector{T} where {T <: AbstractString}
    return load!(sex_mask, "prefixes", "identity", locale)
end


"""

"""
function surname(n::Int = 1; locale::Vector{T} = ["en_US"]) :: Vector{T} where {T <: AbstractString}
    return rand(load!("surnames", "identity", locale), n)
end



"""

"""
function occupation(n::Int = 1; locale::Vector{T} = ["en_US"]) :: Vector{T} where {T <: AbstractString}
    return rand(load!("occupation", "identity", locale; options = KNOWLEDGE_FIELDS), n)
end

function occupation(field::T, n::Int = 1; locale::Vector{T} = ["en_US"]) :: Vector{T} where {T <: AbstractString}
    return rand(load!("occupation", "identity", locale; options = [field]), n)
end

function occupation(field_mask::Vector{T}, n::Int = 1; locale::Vector{T} = ["en_US"]) :: Vector{T} where {T <: AbstractString}
    return load!(field_mask, "occupation", "identity", locale)
end



"""

"""
function university(n::Int = 1; locale::Vector{T} = ["en_US"]) :: Vector{T} where {T <: AbstractString}
    rand_values = rand(load!("university", "identity", locale; options = KNOWLEDGE_FIELDS), n)
    return n == 1 ? only(rand_values) : rand_values
end

function university(field::T, n::Int = 1; locale::Vector{T} = ["en_US"]) :: Vector{T} where {T <: AbstractString}
    return rand(load!("university", "identity", locale; options = [field]), n)
end

function university(field_mask::Vector{T}, n::Int = 1; locale::Vector{T} = ["en_US"]) :: Vector{T} where {T <: AbstractString}
    return load!(field_mask, "university", "identity", locale)
end
