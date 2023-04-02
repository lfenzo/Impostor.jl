@testset "Identity" begin

    for locale in ALL_LOCALES
        for func in SEXES[:provider_functions]
            content_exists(locale, "identity", string(func)) && @testset "$func" begin
                loaded = _test_load(string(func), "identity", locale)
                @test [allunique(loaded[sex]) for sex in SEXES[:options]] |> all
                @test vcat([loaded[opt] for opt in SEXES[:options]]...) |> allunique
            end
        end

        for func in KNOWLEDGE_FIELDS[:provider_functions]
            content_exists(locale, "identity", string(func)) && @testset "$func" begin
                loaded = _test_load(string(func), "identity", locale)
                @test [allunique(loaded[sex]) for sex in KNOWLEDGE_FIELDS[:options]] |> all
            end
        end

        content_exists(locale, "identity", "surname") && @testset "surname" begin
            @test allunique(_test_load("surname", "identity", locale))
        end

        content_exists(locale, "identity", "highschool") && @testset "highschool" begin
            @test allunique(_test_load("highschool", "identity", locale))
        end
    end
end


@testset "Localization" begin
    for locale in ALL_LOCALES
        content_exists(locale, "localization", "city") && @testset "city" begin
            @test allunique(_test_load("city", "localization", locale))
        end
    end
end

