const IDENTITY_PROVIDER::String = "identity"


sex_dependent_functions = Dict{Function, String}(
    Impostor.firstname => "firstname", 
    Impostor.prefix => "prefix",
)

for (func, content) in sex_dependent_functions
    @testset "$(string(func))" begin 
        N = 10
        option_mask = ["male", "female", "female", "male", "female"]
        available_values = _test_load(content, IDENTITY_PROVIDER, only(getlocale()))

        @testset "$OPTIONLESS" begin
            loaded = func(N)
            @test loaded isa Vector{String}
            @test length(loaded) == N
        end

        @testset "$OPTION_LOADING" begin
            sex = "female"
            loaded = func([sex], N)
            @test loaded isa Vector{String}
            @test length(loaded) == N
            @test all([value in available_values[sex] for value in loaded])
        end

        @testset "$MASK_LOADING" begin
            loaded = func(option_mask)
            @test loaded isa Vector{String}
            @test length(loaded) == length(option_mask)
            @test all([l in available_values[sex] for (l, sex) in zip(loaded, option_mask)])
        end
    end
end


knowledge_fields_dependent_functions = Dict{Function, String}(
    Impostor.occupation => "occupation", 
    Impostor.university => "university",
)

for (func, content) in knowledge_fields_dependent_functions
    @testset "$(string(func))" begin 
        N = 10
        option_mask = ["humanities", "business", "public-administration", "formal-sciences"]
        available_values = _test_load(content, IDENTITY_PROVIDER, only(getlocale()))

        @testset "$OPTIONLESS" begin
            loaded = func(N)
            @test loaded isa Vector{String}
            @test length(loaded) == N
        end

        @testset "$OPTION_LOADING" begin
            fields = ["business", "humanities"]
            loaded = func(fields, N)
            @test loaded isa Vector{String}
            @test length(loaded) == N
            @test all([any(broadcast((v) -> val in v, [available_values[f] for f in fields])) for val in loaded])
        end

        @testset "$MASK_LOADING" begin
            loaded = func(option_mask)
            @test loaded isa Vector{String}
            @test length(loaded) == length(option_mask)
            @test all([l in available_values[field] for (l, field) in zip(loaded, option_mask)])
        end
    end
end


@testset "Surnames" begin 
    N = 10
    @testset "$OPTIONLESS" begin
        surnames = surname(N)
        @test surnames isa Vector{String}
        @test length(surnames) == N
    end
end
