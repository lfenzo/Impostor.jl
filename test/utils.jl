const ASSETS_ROOT::String = pkgdir(Impostor, "src", "data")


function _test_load(provider::String, content::String, locale::String)
    return CSV.read(
        joinpath(ASSETS_ROOT, provider, content, locale * ".csv"), DataFrame;
        header = joinpath(ASSETS_ROOT, provider, content, "HEADER.txt") |> readlines
    )
end

function _test_load(provider::String, content::String, locale::Vector{String})
    return Dict(loc => _test_load(provider, content, loc) for loc in locale)
end

"""
    _get_all_locales(; root::AbstractString) :: Vector{String}

Retrieve a list of all unique locales (inclusing the "noloc" locale) available in all providers
"""
function _get_all_locales(; root::AbstractString) :: Vector{String}
    to_skip = ["HEADER"]
    unique_locales = Set{String}()
    for (_, _, files) in walkdir(root)
        for filename in files
            locale = first(split(filename, '.'))
            !(locale in to_skip) && push!(unique_locales, locale)
        end
    end
    return collect(unique_locales)
 end
