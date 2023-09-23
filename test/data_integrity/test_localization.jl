@testset "Localization" begin
    for locale in ALL_LOCALES
        locale_exists("localization", "locale", locale) && @testset "[$locale] locale" begin
            df = Impostor._load!("localization", "locale", locale)
            @test allunique(df, :locale)
            @test uppercase.(df[:, :country_code]) |> allunique
        end

        locale_exists("localization", "country", locale) && @testset "[$locale] country" begin
            df = Impostor._load!("localization", "country", locale)
            @test allunique(df, :country_name)
            @test allunique(df, :official_country_name)
            @test (df[:, :locale] .== locale) |> all
        end

        locale_exists("localization", "state", locale) && @testset "[$locale] state" begin
            df = Impostor._load!("localization", "state", locale)
            @test allunique(df, :state_name)
            @test uppercase.(df[:, :state_code]) |> allunique
        end

        locale_exists("localization", "city", locale) && @testset "[$locale] city" begin
            df = Impostor._load!("localization", "city", locale)
            @test allunique(df, :city_name)
        end

        locale_exists("localization", "district", locale) && @testset "[$locale] district" begin
            df = Impostor._load!("localization", "district", locale)
            @test allunique(df, :district_name)
        end

        locale_exists("localization", "street_prefix", locale) && @testset "[$locale] street_prefix" begin
            df = Impostor._load!("localization", "street_prefix", locale)
            @test allunique(df, :street_prefix)
        end

        locale_exists("localization", "street_suffix", locale) && @testset "[$locale] street_suffix" begin
            df = Impostor._load!("localization", "street_suffix", locale)
            @test allunique(df, :street_suffix)
        end

        locale_exists("localization", "street_format", locale) && @testset "[$locale] street_format" begin
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