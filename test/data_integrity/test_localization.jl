@testset "Localization" begin
    for locale in ALL_LOCALES
        @testset "[$locale]" begin
            
            _test_all_unique("localization", "address_complement", locale; columns=[:address_complement], case_sensitive=true)
            _test_all_unique("localization", "address_format", locale; columns=[:address_format], case_sensitive=true)
            _test_all_unique("localization", "locale", locale; columns=[:locale, :country_code], case_sensitive=true)
            _test_all_unique("localization", "state", locale; columns=[:state, :state_code], case_sensitive=true)
            _test_all_unique("localization", "district", locale; columns=[:district])
            _test_all_unique("localization", "street_prefix", locale; columns=[:street_prefix])
            _test_all_unique("localization", "street_suffix", locale; columns=[:street_suffix])

            is_locale_available("localization", "country", locale) && @testset "country" begin
                df = Impostor._load!("localization", "country", locale)
                @test allunique(df, :country)
                @test allunique(df, :country_official_name)
                @test (df[:, :locale] .== locale) |> all
            end

            is_locale_available("localization", "city", locale) && @testset "city" begin
                df = Impostor._load!("localization", "city", locale)
                @test allunique(df, [:state_code, :city])
            end

            is_locale_available("localization", "street_format", locale) && @testset "street_format" begin
                df = Impostor._load!("localization", "street_format", locale)
                @test allunique(df, :street_format)
                for row in eachrow(df)
                    for token in split(row[:street_format], " ")
                        @test Symbol(token) in names(Impostor)
                    end
                end
            end
        end
    end
end
