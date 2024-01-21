@testset "Data Loading" begin

    resetlocale!()

    @testset "No-Locale (noloc)" begin
        available_values = _test_load("localization", "locale", "noloc")
        loaded = Impostor._load!("localization", "locale")

        @test loaded isa DataFrame
        @test available_values == loaded
    end

    @testset "Single Locale" begin
        available_values = _test_load("identity", "occupation", only(session_locale()))
        loaded = Impostor._load!("identity", "occupation", only(session_locale()))

        @test loaded isa DataFrame
        @test available_values == loaded
    end

    @testset "Multiple Locales" begin
        locales = ["pt_BR", "en_US"]

        df = DataFrame()
        available_values = _test_load("identity", "firstname", locales)

        for key in keys(available_values)
            append!(df, available_values[key]; promote = true) 
        end

        loaded = Impostor._load!("identity", "firstname", locales)

        @test loaded isa DataFrame
        @test sort(df, ["sex", "firstname"]) == sort(loaded, ["sex", "firstname"])
    end
end


@testset "Data Loading Auxiliary Functions" begin

    @test is_provider_available("identity")
    @test !is_provider_available("indentity")  # typo in 'identity' on purpose

    @test is_content_available("identity", "firstname")
    @test !is_content_available("identity", "fisrtname")  # typo in 'firstname' on purpose

    @test is_locale_available("identity", "firstname", "en_US")
    @test !is_locale_available("identity", "firstname", "xx_XX")
end
