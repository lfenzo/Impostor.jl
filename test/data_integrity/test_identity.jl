@testset "Identity" begin
    for locale in ALL_LOCALES
        locale_exists("identity", "highschool", locale) && @testset "[$locale] highschool" begin
            df = Impostor._load!("identity", "highschool", locale)
            @test allunique(df, :highschool)
        end

        locale_exists("identity", "surname", locale) && @testset "[$locale] surname" begin
            df = Impostor._load!("identity", "surname", locale)
            @test titlecase.(df[:, :surname]) |> allunique
        end

        locale_exists("identity", "nationality", locale) && @testset "[$locale] nationality" begin
            df = Impostor._load!("identity", "nationality", locale)
            country_codes = Impostor._load!("localization", "country", locale)[:, :country_code]
            @test sort(unique(df[:, :sex])) == sort(SEXES[:options])
            @test all([code in country_codes for code in df[:, :country_code]])
        end

        # functions using SEX as data restriction
        for func in [prefix, firstname]
            locale_exists("identity", string(func), locale) && @testset "[$locale] $func" begin
                df = Impostor._load!("identity", string(func), locale)
                @test allunique(df, Symbol(func))
                @test sort(unique(df[:, :sex])) == sort(SEXES[:options])
            end
        end

        # functions using KNOWLEDGE_FIELD as data restriction
        for func in [university, occupation]
            locale_exists("identity", string(func), locale) && @testset "[$locale] $func" begin
                df = Impostor._load!("identity", string(func), locale)
                @test allunique(df, Symbol(func))
                @test sort(unique(df[:, :knowledge_field])) == sort(KNOWLEDGE_FIELDS[:options])
            end
        end
    end
end
