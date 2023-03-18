"""

"""
function random_date(n::Int; start::Date = Date(1900, 1, 1), stop::Date = today()) :: Vector{Date}
    return rand(start:Day(1):stop, n)
end


"""

"""
@inline function return_unpacker(v::Vector{T}) :: Union{T, Vector{T}} where {T}
    return length(v) == 1 ? only(v) : v
end


function regex2string() end
