"""

"""
Base.@kwdef mutable struct ImpostorTemplate
    format::Vector{Symbol}
end


addfield!(i::ImpostorTemplate, field::Symbol) = push!(i.format, field)



"""
    _sanitize_formats(formats::Vector)

Verify if all `formats` are available and exported by Impostor.jl
"""
function _verify_formats(formats::Vector{Symbol})
    invalid_formats = Symbol[]
    valid_formats = names(Impostor; all = false)

    for f in formats
        if !(f in valid_formats)
            push!(invalid_formats, f)
        end
    end

    if !isempty(invalid_formats)
        ArgumentError("Invalid formats provided: $(invalid_formats)") |> throw
    end
end



"""

"""
function (impostor::ImpostorTemplate)(n::Integer = 1, sink = Dict; locale = session_locale(), kwargs...)

    _verify_formats(impostor.format)
    generated_values = Dict()

    if !isempty(intersect(impostor.format, SEXES[:provider_functions]))
        sex_mask = rand(SEXES[:options], n)
    end

    if !isempty(intersect(impostor.format, KNOWLEDGE_FIELDS[:provider_functions]))
        knowledge_field_mask = rand(KNOWLEDGE_FIELDS[:options], n)
    end

    for f in impostor.format
        generator_function = getproperty(Impostor, f)

        if f in SEXES[:provider_functions]
            generated_values[f] = generator_function(sex_mask; locale)
        elseif f in KNOWLEDGE_FIELDS[:provider_functions]
            generated_values[f] = generator_function(knowledge_field_mask; locale)
        else
            generated_values[f] = generator_function(n; locale)
        end
    end

    return generated_values |> sink
end
