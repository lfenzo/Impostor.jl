using DataFrames
using CSV

function to_semicolon(provider::String, content::String)
    content_path = joinpath(provider, content)

    for file in readdir(content_path, join=true)
        !endswith(file, ".csv") && continue
        df = CSV.read(file, DataFrame; header=false)
        df = sort(df, [2])
        CSV.write(file, df; header=false, delim=';')
        @info file
    end
end

to_semicolon("localization", "country")
