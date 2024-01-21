@testset "Identity" begin
    for locale in ALL_LOCALES
        @testset "[$locale]" begin
            is_locale_available("identity", "highschool", locale) && @testset "highschool" begin
                df = Impostor._load!("identity", "highschool", locale)
                @test allunique(df, :highschool)
            end

            is_locale_available("identity", "surname", locale) && @testset "surname" begin
                df = Impostor._load!("identity", "surname", locale)
                @test titlecase.(df[:, :surname]) |> allunique
            end

            is_locale_available("identity", "nationality", locale) && @testset "nationality" begin
                df = Impostor._load!("identity", "nationality", locale)
                country_codes = Impostor._load!("localization", "country", locale)[:, :country_code]
                @test Set(df[:, :sex]) == Set(SEXES[:options])
                @test all([code in country_codes for code in df[:, :country_code]])
            end

            # functions using SEX as data restriction
            for func in [prefix, firstname]
                is_locale_available("identity", string(func), locale) && @testset "$func" begin
                    df = Impostor._load!("identity", string(func), locale)
                    @test allunique(df, Symbol(func))
                    @test sort(unique(df[:, :sex])) == sort(SEXES[:options])
                end
            end

            # functions using KNOWLEDGE_FIELD as data restriction
            for func in [university, occupation]
                is_locale_available("identity", string(func), locale) && @testset "$func" begin
                    df = Impostor._load!("identity", string(func), locale)
                    @test allunique(df, Symbol(func))
                    @test sort(unique(df[:, :knowledge_field])) == sort(KNOWLEDGE_FIELDS[:options])
                end
            end
        end
    end
end
