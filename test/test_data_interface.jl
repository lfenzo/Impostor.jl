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

    @test provider_exists("identity")
    @test !provider_exists("indentity")  # typo in 'identity' on purpose

    @test content_exists("identity", "firstname")
    @test !content_exists("identity", "fisrtname")  # typo in 'firstname' on purpose

    @test locale_exists("identity", "firstname", "en_US")
    @test !locale_exists("identity", "fisrtname", "en_US")  # typo in 'firstnames' on purpose
end
