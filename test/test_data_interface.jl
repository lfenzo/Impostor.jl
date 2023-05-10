@testset "Data Loading" begin

    resetlocale!()

    @testset "No-Locale (noloc)" begin
        available_values = _test_load("localization", "locale", "noloc")
        loaded = Impostor.load!("localization", "locale")

        @test loaded isa DataFrame
        @test available_values == loaded
    end

    @testset "Single Locale" begin
        available_values = _test_load("identity", "occupation", only(getlocale()))
        loaded = Impostor.load!("identity", "occupation", only(getlocale()))

        @test loaded isa DataFrame
        @test available_values == loaded
    end

    @testset "Multiple Locales" begin
        locales = ["pt_BR", "en_US"]  # TOOO add more locales later on

        available_values = _test_load("identity", "firstname", locales)
        loaded = Impostor.load!("identity", "firstname", locales)

        df = DataFrame()
        for key in keys(available_values)
            append!(df, available_values[key]) 
        end

        @test loaded isa DataFrame
        @test sort(df, ["sex", "firstname"]) == sort(loaded, ["sex", "firstname"])
    end
end


@testset "Auxiliary Functions" begin

    @test provider_exists("identity")
    @test !provider_exists("indentity")  # typo in 'identity' on purpose

    @test content_exists("identity", "firstname")
    @test !content_exists("identity", "fisrtname")  # typo in 'firstname' on purpose

    @test locale_exists("identity", "firstname", "en_US")
    @test !locale_exists("identity", "fisrtname", "en_US")  # typo in 'firstnames' on purpose
end
