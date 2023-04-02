@testset "country" begin

    N = 10

    @testset "$OPTIONLESS" begin
        available_values = _test_load("country", "localization", only(getlocale()))
        @test Impostor.country() isa String
        countries = Impostor.country(N)
        @test length(countries) == N
        @test countries isa Vector{String}
        @test all([c in available_values for c in countries])
    end

    @testset "$OPTIONLESS ignoring the Locale (All Avaliable Countries)" begin
        countries = Impostor.country(N; ignore_locale = true)
        @test length(countries) == N
        @test countries isa Vector{String}
    end
end

@testset "state" begin

    N = 10
    locales = ["en_US", "pt_BR"]
    option_mask = ["en_US", "en_US", "pt_BR", "en_US", "pt_BR", "pt_BR"]
    available_values = _test_load("city", "localization", locales)

    @testset "$OPTIONLESS" begin
        states = Impostor.state(N)
        @test states isa Vector{String}
        @test length(states) == N
        @test Impostor.state() isa String
    end

    @testset "$OPTION_LOADING" begin
        states = Impostor.state(locales, N)
        @test states isa Vector{String}
        @test length(states) == N
        for loc in locales
            # remember that for the 'state' content there is only one key in the .json file with
            # all the entries for states
            @test all([value in values(available_values[loc]["state"]) for value in states])
        end
    end

#    @testset "$MASK_LOADING" begin
#        cities = Impostor.city(option_mask)
#        @test cities isa Vector{String}
#        @test length(cities) == length(option_mask)
#        @test all([l in available_values[state] for (l, state) in zip(cities, option_mask)])
#    end
end



#@testset "city" begin
#
#    N = 10
#    option_mask = ["IL", "CA", "CA", "CA", "IL"]
#    available_values = _test_load("city", "localization", only(getlocale()))
#
#    @testset "$OPTIONLESS" begin
#        cities = Impostor.city(N)
#        @test cities isa Vector{String}
#        @test length(cities) == N
#        @test Impostor.city() isa String
#    end
#
#    @testset "$OPTION_LOADING" begin
#        state = "IL"
#        cities = Impostor.city([state], N)
#        @test cities isa Vector{String}
#        @test length(cities) == N
#        @test all([value in available_values[state] for value in cities])
#    end
#
#    @testset "$MASK_LOADING" begin
#        cities = Impostor.city(option_mask)
#        @test cities isa Vector{String}
#        @test length(cities) == length(option_mask)
#        @test all([l in available_values[state] for (l, state) in zip(cities, option_mask)])
#    end
#end


