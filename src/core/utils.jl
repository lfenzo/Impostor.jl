"""

"""
@inline function coerse_string_type(v::Vector{<:AbstractString}) :: Union{String, Vector{String}}
    strings = v isa Vector{String} ? v : convert.(String, v)
    return length(strings) == 1 ? only(strings) : strings
end



"""
    _materialize_numeric_template(template::String) :: String

Receive a numeric template string (e.g. "###-#") and generate a string replacing the '#' chars
by random integers between [0, 9]. Optionally, pass fixed numbers in the numeric template
(e.g. "(15) 9####-####") to pre-select the numbers in the returned string.
"""
function _materialize_numeric_template(template::AbstractString) :: String
    materialized = ""
    for char in template
        materialized *= char == '#' ? string(rand(0:9)) : char
    end
    return materialized
end



"""

"""
function _materialize_template(format::String, reference_dfrow::DataFrames.DataFrameRow; locale::String) :: String
    materialized = ""

    for t in tokenize(format) 
        token = string(t)

        # references to dataframe columns (not necessarily the names exported by the packages)
        if token in names(reference_dfrow)
            materialized *= reference_dfrow[token]
        # references to names exported by the package
        elseif Symbol(token) in names(Impostor)
            # 'string' is necessary here because some functions return numbers, which cannot be
            # concatenated to strings without an explicit conversion
            materialized *= getproperty(Impostor, Symbol(token))(1; locale = [locale]) |> string
        # other tokens should be repeated in materialized string
        else
            materialized *= token
        end
    end
    return materialized
end

"""

"""
function _materialize_template(template::AbstractString; locale::String) :: String

    materialized = ""

    for token in tokenize(convert(String, template))
        if Symbol(token) in names(Impostor)
            # the locale must be passed to the function  as a list of strings,
            # even when there is excactly one locale to be fetched
            materialized *= getproperty(Impostor, Symbol(token))(1; locale = [locale])
        elseif token != '\n'
            materialized *= string(token)
        end
    end
    return materialized
end
