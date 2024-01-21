@testset "Localization" begin
    for locale in ALL_LOCALES
        @testset "[$locale]" begin
            is_locale_available("localization", "address_complement", locale) && @testset "address_complement" begin
                df = Impostor._load!("localization", "address_complement", locale)
                @test uppercase.(df[:, :address_complement]) |> allunique
            end

            is_locale_available("localization", "address_format", locale) && @testset "address_format" begin
                df = Impostor._load!("localization", "address_format", locale)
                @test uppercase.(df[:, :address_format]) |> allunique
            end

            is_locale_available("localization", "locale", locale) && @testset "locale" begin
                df = Impostor._load!("localization", "locale", locale)
                @test allunique(df, :locale)
                @test uppercase.(df[:, :country_code]) |> allunique
            end

            is_locale_available("localization", "country", locale) && @testset "country" begin
                df = Impostor._load!("localization", "country", locale)
                @test allunique(df, :country)
                @test allunique(df, :country_official_name)
                @test (df[:, :locale] .== locale) |> all
            end

            is_locale_available("localization", "state", locale) && @testset "state" begin
                df = Impostor._load!("localization", "state", locale)
                @test allunique(df, :state)
                @test uppercase.(df[:, :state_code]) |> allunique
            end

            is_locale_available("localization", "city", locale) && @testset "city" begin
                df = Impostor._load!("localization", "city", locale)
                @test allunique(df, [:state_code, :city])
            end

            is_locale_available("localization", "district", locale) && @testset "district" begin
                df = Impostor._load!("localization", "district", locale)
                @test allunique(df, :district)
            end

            is_locale_available("localization", "street_prefix", locale) && @testset "street_prefix" begin
                df = Impostor._load!("localization", "street_prefix", locale)
                @test allunique(df, :street_prefix)
            end

            is_locale_available("localization", "street_suffix", locale) && @testset "street_suffix" begin
                df = Impostor._load!("localization", "street_suffix", locale)
                @test allunique(df, :street_suffix)
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
