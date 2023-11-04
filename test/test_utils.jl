@testset "coerse_string_type" begin
    returned_value = ["foo", "bar"]
    @test Impostor.coerse_string_type(returned_value) == ["foo", "bar"]

    returned_value = ["bar"]
    @test Impostor.coerse_string_type(returned_value) == "bar"
end

@testset "render_alphanumeric" begin
    template = "1111-###-^^^-____-====" 
    rendered = render_alphanumeric(template)
    bool_test_mask = Bool[]

    for (rendered, original) in zip(rendered, template)
        if original == '#'
            push!(bool_test_mask, isdigit(rendered))
        elseif original == '^'
            push!(bool_test_mask, isuppercase(rendered))
        elseif original == '_'
            push!(bool_test_mask, islowercase(rendered))
        elseif original == '='
            push!(bool_test_mask, islowercase(rendered) || isuppercase(rendered))
        else  
            push!(bool_test_mask, rendered == original)
        end
    end
    @test all(bool_test_mask)
end
