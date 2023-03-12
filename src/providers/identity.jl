mutable struct Identity <: Provider
    options::Vector{Symbol}
end


function names(format::Vector{Symbol}; options::Vector{String}, locale)
    println("foo")
    load_assets("..", "data", locale, "identity", "names.json") |> println
    return ["bar"]
end

#names() = names([], [])


#function Base.rand(f::Function, n::Int; unique::Bool = false)
#    println(option)
#    println("estou qui")
#end
