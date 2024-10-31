"""
Set of utilities to be used during tests (not to be confused with src/utils.jl unit tests)
"""
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



function _test_all_unique(
    provider::String, content::String, locale::String; columns::Vector{Symbol}, case_sensitive::Bool = false
)
    is_locale_available(provider, content, locale) && @testset "$content" begin
        df = Impostor._load!(provider, content, locale)
        for c in columns
            if case_sensitive
                df[:, c] = uppercase.(df[:, c])
            end
            @test allunique(df, c)
        end
    end
end
