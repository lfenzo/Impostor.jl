@testset "Identity" begin
    for locale in ALL_LOCALES
        locale_exists("identity", "highschool", locale) && @testset "highschool" begin
            df = Impostor.load!("identity", "highschool", locale)
            @test allunique(df, :highschool)
        end

        locale_exists("identity", "surname", locale) && @testset "surname" begin
            df = Impostor.load!("identity", "surname", locale)
            @test allunique(df, :surname)
        end

        # functions using SEX as data restriction
        for func in [prefix, firstname]
            locale_exists("identity", string(func), locale) && @testset "$func" begin
                df = Impostor.load!("identity", string(func), locale)
                @test allunique(df, Symbol(func))
                @test sort(unique(df[:, :sex])) == sort(SEXES[:options])
            end
        end

        # functions using KNOWLEDGE_FIELD as data restriction
        for func in [university, occupation]
            locale_exists("identity", string(func), locale) && @testset "$func" begin
                df = Impostor.load!("identity", string(func), locale)
                @test allunique(df, Symbol(func))
                @test sort(unique(df[:, :knowledge_field])) == sort(KNOWLEDGE_FIELDS[:options])
            end
        end
    end
end


@testset "Localization" begin
    for locale in ALL_LOCALES
        locale_exists("localization", "locale", locale) && @testset "[$locale] locale" begin
            df = Impostor.load!("localization", "locale", locale)
            @test allunique(df, :locale)
            @test allunique(df, :country_code)
        end

        locale_exists("localization", "country", locale) && @testset "[$locale] country" begin
            df = Impostor.load!("localization", "country", locale)
            @test allunique(df, :country_name)
            @test allunique(df, :official_country_name)
            @test (df[:, :locale] .== locale) |> all
        end

        locale_exists("localization", "state", locale) && @testset "[$locale] state" begin
            df = Impostor.load!("localization", "state", locale)
            @test allunique(df, :state_code)
            @test allunique(df, :state_name)
        end

        locale_exists("localization", "city", locale) && @testset "[$locale] city" begin
            df = Impostor.load!("localization", "city", locale)
            @test allunique(df, :city_name)
        end

        locale_exists("localization", "district", locale) && @testset "[$locale] district" begin
            df = Impostor.load!("localization", "district", locale)
            @test allunique(df, :district_name)
        end

        locale_exists("localization", "street_prefix", locale) && @testset "[$locale] street_prefix" begin
            df = Impostor.load!("localization", "street_prefix", locale)
            @test allunique(df, :street_prefix)
        end

        locale_exists("localization", "street_suffix", locale) && @testset "[$locale] street_suffix" begin
            df = Impostor.load!("localization", "street_suffix", locale)
            @test allunique(df, :street_suffix)
        end

        locale_exists("localization", "street_format", locale) && @testset "[$locale] street_format" begin
            df = Impostor.load!("localization", "street_format", locale)
            @test allunique(df, :street_format)
            for row in eachrow(df)
                for token in split(row[:street_format], " ")
                    @test Symbol(token) in names(Impostor)
                end
            end
        end
    end
end

