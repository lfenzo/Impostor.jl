"""

"""
@inline function coerse_string_type(v::Vector{<:AbstractString}) :: Union{String, Vector{String}}
    strings = v isa Vector{String} ? v : convert.(String, v)
    return length(strings) == 1 ? only(strings) : strings
end



"""

"""
function subset_by_option(df::DataFrame, options::Vector{<:AbstractString}, optionlevel::AbstractString)
    

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
function _materialize_template(template::AbstractString; locale::String) :: String

    materialized = ""  # initialized the variable used inside the for loop

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
