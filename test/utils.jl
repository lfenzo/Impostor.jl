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


function _test_all_unique(provider::String, content::String, locale::String; column::Symbol)
    is_locale_available(provider, content, locale) && @testset "$content" begin
        df = Impostor._load!(provider, content, locale)
        @test allunique(df, column)
    end
end
