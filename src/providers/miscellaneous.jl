"""

"""
function locale_code(n::Integer = 1; kwargs...)
    locale_codes = get_all_locales() 
    return rand(locale_codes, n) |> coerse_string_type
end
