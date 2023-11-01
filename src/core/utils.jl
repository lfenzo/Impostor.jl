"""
    coerse_string_type(v::Vector{<:AbstractString}) :: Union{String, Vector{String}}

Automatically unpack the return value of a generator function into a single string,
when appropriate.

# Parameters
- `v::Vector{<:AbstractString}`: value(s) returned by some generator function.

# Example
```repl
julia> Impostor.coerse_string_type(["Mark"])
"Mark"

julia> Impostor.coerse_string_type(["Mark", "Jane"])
2-element Vector{String}:
 "Mark"
 "Jane"
```
"""
@inline function coerse_string_type(v::Vector{<:AbstractString}) :: Union{String, Vector{String}}
    strings = v isa Vector{String} ? v : convert.(String, v)
    return length(strings) == 1 ? only(strings) : strings
end



"""
    materialize_numeric_template(template::String) :: String
    materialize_numeric_template(template::AbstractString, number::Integer) :: String

Receive a numeric template string (e.g. `"###-#"`) and generate a string replacing the '#' chars
by random integers between [0, 9]; pass fixed numbers in the numeric template (e.g. `"(15) 9####-####"`)
to pre-select the numbers in the returned string.

Optionally, provide a `number` to fill the placeholders `'#'` in `template`. **In this usage, the
number of digits in `number` may be greater of equal to the number of `'#'` in `template`, but
not smaller.**

# Examples
```@repl
julia> materialize_numeric_template("####-#")
"1324-8"

julia> materialize_numeric_template("1/####-9")
"1/5383-9"

julia> materialize_numeric_template("####-#", 12345)
"1234-5"

julia> materialize_numeric_template("1/####-9", 4321)
"1/4321-9"

julia> materialize_numeric_template("####", 87654321)
"8765"
```
"""
function materialize_numeric_template(template::AbstractString) :: String
    materialized = ""
    for char in template
        materialized *= char == '#' ? string(rand(0:9)) : char
    end
    return materialized
end

function materialize_numeric_template(template::AbstractString, number::Union{Integer, String}) :: String
    if number isa Integer
        number_digits = digits(number) 
        converted_number = string(number)
    else
        number_digits = collect(reverse(number))
        converted_number = number
    end

    template_length = filter(c -> c == '#', template) |> length

    @assert(
        length(converted_number) >= template_length,
        "Provided template length $(template_length) should be "
        * ">=  to the number length $(length(converted_number))"
    )

    formatted = ""

    for char in template
        formatted *= char == '#' ? pop!(number_digits) : char
    end
    return formatted
end



"""
    materialize_numeric_range_template(template::AbstractString) :: String

Generate a string containing a number from a *numeric range* template. Such numeric templates may
contain options separated by a `';'` caracter. Additionally, options can assume a single template
format (e.g. `"4##"`) or specify a range using the `':'` character inside the option (e.g. `"2##:3##"`
specifies numbers between 200 and 399).

# Example
```@repl
julia> materialize_numeric_range_template("4#####")
"412345"

julia> materialize_numeric_range_template("34####;37####")  # will select 34#### or 37####
"349790"

julia> materialize_numeric_range_template("51####:55####")
"532489"

julia> materialize_numeric_range_template("2221##:2720##;51####:55####")  # will select 2221##:2720## or 51####:55####
"250000"
```
"""
function materialize_numeric_range_template(template::AbstractString) :: String
    possible_formats = split(template, ';')
    selected_format = rand(possible_formats)

    # selected format has a range specifier e.g. 34####:39####
    if ':' in selected_format
        first, last = split(selected_format, ':')
        lower_limit = parse(Int, replace(first, '#' => '0'))
        upper_limit = parse(Int, replace(last, '#' => '9'))
        selected_format = rand(lower_limit:upper_limit) |> string
    else
        selected_format = materialize_numeric_template(selected_format)
    end

    return selected_format
end



"""
    materialize_template(template locale) :: String
    materialize_template(template, reference_dfrow; locale) :: String

Materialize a given pre-defined template by splitting `template` into tokens; each token *may*
by associated to a generator-function exported by Impostor. For practicality, tokens not exported
by Impostor (see example below) are just repeated in the materialized template since it is not
possible for Impostor to distinguish between badly spelled generator functions and raw text
which should be present in materialized template.

Optionally, provide a `reference_dfrow` with column names which may be referenced by
tokens in `template`. This is useful in the context of hierarchical data manipulation

# Parameters
- `template::String`: templaate to be materialized.
- `reference_dfrow::DataFrames.DataFrameRow`: Reference values stored in a single-row DataFrame (`DataFrameRow`); access to values is made through references to column names of `reference_dfrow` (see examples below).

# Examples

## String Materialization
```@repl
julia> template = "firstname surname occupation";

julia> materialize_template(template; locale="en_US")
"Charles Fraser Anthropologyst"

julia> template = "I know firstname surname, this person is a(n) occupation";

julia> materialize_template(template; locale="en_US")
"I know Charles Jameson, this person is a(n) Mathematician"
```

## Missing Tokens
```@repl
julia> template = "firstname lastname"  # not that there is no such 'lastname' function
"firstname lastname"

julia> materialize_template(template; locale="en_US")
"Kate lastname"
```

## Using `DataFrameRow`s
```@repl
julia> dfrow = DataFrame(state="California", city="San Francisco")[1, :]
1×2 DataFrame
 Row │ state       city
     │ String      String
─────┼───────────────────────────
   1 │ California  San Francisco

julia> template = "I live in city (state)"

julia> materialize_template(template, dfrow; locale = "en_US")
"I live in San Francisco (California)"
```
"""
function materialize_template(template::String, reference_dfrow::DataFrames.DataFrameRow; locale::String) :: String
    materialized = ""

    for t in tokenize(template) 
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

function materialize_template(template::String; locale::String) :: String
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
