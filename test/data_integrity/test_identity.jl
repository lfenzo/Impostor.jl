@testset "Identity" begin
    for locale in ALL_LOCALES
        @testset "[$locale]" begin

            _test_all_unique("identity", "highschool", locale; column = :highschool)
            _test_all_unique("identity", "surname", locale; column = :surname)

            is_locale_available("identity", "nationality", locale) && @testset "nationality" begin
                df = Impostor._load!("identity", "nationality", locale)
                country_codes = Impostor._load!("localization", "country", locale)[:, :country_code]
                @test Set(df[:, :sex]) == Set(SEXES[:options])
                @test all([code in country_codes for code in unique(df[:, :country_code])])
            end

            # functions using SEX as data restriction
            for func in [prefix, firstname]
                is_locale_available("identity", string(func), locale) && @testset "$func" begin
                    df = Impostor._load!("identity", string(func), locale)
                    @test Set(df[:, :sex]) == Set(SEXES[:options])
                end
            end

            # functions using KNOWLEDGE_FIELD as data restriction
            for func in [university, occupation]
                is_locale_available("identity", string(func), locale) && @testset "$func" begin
                    df = Impostor._load!("identity", string(func), locale)
                    @test allunique(df, Symbol(func))
                    @test Set(df[:, :knowledge_field]) == Set(KNOWLEDGE_FIELDS[:options])
                end
            end
        end
    end
end
