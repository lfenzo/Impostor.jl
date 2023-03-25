sex_dependent_functions = Dict{Function, String}(
    Impostor.firstname => "firstname", 
    Impostor.prefix => "prefix",
)

for (func, content) in sex_dependent_functions
    @testset "$(string(func))" begin 
        N = 10
        option_mask = ["male", "female", "female", "male", "female"]
        available_values = _test_load(content, "identity", only(getlocale()))

        @testset "$OPTIONLESS" begin
            generated = func(N)
            @test generated isa Vector{String}
            @test length(generated) == N
            @test func() isa String
        end

        @testset "$OPTION_LOADING" begin
            sex = "female"
            generated = func([sex], N)
            @test generated isa Vector{String}
            @test length(generated) == N
            @test all([value in available_values[sex] for value in generated])
        end

        @testset "$MASK_LOADING" begin
            generated = func(option_mask)
            @test generated isa Vector{String}
            @test length(generated) == length(option_mask)
            @test all([l in available_values[sex] for (l, sex) in zip(generated, option_mask)])
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
        available_values = _test_load(content, "identity", only(getlocale()))

        @testset "$OPTIONLESS" begin
            generated = func(N)
            @test generated isa Vector{String}
            @test length(generated) == N
            @test func() isa String
        end

        @testset "$OPTION_LOADING" begin
            fields = ["business", "humanities"]
            generated = func(fields, N)
            @test generated isa Vector{String}
            @test length(generated) == N
            @test all([any(broadcast((v) -> val in v, [available_values[f] for f in fields])) for val in generated])
        end

        @testset "$MASK_LOADING" begin
            generated = func(option_mask)
            @test generated isa Vector{String}
            @test length(generated) == length(option_mask)
            @test all([g in available_values[field] for (g, field) in zip(generated, option_mask)])
        end
    end
end


@testset "fullname" begin 
    N = 10
    option_mask = ["male", "female", "female", "male", "female"]
    available_values = _test_load("firstname", "identity", only(getlocale()))

    @testset "$OPTIONLESS" begin
        generated = Impostor.fullname(N)
        @test generated isa Vector{String}
        @test length(generated) == N
        @test Impostor.fullname() isa String
    end

    @testset "$OPTION_LOADING" begin
        sex = "female"
        generated = Impostor.fullname([sex], N)
        @test generated isa Vector{String}
        @test length(generated) == N
        @test all([first(split(value, " ")) in available_values[sex] for value in generated])
    end

    @testset "$MASK_LOADING" begin
        generated = Impostor.fullname(option_mask)
        @test generated isa Vector{String}
        @test length(generated) == length(option_mask)
        @test all([first(split(g, " ")) in available_values[sex] for (g, sex) in zip(generated, option_mask)])
    end
end


@testset "surname" begin 
    N = 10
    @testset "$OPTIONLESS" begin
        generated = surname(N)
        @test generated isa Vector{String}
        @test length(generated) == N
        @test surname() isa String
    end
end


@testset "highschool" begin 
    N = 10
    @testset "$OPTIONLESS" begin
        generated = highschool(N)
        @test generated isa Vector{String}
        @test length(generated) == N
        @test highschool() isa String
    end
end
