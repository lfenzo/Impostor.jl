"""

"""
Base.@kwdef mutable struct ImpostorTemplate
    format::Union{Vector{Symbol}, Nothing} = nothing
    knowledge_field::Vector{String} = KNOWLEDGE_FIELDS[:options]
    sex::Vector{String} = SEXES[:options]
    locale::Vector{String} = getlocale()
end


"""

"""
function (impostor::ImpostorTemplate)(n::Int = 1, sink = Dict)

    sex_mask = rand(impostor.sex, n)
    knowledge_field_mask = rand(impostor.knowledge_field, n)

    generated_entries = Dict() 

    for f in impostor.format
        if f == :prefix
            generated_entries[f] = Impostor.prefix(sex_mask, n; impostor.locale)
        end
        if f == :firstname
            generated_entries[f] = Impostor.firstname(sex_mask, n; impostor.locale)
        end
        if f == :surname
            generated_entries[f] = Impostor.surname(n)
        end
        if f == :sex
            generated_entries[f] = sex_mask
        end
        if f == :birthdate
            generated_entries[f] = Impostor.birthdate(n)
        end
        if f == :occupation
            generated_entries[f] = Impostor.occupation(knowledge_field_mask, n; impostor.locale)
        end
        if f == :bloodtype
            generated_entries[f] = Impostor.bloodtype(n)
        end
        if f == :highschool
            generated_entries[f] = Impostor.highschool(n; impostor.locale)
        end
        if f == :university
            generated_entries[f] = Impostor.university(knowledge_field_mask, n; impostor.locale)
        end
        if f == :knowledge_field
            generated_entries[f] = knowledge_field_mask
        end
    end

    return generated_entries |> sink
end
