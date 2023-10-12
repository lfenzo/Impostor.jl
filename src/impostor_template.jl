"""
    ImpostorTemplate(format::Vector{Symbol})

Struct storing the formats used to 
"""
Base.@kwdef mutable struct ImpostorTemplate
    format::Vector{Symbol}
end


addfield!(i::ImpostorTemplate, field::Symbol) = push!(i.format, field)
setformat!(i::ImpostorTemplate, format::Vector{Symbol}) = setfield!(i, :format, format)



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
    (impostor::ImpostorTemplate)(n::Integer = 1, sink = Dict; kwargs...)

Generates `n` entries with information specified in the formats.

# Kwargs
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function (impostor::ImpostorTemplate)(n::Integer = 1, sink = Dict;
    locale = session_locale(),
    kwargs...
)
    _verify_formats(impostor.format)
    generated_values = OrderedDict()

    if !isempty(intersect(SEXES[:provider_functions], impostor.format))
        sex_mask = rand(SEXES[:options], n)
    end

    if !isempty(intersect(KNOWLEDGE_FIELDS[:provider_functions], impostor.format))
        knowledge_field_mask = rand(KNOWLEDGE_FIELDS[:options], n)
    end

    if !isempty(intersect(CREDIT_CARDS[:provider_functions], impostor.format))
        vendors = _load!("finance", "credit_card", "noloc")[:, :credit_card_vendor] .|> String
        credit_card_mask = rand(vendors, n)
    end

    # 'intersect' will maintain the order of the first argument, so we can use it
    # to determine the lowerst level of the localization dataframe
    localization_formats = intersect(LOCALIZATIONS[:provider_functions], impostor.format)
    if !isempty(localization_formats)
        minimum_level_remap = Dict(
            :state => :state_code,
            :country => :country_code
        )
        minimum_level = last(localization_formats)
        localization_df = Impostor._hierarchical_localization_fallback(minimum_level |> String, "country", locale) 
        localization_df_indexes = rand(1:size(localization_df, 1), n)

        if minimum_level in keys(minimum_level_remap)
            minimum_level = minimum_level_remap[minimum_level]
        end
    end

    for f in impostor.format
        generator_function = getproperty(Impostor, f)

        if f in SEXES[:provider_functions]
            generated_values[f] = generator_function(sex_mask; locale)
        elseif f in KNOWLEDGE_FIELDS[:provider_functions]
            generated_values[f] = generator_function(knowledge_field_mask; locale)
        elseif f in CREDIT_CARDS[:provider_functions]
            generated_values[f] = generator_function(credit_card_mask; locale)
        elseif f in LOCALIZATIONS[:provider_functions]
            generated_values[f] = localization_df[localization_df_indexes, f]
        else
            generated_values[f] = generator_function(n; locale)
        end
    end

    return generated_values |> sink
end
