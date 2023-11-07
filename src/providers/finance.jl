"""
    bank_name(n::Integer = 1; kwargs...)
    bank_name(options::Vector, n::Integer; level::Symbol, kwargs...)
    bank_name(mask::Vector; level::Symbol, kwargs...)

# Parameters
- `n::Integer = 1`: number of bank name entries to generate
- `options::Vector{<:AbstractString}`: vector with options restricting the possible values generated.
- `mask::Vector{<:AbstractString}`: mask vector with element-wise option restrictions.

# Kwargs
- `level::Symbol = :bank_code`: Level of values in `options` or `mask` when using option-based or mask-based eneration.
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.

# Example
```@repl
julia> bank_name(5; locale = ["pt_BR"])
5-element Vector{String}:
 "Broker"
 "Nubank"
 "Itaubank"
 "Renascenca"
 "Daycoval"
```
"""
function bank_name(n::Integer = 1; locale = session_locale())
    return rand(_load!("finance", "bank", locale)[:, :bank_name], n) |> coerse_string_type
end

function bank_name(options::Vector, n::Integer;
    level::Symbol = :bank_code,
    locale = session_locale()
)
    @assert(
        level in (:bank_code, :bank_name),
        "invalid 'level' provided: \"$level\""
    )

    df = _load!("finance", "bank", locale)
    filter!(r -> r[level] in options, df)
    return rand(df[:, :bank_name], n) |> coerse_string_type
end

function bank_name(mask::Vector; level::Symbol = :bank_code, locale = session_locale())
    @assert(
        level in (:bank_code, :bank_name),
        "invalid 'level' provided: \"$level\""
    )

    bank_info = _load!("finance", "bank", locale)
    bank_institutions = String[]

    for m in mask
        # accessing with '[1, :]' because we are sure to have exactly one match for the
        # option provided as a mask. 
        selected_bank_dfrow = filter(r -> r[level] == m, bank_info)[1, :]
        push!(bank_institutions, selected_bank_dfrow[:bank_name])
    end

    return bank_institutions |> coerse_string_type
end



"""
    bank_official_name(n::Integer = 1; kwargs...)
    bank_official_name(options::Vector, n::Integer; level::Symbol, kwargs...)
    bank_official_name(mask::Vector; level::Symbol, kwargs...)

# Parameters
- `n::Integer = 1`: number of official bank name entries to generate
- `options::Vector{<:AbstractString}`: vector with options restricting the possible values generated.
- `mask::Vector{<:AbstractString}`: mask vector with element-wise option restrictions.

# Kwargs
- `level::Symbol = :bank_code`: Level of values in `options` or `mask` when using option-based or mask-based eneration.
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function bank_official_name(n::Integer = 1; locale = session_locale())
    return rand(_load!("finance", "bank", locale)[:, :bank_official_name], n) |> coerse_string_type
end

function bank_official_name(options::Vector, n::Integer;
    level::Symbol = :bank_code,
    locale = session_locale()
)
    @assert(
        level in (:bank_code, :bank_name),
        "invalid 'level' provided: \"$level\""
    )

    df = _load!("finance", "bank", locale)
    filter!(r -> r[level] in options, df)
    return rand(df[:, :official_bank_name], n) |> coerse_string_type
end

function bank_official_name(mask::Vector; level::Symbol = :bank_code, locale = session_locale())
    @assert(
        level in (:bank_code, :bank_name),
        "invalid 'level' provided: \"$level\""
    )

    bank_info = _load!("finance", "bank", locale)
    bank_institutions = Vector{String}()

    for m in mask
        # here we are accessing with '[1, :]' because we are sure to have exactly one match for the
        # option provided as a mask. 
        selected_bank_dfrow = filter(r -> r[level] == m, bank_info)[1, :]
        push!(bank_institutions, selected_bank_dfrow[:bank_official_name])
    end

    return bank_institutions |> coerse_string_type
end



"""
    _generate_credit_card_number(prefix::String, n_digits::Integer)

Generate a valid credit card number from card `prefix` with a fixed `n_digits`.

# Parameters
- `prefix::String`: numbers to prefix the generated credit card, *e.g.:* "12345".
- `n_digits::Integer`: number of digits in the generated credit card.

See also: [credit_card_number](@ref).

# Example
```@repl
julia> Impostor._generate_credit_card_number("12345", 16)
"1234506267207985"
```
"""
function _generate_credit_card_number(prefix::String, n_digits::Integer)
    card_prefix = parse(Int, prefix) |> digits |> reverse
    card_account = [rand(0:9) for _ in 1:(n_digits - length(prefix) - 1)]

    # used only for the checksum calculation in the next 2 for-loops
    generated_numbers = vcat(card_prefix, card_account)

    # doubling every odd position
    for i in 1:2:(n_digits - 1)
        generated_numbers[i] *= 2
    end

    # deducting 9 from numbers greater than 9 (even the ones in the card prefix)
    for i in 1:(n_digits - 1)
        if generated_numbers[i] > 9
            generated_numbers[i] -= 9
        end
    end

    remainder = sum(generated_numbers) % 10
    card_checksum = remainder == 0 ? 0 : (10 - remainder)

    generated_card = vcat(card_prefix, card_account, card_checksum)

    return join(generated_card)
end

function _generate_credit_card_number(reference_dfrow::DataFrames.DataFrameRow, formatted::Bool)
    card_prefix = render_alphanumeric_range(reference_dfrow[:iin_format])
    card_length = parse(Int, render_alphanumeric_range(string(reference_dfrow[:length])))

    generated_card = _generate_credit_card_number(card_prefix, card_length)

    if !formatted
        return generated_card
    else
        format = ""
        n_full_blocks = div(card_length, 4)
        n_remaining_slots = card_length % 4

        for i in 1:n_full_blocks
            format *= (i < n_full_blocks) ? "####-" : "####"
        end

        for i in 1:n_remaining_slots
            format *= (i == 1) ? "-#" : "#"
        end

        return render_alphanumeric(format; numbers = generated_card)
    end
end



"""
    credit_card_number(n::Integer = 1; kwargs...)
    credit_card_number(options::Vector{<:AbstractString}, n::Integer; kwargs...)
    credit_card_number(mask::Vector{<:AbstractString}; kwargs...)

