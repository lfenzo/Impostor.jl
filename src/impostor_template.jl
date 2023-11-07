"""
    ImpostorTemplate(formats::Union{T, S, Vector{Union{T, S}}}) where {T<:AbstractString, S<:Symbol}

Struct storing the `formats` used to generate new tables. Each of the elements in `formats` maps to
a generator function exported by Impostor. This struct is later used as a *functor* in order to
generate data, that is, after instantiating a new `ImpostorTemplate` object, this object will be
called providing arguments in order to generate the data entries.

# Parameters
- `formats` (`String`, `Symbol` or `Vector{Union{String, Symbol}}`): table output format specified in terms of generator functions to be used in each column (see examples below).

# Examples
```@repl
julia> imp = ImpostorTemplate("firstname")
ImpostorTemplate([:firstname])

julia> imp = ImpostorTemplate(:firstname)
ImpostorTemplate([:firstname])

julia> imp = ImpostorTemplate(["firstname"])
ImpostorTemplate([:firstname])

julia> imp = ImpostorTemplate([:firstname])
ImpostorTemplate([:firstname])
```
"""
Base.@kwdef mutable struct ImpostorTemplate
    format::Vector{Symbol}

    function ImpostorTemplate(formats::Union{T, S, Vector{Union{T, S}}}) where {T<:AbstractString, S<:Symbol}
        if formats isa Vector
            symbol_formats = eltype(formats) <: String ? Symbol.(formats) : formats
        else
            symbol_formats = if formats isa String
                [Symbol.(formats)]
            elseif formats isa Symbol
                [formats]
            end
        end
        if _all_formats_availabe(symbol_formats)
            return new(symbol_formats)
        end
    end
end


addfield!(i::ImpostorTemplate, field::Symbol) = push!(i.format, field)
setformat!(i::ImpostorTemplate, format::Vector{Symbol}) = setfield!(i, :format, format)



"""
    _all_formats_available(formats::Vector)

Verify if all `formats` are available and exported by Impostor.jl, otherwise throw `ArgumentError`
"""
function _all_formats_availabe(formats::Vector{Symbol})
    invalid_formats = Symbol[]
    valid_formats = names(Impostor; all = false)

    for f in formats
        if !(f in valid_formats)
            push!(invalid_formats, f)
        end
    end

    if !isempty(invalid_formats)
        ArgumentError("Invalid formats provided: $(invalid_formats)") |> throw
    else
        return true
    end
end



"""
    (impostor::ImpostorTemplate)(n::Integer = 1, sink = Dict; kwargs...)

Generate `n` entries according to the `format` provided when `impostor` was instantiated.

# Parameters
- `n`: number of entries/rows to generate in each format
- `sink = Dict`: type sink for the generated table.

# Kwargs
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.

# Examples
```@repl
julia> formats = ["complete_name", "credit_card_number", "credit_card_expiry"];

julia> template = ImpostorTemplate(formats)
ImpostorTemplate([:complete_name, :credit_card_number, :credit_card_expiry])

julia> template(3, DataFrame)
3×3 DataFrame
 Row │ complete_name                  credit_card_number  credit_card_expiry
     │ String                         String              String
─────┼───────────────────────────────────────────────────────────────────────
   1 │ Sophie Cornell Collins         52583708162384822   6/2008
   2 │ Mary Collins Cornell           3442876938992966    10/2022
   3 │ John Sheffard Cornell Collins  4678055537702596    10/2021

julia> template(3, DataFrame; locale = ["pt_BR"])
3×3 DataFrame
 Row │ complete_name                      credit_card_number  credit_card_expiry
     │ String                             String              String
─────┼───────────────────────────────────────────────────────────────────────────
   1 │ João Camargo da Silva Pereira      3418796429393351    4/2018
   2 │ João Pereira da Silva              4305288858368967    6/2018
   3 │ Bernardo Pereira Camargo da Silva  3751513143972989    3/2024
```
"""
function (impostor::ImpostorTemplate)(n::Integer = 1, sink = Dict;
    locale = session_locale(),
    kws...
)
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

    if !isempty(intersect(LOCALIZATIONS[:provider_functions], impostor.format))
        localizations = render_localization_map(; locale)
        localization_df_indexes = rand(1:size(localizations, 1), n)
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
            generated_values[f] = localizations[localization_df_indexes, f]
        else
            generated_values[f] = generator_function(n; locale)
        end
    end

    return generated_values |> sink
end
