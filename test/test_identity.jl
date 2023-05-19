@testset "bloodtype" begin
    N = 10

    @testset "$OPTIONLESS" begin
        blood = bloodtype(N)
        @test blood isa Vector{<:AbstractString}
        @test length(blood) == N

        @test bloodtype() isa String
    end
end


@testset "birthdate" begin
    N = 10

    @testset "$OPTIONLESS" begin
        birth = birthdate(N)
        @test birth isa Vector{<:AbstractString}
        @test length(birth) == N

        @test birthdate() isa String
    end
end


@testset "surname" begin
    N = 10

    @testset "$OPTIONLESS" begin
        birth = surname(N)
        @test birth isa Vector{<:AbstractString}
        @test length(birth) == N

        @test surname() isa String
    end
end


@testset "highshcool" begin
    N = 10
    locale = ["en_US", "pt_BR"]

    @testset "$OPTIONLESS" begin
        highschools = highschool(N; locale = locale)
        @test highschools isa Vector{<:AbstractString}
        @test length(highschools) == N

        @test highschool(; locale = locale) isa AbstractString
    end
end


for func in [Impostor.prefix, Impostor.firstname, Impostor.complete_name]
    @testset "$func" begin
        N = 10
        locale = ["en_US", "pt_BR"]
        mask = ["M", "M", "F", "F", "M"]

        @testset "$OPTIONLESS" begin
            loaded = func(N; locale = locale)
            @test loaded isa Vector{<:AbstractString}
            @test length(loaded) == N

            @test func(; locale) isa String
        end

        @testset "$OPTION_LOADING" begin
            loaded = func(unique(mask), N; locale = locale)
            @test loaded isa Vector{<:AbstractString}
            @test length(loaded) == N
        end

        @testset "$MASK_LOADING" begin
            loaded = func(mask; locale = locale)
            @test loaded isa Vector{<:AbstractString}
            @test length(loaded) == length(mask)

            @test func([mask[begin]]; locale) isa String
        end
    end
end


for func in [Impostor.occupation, Impostor.university]
    @testset "$func" begin
        N = 10
        locale = ["en_US", "pt_BR"]
        mask = ["business", "military", "humanities", "social-sciences", "military", "humanities"]

        @testset "$OPTIONLESS" begin
            loaded = func(N; locale = locale)
            @test loaded isa Vector{<:AbstractString}
            @test length(loaded) == N

            @test func(; locale) isa String
        end

        @testset "$OPTION_LOADING" begin
            loaded = func(unique(mask), N; locale = locale)
            @test loaded isa Vector{<:AbstractString}
            @test length(loaded) == N
        end

        @testset "$MASK_LOADING" begin
            loaded = func(mask; locale = locale)
            @test loaded isa Vector{<:AbstractString}
            @test length(loaded) == length(mask)

            @test func([mask[begin]]; locale) isa String
        end
    end
end
