@testset "Data Loading" begin

    resetlocale!()
    option_mask = ["humanities", "business", "public-administration", "formal-sciences"]
    content = "occupation"
    provider = "identity"
    available_values = _test_load(content, "identity", only(getlocale()))

    @testset "$OPTIONLESS" begin
        loaded = Impostor.load!(content, provider; options = unique(option_mask))
        @test loaded isa Vector{String}
    end

    @testset "$OPTION_LOADING" begin
        fields = ["business", "humanities", "formal-sciences"]
        loaded = Impostor.load!(content, provider, options = fields)
        @test loaded isa Vector{String}
        @test all([any(broadcast((v) -> val in v, [available_values[f] for f in fields])) for val in loaded])
    end

    @testset "$MASK_LOADING" begin
        loaded = Impostor.load!(option_mask, content, provider)
        @test loaded isa Vector{String}
        @test length(loaded) == length(option_mask)
        @test all([l in available_values[occupation] for (l, occupation) in zip(loaded, option_mask)])
    end
end

