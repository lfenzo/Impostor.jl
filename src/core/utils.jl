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
    _materialize_numeric_range_template(template::AbstractString) :: String

Gen*rate a string containing a number from a *numeric range* template. Such numeric templates may
contain options separated by a ';' caracter. Additionally, options can assume a single template
format (e.g. "4##") or specify a range using the ':' character inside the option (e.g. "2##:3##"
specifies numbers between 200 and 399).

# Example
```repl
julia> Impostor._materialize_numeric_range_template("4#####")
"412345"

julia> Impostor._materialize_numeric_range_template("34####;37####")  # will select 34#### or 37####
"349790"

julia> Impostor._materialize_numeric_range_template("51####:55####")
"532489"

julia> Impostor._materialize_numeric_range_template("2221##:2720##;51####:55####")  # will select 2221##:2720## or 51####:55####
"250000"
```
"""
function _materialize_numeric_range_template(template::AbstractString) :: String
    possible_formats = split(template, ';')
    selected_format = rand(possible_formats)

    # selected format has a range specifier e.g. 34####:39####
    if ':' in selected_format
        first, last = split(selected_format, ':')
        lower_limit = parse(Int, replace(first, '#' => '0'))
        upper_limit = parse(Int, replace(last, '#' => '9'))
        selected_format = rand(lower_limit:upper_limit) |> string
    else
        selected_format = _materialize_numeric_template(selected_format)
    end

    return selected_format
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
