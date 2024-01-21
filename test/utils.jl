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
