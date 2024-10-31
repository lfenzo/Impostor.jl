using CSV
using DataFrames
using Impostor
using PrettyTables
using DataStructures


"""

"""
function collect_provider_availability_statistics(provider::String)
    provider_dir = joinpath(pkgdir(Impostor), "src", "data", provider)
    provider_stats = []

    for content_dir in readdir(provider_dir, join=true)

        content_locales = String[]
        for content_file in readdir(content_dir)
            if endswith(content_file, ".csv")
                push!(content_locales, split(content_file, ".") |> first)
            end
        end

        content_dir = split(content_dir, "/") |> last |> String
        df = Impostor._load!(provider, content_dir, content_locales)

        n_entries = unique(df, [ncol(df)]) |> nrow

        data = OrderedDict(
            "Generator Function" => content_dir,
            "Available Locales" => length(content_locales),
            "Unique Entries" => n_entries,
        )

        push!(provider_stats, data)
    end

    return pretty_table(DataFrame(provider_stats))
end
