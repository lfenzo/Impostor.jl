@testset "coerse_string_type" begin
    returned_value = ["foo", "bar"]
    @test Impostor.coerse_string_type(returned_value) isa Vector{<:AbstractString}

    returned_value = [ "bar"]
    @test Impostor.coerse_string_type(returned_value) isa String
end


@testset "_materialize_numeric_template" begin

    @testset "All no pre-defined digits" begin
        template = "###-###-####" 
        materialized_string = Impostor._materialize_numeric_template(template)

        bool_test_mask = Bool[]
        for (materialized, original) in zip(materialized_string, template)
            original == '#' && push!(bool_test_mask, isdigit(materialized))
        end
        @test bool_test_mask |> all
    end

    @testset "Some pre-defined digits" begin
        template = "(15) 9###-##3#" 
        materialized_string = Impostor._materialize_numeric_template(template)

        bool_test_mask = Bool[]
        for (materialized, original) in zip(materialized_string, template)
            original == '#' && push!(bool_test_mask, isdigit(materialized))
        end
        @test bool_test_mask |> all
    end
end
