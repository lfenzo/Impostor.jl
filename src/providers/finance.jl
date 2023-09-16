"""
    bank_name(n::Integer = 1; kwargs...)
    bank_name(options::Vector, n::Integer; optionlevel::Symbol = :bank_code, kwargs...)
    bank_name(mask::Vector; masklevel::Symbol = :bank_code, kwargs...)

Generate `n` bank names.


# Kwargs
- `locale::Vector{String}`: locale(s) from which entries are sampled. If no `locale` is provided, the current session locale is used.
"""
function bank_name(n::Integer = 1; locale = session_locale())
    return rand(_load!("finance", "bank", locale)[:, :bank_name], n) |> coerse_string_type
end

function bank_name(options::Vector, n::Integer; optionlevel::Symbol = :bank_code, locale = session_locale())
    @assert(
        optionlevel in (:bank_code, :bank_name),
        "invalid 'optionlevel' provided: \"$optionlevel\""
    )

    df = _load!("finance", "bank", locale)
    filter!(r -> r[optionlevel] in options, df)
    return rand(df[:, :bank_name], n) |> coerse_string_type
end

function bank_name(mask::Vector; masklevel::Symbol = :bank_code, locale = session_locale())
    @assert(
        masklevel in (:bank_code, :bank_name),
        "invalid 'masklevel' provided: \"$masklevel\""
    )

    bank_info = _load!("finance", "bank", locale)
    bank_institutions = Vector{String}()

    for m in mask
        # accessing with '[1, :]' because we are sure to have exactly one match for the
        # option provided as a mask. 
        selected_bank_dfrow = filter(r -> r[masklevel] == m, bank_info)[1, :]
        push!(bank_institutions, selected_bank_dfrow[:bank_name])
    end

    return bank_institutions |> coerse_string_type
end



"""
    bank_official_name(n::Integer = 1; kwargs...)
    bank_official_name(options::Vector, n::Integer; optionlevel::Symbol = :bank_code, kwargs...)
    bank_official_name(mask::Vector; masklevel::Symbol = :bank_code, kwargs...)

"""
function bank_official_name(n::Integer = 1; locale = session_locale())
    return rand(_load!("finance", "bank", locale)[:, :bank_official_name], n) |> coerse_string_type
end

function bank_official_name(options::Vector, n::Integer; optionlevel::Symbol = :bank_code, locale = session_locale())
    @assert(
        optionlevel in (:bank_code, :bank_name),
        "invalid 'optionlevel' provided: \"$optionlevel\""
    )

    df = _load!("finance", "bank", locale)
    filter!(r -> r[optionlevel] in options, df)
    return rand(df[:, :bank_official_name], n) |> coerse_string_type
end

function bank_official_name(mask::Vector; masklevel::Symbol = :bank_code, locale = session_locale())
    @assert(
        masklevel in (:bank_code, :bank_name),
        "invalid 'masklevel' provided: \"$masklevel\""
    )

    bank_info = _load!("finance", "bank", locale)
    bank_institutions = Vector{String}()

    for m in mask
        # here we are accessing with '[1, :]' because we are sure to have exactly one match for the
        # option provided as a mask. 
        selected_bank_dfrow = filter(r -> r[masklevel] == m, bank_info)[1, :]
        push!(bank_institutions, selected_bank_dfrow[:bank_official_name])
    end

    return bank_institutions |> coerse_string_type
end


"""

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

function _generate_credit_card_number(reference_dfrow::DataFrames.DataFrameRow)
    card_prefix = _materialize_numeric_range_template(reference_dfrow[:iin_format])
    card_length = parse(Int, _materialize_numeric_range_template(string(reference_dfrow[:length])))
    return _generate_credit_card_number(card_prefix, card_length)
end

"""

"""
function credit_card_number(n::Integer = 1; kwargs...)
    credit_card_references = _load!("finance", "credit_card", "noloc")
    generated_cards = String[]

    for _ in 1:n
        selected_vendor_dfrow = rand(eachrow(credit_card_references))
        push!(generated_cards, _generate_credit_card_number(selected_vendor_dfrow))
    end

    return generated_cards |> coerse_string_type
end

"""

"""
function credit_card_number(options::Vector{<:AbstractString}, n::Integer; kwargs...)
    credit_card_references = _load!("finance", "credit_card", "noloc")
    filter!(r -> r[:credit_card_vendor] in options, credit_card_references)
    generated_cards = Vector{String}()

    for _ in 1:n
        selected_vendor_dfrow = rand(eachrow(credit_card_references))
        push!(generated_cards, _generate_credit_card_number(selected_vendor_dfrow))
    end

    return generated_cards |> coerse_string_type
end

"""

"""
function credit_card_number(mask::Vector{<:AbstractString}; kwargs...)
    credit_card_references = _load!("finance", "credit_card", "noloc")
    generated_cards = Vector{String}()

    for m in mask
        # here we are accessing with '[1, :]' because we are sure to have exactly one match for the
        # option provided as a mask. Since the 'filter' function returns a DataFrame rather than a
        # DataFrameRow we must perform this operation before forwarding it to '_generate_credit_card_number'
        selected_vendor_dfrow = filter(r -> r[:credit_card_vendor] == m, credit_card_references)[1, :]
        push!(generated_cards, _generate_credit_card_number(selected_vendor_dfrow))
    end

    return generated_cards |> coerse_string_type
end



"""
    credit_card_vendor(n::Integer = 1; kwargs...)
    credit_card_vendor(options::Vector{<:AbstractString}, n::Integer; kwargs...)

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



"""
    credit_card_cvv(n::Integer = 1; kwargs...)

"""
function credit_card_cvv(n::Integer = 1; kwargs...)
    generated = rand(0:999, n)
    return n == 1 ? only(generated) : generated
end


"""
    credit_card_expiry(n::Integer = 1; kwargs...)

"""
function credit_card_expiry(n::Integer = 1; kwargs...)
    expiries = String[]
    for _ in 1:n
        month = rand(1:12) |> string
        year = rand(2008:2030) |> string
        push!(expiries, "$month/$year")
    end
    return expiries
end
