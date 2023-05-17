@testset "Country-related" begin
    for func in [Impostor.country, Impostor.country_code]
        N = 10
        locale = ["en_US", "pt_BR"]

        @testset "$func" begin
            @testset "$OPTIONLESS" begin
                loaded = func(N; locale = locale)
                @test loaded isa Vector{<:AbstractString}
                @test length(loaded) == N

                @test func(; locale) isa String
            end

            country_code_mask = ["BRA", "USA", "USA", "BRA", "BRA", "USA"]

            @testset "$OPTION_LOADING" begin
                loaded = func(unique(country_code_mask), N; locale = locale)
                @test loaded isa Vector{<:AbstractString}
                @test length(loaded) == N
            end

            @testset "$MASK_LOADING" begin
                loaded = func(country_code_mask; locale = locale)
                @test loaded isa Vector{<:AbstractString}
                @test length(loaded) == length(country_code_mask)

                @test func([country_code_mask[begin]]; locale) isa String
            end
        end
    end
end


@testset "State-related" begin
    for func in [Impostor.state, Impostor.state_code]
        N = 10
        locale = ["en_US", "pt_BR"]

        @testset "$func" begin
            @testset "$OPTIONLESS" begin
                loaded = func(N; locale = locale)
                @test loaded isa Vector{<:AbstractString}
                @test length(loaded) == N

                @test func(; locale) isa String
            end

            country_code_mask = ["BRA", "USA", "USA", "BRA", "BRA", "USA"]
            state_code_mask = ["CA", "IL", "SP", "SP", "RJ", "PR"]

            for (mask, level) in [(country_code_mask, :country_code), (state_code_mask, :state_code)]
                @testset "$OPTION_LOADING ($level)" begin
                    loaded = func(unique(mask), N; optionlevel = level, locale = locale)
                    @test loaded isa Vector{<:AbstractString}
                    @test length(loaded) == N
                end

                @testset "$MASK_LOADING ($level)" begin
                    loaded = func(mask; masklevel = level, locale = locale)
                    @test loaded isa Vector{<:AbstractString}
                    @test length(loaded) == length(mask)

                    @test func([mask[begin]]; masklevel = level, locale) isa String
                end
            end
        end
    end
end


@testset "city" begin
    N = 10
    locale = ["en_US", "pt_BR"]

    @testset "$OPTIONLESS" begin
        loaded = city(N; locale = locale)
        @test loaded isa Vector{<:AbstractString}
        @test length(loaded) == N

        @test city(; locale) isa String
    end

    country_code_mask = ["BRA", "USA", "USA", "BRA", "BRA", "USA"]
    state_code_mask = ["CA", "IL", "SP", "SP", "RJ", "PR"]
    city_name_mask = ["Chicago", "Los Angeles", "San Francisco", "São Paulo", "Curitiba", "Curitiba", "Chicago"]

    test_iterator = [
        (country_code_mask, :country_code),
        (state_code_mask, :state_code),
        (city_name_mask, :city_name)
    ]

    for (mask, level) in test_iterator
        @testset "$OPTION_LOADING ($level)" begin
            loaded = city(unique(mask), N; optionlevel = level, locale = locale)
            @test loaded isa Vector{<:AbstractString}
            @test length(loaded) == N
        end

        @testset "$MASK_LOADING ($level)" begin
            loaded = city(mask; masklevel = level, locale = locale)
            @test loaded isa Vector{<:AbstractString}
            @test length(loaded) == length(mask)

            @test city([mask[begin]]; masklevel = level, locale) isa String
        end
    end
end


@testset "district" begin
    N = 10
    locale = ["en_US", "pt_BR"]

    @testset "$OPTIONLESS" begin
        loaded = district(N; locale = locale)
        @test loaded isa Vector{<:AbstractString}
        @test length(loaded) == N

        @test district(; locale) isa String
    end

    country_code_mask = ["BRA", "USA", "USA", "BRA", "BRA", "USA"]
    state_code_mask = ["CA", "IL", "SP", "SP", "RJ", "PR"]
    city_name_mask = ["Chicago", "Los Angeles", "San Francisco", "São Paulo", "Curitiba", "Curitiba", "Chicago"]
    district_name_mask = ["São Paulo District", "Chicago District", "Los Angeles District", "Curitiba District"]

    test_iterator = [
        (country_code_mask, :country_code),
        (state_code_mask, :state_code),
        (city_name_mask, :city_name),
        (district_name_mask, :district_name)
    ]

    for (mask, level) in test_iterator
        @testset "$OPTION_LOADING ($level)" begin
            loaded = district(unique(mask), N; optionlevel = level, locale = locale)
            @test loaded isa Vector{<:AbstractString}
            @test length(loaded) == N
        end

        @testset "$MASK_LOADING ($level)" begin
            loaded = district(mask; masklevel = level, locale = locale)
            @test loaded isa Vector{<:AbstractString}
            @test length(loaded) == length(mask)

            @test district([mask[begin]]; masklevel = level, locale) isa String
        end
    end
end