Generate valid credit card numbers according to the credit card vendor. Available vendors are:
- `"Visa"`
- `"American Express"`
- `"MasterCard"`

# Parameters
- `n::Integer = 1`: number of credit card numbers to generate.
- `options::Vector{<:AbstractString}`: vector with options restricting the possible values generated.
- `mask::Vector{<:AbstractString}`: mask vector with element-wise option restrictions.

# Kwargs
- `formatted::Bool`: whether to return the raw credit card numbers *e.g.* `"3756808757861311"` or to format the output *e.g.* `"3756-8087-5786-1311"`

# Examples
```@repl
julia> credit_card_number()
"5186794250685172"

julia> credit_card_number(; formatted = true)
"4046-7508-2101-2729"
```
"""
function credit_card_number(n::Integer = 1; formatted::Bool=false, kwargs...)
    credit_card_references = _load!("finance", "credit_card", "noloc")
    generated_cards = String[]

    for _ in 1:n
        selected_vendor_dfrow = rand(eachrow(credit_card_references))
        push!(generated_cards, _generate_credit_card_number(selected_vendor_dfrow, formatted))
    end
    return generated_cards |> coerse_string_type
end

function credit_card_number(options::Vector{<:AbstractString}, n::Integer; formatted::Bool=false, kwargs...)
    credit_card_references = _load!("finance", "credit_card", "noloc")
    filter!(r -> r[:credit_card_vendor] in options, credit_card_references)
    generated_cards = String[]

    for _ in 1:n
        selected_vendor_dfrow = rand(eachrow(credit_card_references))
        push!(generated_cards, _generate_credit_card_number(selected_vendor_dfrow, formatted))
    end
    return generated_cards |> coerse_string_type
end

function credit_card_number(mask::Vector{<:AbstractString}; formatted::Bool=false, kwargs...)
    credit_card_references = _load!("finance", "credit_card", "noloc")
    generated_cards = String[]

    for m in mask
        # accessing with '[1, :]' because we are sure to have exactly one match for the
        # option provided as a mask. Since the 'filter' function returns a DataFrame rather than a
        # DataFrameRow we must perform this operation before forwarding it to '_generate_credit_card_number'
        selected_vendor_dfrow = filter(r -> r[:credit_card_vendor] == m, credit_card_references)[1, :]
        push!(generated_cards, _generate_credit_card_number(selected_vendor_dfrow, formatted))
    end
    return generated_cards |> coerse_string_type
end



"""
    credit_card_vendor(n::Integer = 1; kwargs...)
    credit_card_vendor(options::Vector{<:AbstractString}, n::Integer; kwargs...)

Generate `n` credit card vendor names.

# Example
```@repl
julia> credit_card_vendor(3)
3-element Vector{String}:
 "American Express"
 "American Express"
 "Visa"
```
"""
function credit_card_vendor(n::Integer = 1; kwargs...)
    credit_cards = _load!("finance", "credit_card", "noloc")
    return rand(credit_cards[:, :credit_card_vendor], n) |> coerse_string_type
end

function credit_card_vendor(options::Vector{<:AbstractString}, n::Integer; kwargs...)
    credit_cards = _load!("finance", "credit_card", "noloc")
    filter!(r -> r[:credit_card_vendor] in options, credit_cards)
    return rand(credit_cards[:, :credit_card_vendor], n) |> coerse_string_type
end

function credit_card_vendor(mask::Vector{<:AbstractString}; keargs...)
    credit_cards = _load!("finance", "credit_card", "noloc")

    available_venders = unique(credit_cards[:, :credit_card_vendor] .|> String) 
    provided_vendors = unique(mask)

    @assert [pv in available_venders for pv in provided_vendors] |> all

    return mask
end



"""
    credit_card_cvv(n::Integer = 1; kwargs...)

Generate `n` credit card ccvs, e.g. `034`

# Examples
```@repl
julia> credit_card_cvv(3)
3-element Vector{Int64}:
 636
 429
 117

```
"""
function credit_card_cvv(n::Integer = 1; kwargs...)
    generated = rand(0:999, n)
    return n == 1 ? only(generated) : generated
end



"""
    credit_card_expiry(n::Integer = 1; kwargs...)

Generate `n` credit card expiry entries, e.g. `05/2029`.
# Examples
```@repl
julia> credit_card_expiry(3)
3-element Vector{String}:
 "4/2014"
 "7/2013"
 "10/2010"
```
"""
function credit_card_expiry(n::Integer = 1; kwargs...)
    expiries = String[]
    for _ in 1:n
        month = rand(1:12) |> string
        year = rand(2008:2030) |> string
        push!(expiries, "$month/$year")
    end
    return expiries |> coerse_string_type
end
