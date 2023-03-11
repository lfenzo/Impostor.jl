const ASSETS_ROOT::String = joinpath("data")


function load_asset(locale::T, path::T...; options::Union{Vector{T}, Nothing} = nothing) where {T <: AbstractString}
    asset_path = joinpath(ASSETS_ROOT, locale, path...)
    open(asset_path * ".json", "r") do file
        return Dict(JSON3.read(file))
    end
end
