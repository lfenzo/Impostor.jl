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
    render_alphanumeric(template::AbstractString; numbers, letters) :: String

Receive an alphanumeric template string (e.g. `"^^^-####"`) and generate a string replacing:
- `'#'` chars by random numbers between [0, 9].
- `'^'` chars by random uppercase letters between A-Z.
- `'_'` chars by random lowercase letters between a-z.
- `'='` chars by random uppercase or lowercase letters between a-z|A-Z.

Optionally, provide `numbers` to fill the `'#'` placeholders in `template`; or `letters` to fill
`^`,`_` or `=` placeholders. Note that if the length of `letters` or `numbers` is smaller than
the number of placeholders in each category, the remaining placeholders will be randomly filled
according to the character in `template`.

# Examples
```@repl
```
"""
function render_alphanumeric(template::AbstractString; numbers = nothing, letters = nothing) :: String
    rendered = ""
    numbers = isnothing(numbers) ? String[] : collect(numbers)
    letters = isnothing(letters) ? String[] : collect(letters)

    for char in template
        rendered *= if char == '#'  # number
            !isempty(numbers) ? popfirst!(numbers) : string(rand(0:9))
        elseif char == '^' # uppercase letters
            !isempty(letters) ? popfirst!(letters) : rand('A':'Z')
        elseif char == '_' # lowercase letter
            !isempty(letters) ? popfirst!(letters) : rand('a':'z')
        elseif char == '=' # lowercase or uppercase letter
            !isempty(letters) ? popfirst!(letters) : rand(filter(isletter, collect('A':'z')))
        else
            char
        end
    end
    return rendered
end



"""
    render_alphanumeric_range(template::AbstractString) :: String

Generate a string containing a number from a *numeric range* template. Such numeric templates may
contain options separated by a `';'` caracter. Additionally, options can assume a single template
format (e.g. `"4##"`) or specify a range using the `':'` character inside the option (e.g. `"2##:3##"`
specifies numbers between 200 and 399).

# Example
```@repl
julia> render_alphanumeric_range("4#####")
"412345"

julia> render_alphanumeric_range("34####;37####")  # will select 34#### or 37####
"349790"

julia> render_alphanumeric_range("51####:55####")
"532489"

julia> render_alphanumeric_range("2221##:2720##;51####:55####")  # will select 2221##:2720## or 51####:55####
"250000"
```
"""
function render_alphanumeric_range(template::AbstractString) :: String
    selected_format = rand(split(template, ';'))

    # selected format has a range specifier e.g. 34####:39####
    if ':' in selected_format
        first, last = split(selected_format, ':')
        lower_limit = parse(Int, replace(first, '#' => '0'))
        upper_limit = parse(Int, replace(last, '#' => '9'))
        selected_format = rand(lower_limit:upper_limit) |> string
    else
        selected_format = render_alphanumeric(selected_format)
    end

    return selected_format
end



"""
    render_template(template locale) :: String
    render_template(template, reference_dfrow; locale) :: String

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

julia> render_template(template; locale="en_US")
"Charles Fraser Anthropologyst"

julia> template = "I know firstname surname, this person is a(n) occupation";

julia> render_template(template; locale="en_US")
"I know Charles Jameson, this person is a(n) Mathematician"
```

## Missing Tokens
```@repl
julia> template = "firstname lastname"  # not that there is no such 'lastname' function
"firstname lastname"

julia> render_template(template; locale="en_US")
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

julia> render_template(template, dfrow; locale = "en_US")
"I live in San Francisco (California)"
```
"""
function render_template(template::String, reference_dfrow::DataFrames.DataFrameRow; locale::String) :: String
    rendered = ""

    for t in tokenize(template) 
        token = string(t)

        # references to dataframe columns (not necessarily the names exported by the packages)
        if token in names(reference_dfrow)
            rendered *= reference_dfrow[token]
        # references to names exported by the package
        elseif Symbol(token) in names(Impostor)
            # 'string' is necessary here because some functions return numbers, which cannot be
            # concatenated to strings without an explicit conversion
            rendered *= getproperty(Impostor, Symbol(token))(1; locale = [locale]) |> string
        # other tokens should be repeated in the rendered string
        else
            rendered *= token
        end
    end
    return rendered
end

function render_template(template::String; locale::String) :: String
    rendered = ""

    for token in tokenize(convert(String, template))
        if Symbol(token) in names(Impostor)
            # the locale must be passed to the function  as a list of strings,
            # even when there is excactly one locale to be fetched
            rendered *= getproperty(Impostor, Symbol(token))(1; locale = [locale])
        elseif token != '\n'
            rendered *= string(token)
        end
    end
    return rendered
end
