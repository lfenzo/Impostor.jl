const ASSETS_ROOT::String = pkgdir(Impostor, "src", "data")


function _test_load(content::String, provider::String, locale::String)
    open(joinpath(ASSETS_ROOT, locale, provider, content) * ".json", "r") do file
        return JSON3.read(file, Dict{String, Union{Dict, Vector{String}}})[content]
    end
end
