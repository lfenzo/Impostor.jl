@testset "country" begin

    N = 10
    available_values = _test_load("country", "localization", only(getlocale()))

    @testset "$OPTIONLESS" begin
        countries = Impostor.country(N)
        @test length(countries) == N
        @test countries isa Vector{String}
        @test all([c in available_values for c in countries])

        @test Impostor.country() isa String
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
    available_values = _test_load("state", "localization", locales)

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

        states = Impostor.state(N; locale = locales)
        @test states isa Vector{String}
        @test length(states) == N

        let is_correct_match = Bool[]
            for value in states
                # remember that for the 'state' content there is only one key in the .json file with
                # all the entries for states
                push!(
                    is_correct_match,
                    value in values(available_values["en_US"]["en_US"]) || value in values(available_values["pt_BR"]["pt_BR"])
                )
            end
            @test all(is_correct_match)
        end
    end

    @testset "$MASK_LOADING" begin
        states = Impostor.state(option_mask)
        @test states isa Vector{String}
        @test length(states) == length(option_mask)

        let is_correct_match = Bool[]
            for (value, mask_value) in zip(states, option_mask)
                # remember that for the 'state' content there is only one key in the .json file with
                # all the entries for states
                push!(is_correct_match, value in values(available_values[mask_value][mask_value]))
            end
            @test all(is_correct_match)
        end
    end
end


@testset "city" begin

    N = 10
    locale_mask = ["en_US", "pt_BR", "en_US", "en_US", "pt_BR"]
    state_mask = Impostor.state_code(locale_mask)
    available_values = _test_load("city", "localization", ["en_US", "pt_BR"])

    flattened_available_values = String[]
    for locale_key in keys(available_values)
        for state_key in keys(available_values[locale_key])
            push!(flattened_available_values, available_values[locale_key][state_key]...)
        end
    end

    @testset "$OPTIONLESS" begin
        cities = Impostor.city(N)
        @test cities isa Vector{String}
        @test length(cities) == N
        @test Impostor.city() isa String
    end

    @testset "$OPTION_LOADING" begin
        cities = Impostor.city(unique(state_mask), N; locale = unique(locale_mask))
        @test cities isa Vector{String}
        @test length(cities) == N
        @test all([value in flattened_available_values for value in cities])
    end

    @testset "$MASK_LOADING (State Mask)" begin
        cities = Impostor.city(state_mask; masklevel = :state, locale = unique(locale_mask))
        @test cities isa Vector{String}
        @test length(cities) == length(state_mask)
        let is_correct_match = Bool[]
            for (loaded, state, locale) in zip(cities, state_mask, locale_mask)
                @test loaded in available_values[locale][state]
            end
            @test all(is_correct_match)
        end
    end

    @testset "$MASK_LOADING (Locale Mask)" begin
        cities = Impostor.city(locale_mask; masklevel = :locale, locale = unique(locale_mask))
        @test cities isa Vector{String}
        @test length(cities) == length(state_mask)
        let is_correct_match = Bool[]
            for (loaded, state, locale) in zip(cities, state_mask, locale_mask)
                push!(is_correct_match, loaded in available_values[locale][state])
            end
            @test all(is_correct_match)
        end
    end
end


@testset "district" begin

    N = 10
    locale_mask = ["en_US", "pt_BR", "en_US", "en_US", "pt_BR"]
    state_mask = Impostor.state_code(locale_mask)
    city_mask = Impostor.city(state_mask; locale = unique(locale_mask))
    available_values = _test_load("district", "localization", ["en_US", "pt_BR"])

    flattened_available_values = String[]
    for locale_key in keys(available_values)
        for city_key in keys(available_values[locale_key])
            push!(flattened_available_values, available_values[locale_key][city_key]...)
        end
    end

    @testset "$OPTIONLESS" begin
        districts = Impostor.district(N)
        @test districts isa Vector{String}
        @test length(districts) == N
        @test Impostor.district() isa String
    end

    @testset "$OPTION_LOADING (State Option)" begin
        districts = Impostor.district(unique(state_mask), N; option_level = :state, locale = unique(locale_mask))
        @test districts isa Vector{String}
        @test length(districts) == N
        let is_correct_match = Bool[]
            for loaded in districts
                push!(is_correct_match, loaded in flattened_available_values)
            end
            @test all(is_correct_match)
        end
    end

    @testset "$OPTION_LOADING (City Option)" begin
        districts = Impostor.district(unique(city_mask), N; option_level = :city, locale = unique(locale_mask))
        @test districts isa Vector{String}
        @test length(districts) == N
        let is_correct_match = Bool[]
            for loaded in districts
                push!(is_correct_match, loaded in flattened_available_values)
            end
            @test all(is_correct_match)
        end
    end

    @testset "$MASK_LOADING (State Mask)" begin
        districts = Impostor.district(state_mask; masklevel = :state, locale = unique(locale_mask))
        @test districts isa Vector{String}
        @test length(districts) == length(state_mask)
        let is_correct_match = Bool[]
            for (loaded, state, locale) in zip(districts, state_mask, locale_mask)
                push!(is_correct_match, loaded in flattened_available_values)
            end
            @test all(is_correct_match)
        end
    end

    @testset "$MASK_LOADING (City Mask)" begin
        districts = Impostor.district(city_mask; masklevel = :city, locale = unique(locale_mask))
        @test districts isa Vector{String}
        @test length(districts) == length(city_mask)
        let is_correct_match = Bool[]
            for (loaded, city, locale) in zip(districts, city_mask, locale_mask)
                push!(is_correct_match, loaded in available_values[locale][city])
            end
            @test all(is_correct_match)
        end
    end
end
