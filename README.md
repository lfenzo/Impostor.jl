# Impostor.jl

[Docs](https://lfenzo.github.io/Impostor.jl/dev/)

-----------------

Impostor is a 100% Julia synthetic tabular-data generator bundled with various utility functions
helping the generation of fictitious, fraudulent, fake, (virtually *impostor-like*) data!

## Getting Started

```julia
using Impostor
using DataFrames

firstname(["M"], 5; locale = ["en_US", "pt_BR"])
# 5-element Vector{String}:
#  "Charles"
#  "Carl"
#  "Zacharias"
#  "João"
#  "Bernardo"


template = ImpostorTemplate([:firstname, :surname, :country_code, :state, :city]);

template(5, DataFrame; locale = ["pt_BR", "en_US"])
# 5×5 DataFrame
#  Row │ firstname  surname   country_code  state           city
#      │ String     String    String3       String15        String15
# ─────┼───────────────────────────────────────────────────────────────────
#    1 │ Mary       Collins   BRA           Rio de Janeiro  Rio de Janeiro
#    2 │ Kate       Cornell   USA           Illinois        Chicago
#    3 │ Carl       Fraser    BRA           Paraná          Curitiba
#    4 │ Milly      da Silva  USA           California      Los Angeles
#    5 │ Bernardo   Pereira   BRA           Paraná          Curitiba


template = "I know firstname surname, this person is a(n) occupation";

materialize_template(template; locale="en_US")
# "I know Charles Jameson, this person is a(n) Mathematician"

println("My new car plate is $(materialize_numeric_template("A#C-#####90"))")
# My new car plate is A3C-0057090
```
