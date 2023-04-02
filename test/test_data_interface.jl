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
        loaded = Impostor.load!(content, provider; options = fields)
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


@testset "Data Loading (Multiple Locales)" begin

    resetlocale!()
    sex_mask = ["male", "female", "male", "female"]
    content = "firstname"
    provider = "identity"
    locale = ["pt_BR", "en_US"]
    available_values = _test_load(content, "identity", locale)

    @testset "$OPTIONLESS" begin
        loaded = Impostor.load!(content, provider, locale; options = unique(sex_mask))
        @test loaded isa Vector{String}
    end

    @testset "$OPTION_LOADING" begin
        sex = ["male"]
        loaded = Impostor.load!(content, provider; options = sex)
        @test loaded isa Vector{String}
        for name in loaded
            @test name in available_values["en_US"]["male"] || name in available_values["pt_BR"]["male"]
        end
    end

    @testset "$MASK_LOADING" begin
        loaded = Impostor.load!(sex_mask, content, provider)
        @test loaded isa Vector{String}
        @test length(loaded) == length(sex_mask)
        for (name, sex) in zip(loaded, sex_mask)
            @test name in available_values["en_US"][sex] || name in available_values["pt_BR"][sex]
        end
    end

    # some of the keys are present in only one of the contents of the locales
    @testset "$OPTION_LOADING with Partial Key Match across the Locales" begin
        # this key exists in one of the locales
        @test Impostor.load!("city", "localization", ["pt_BR", "en_US"]; options = ["IL"]) isa Vector{String}
        # this key, "IL", is not present in the pt_BR locale
        @test_throws KeyError Impostor.load!("city", "localization", ["pt_BR"]; options = ["IL"])
        # this key does not exist in neither of the locales
        @test_throws KeyError Impostor.load!("city", "localization", ["en_US", "pt_BR"]; options = ["inexisting_state"])
    end
end

@testset "Auxiliary Functions" begin
    @test locale_exists("en_US")
    @test !locale_exists("zz_ZZ")

    @test provider_exists("en_US", "identity")
    @test !provider_exists("en_US", "indentity") #typo in 'identity' on purpose

    @test content_exists("en_US", "identity", "firstname")
    @test !content_exists("en_US", "identity", "fisrtname") # typo in 'firstnames' on purpose
end
