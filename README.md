# Impostor.jl

Impostor is a 100% Julia synthetic tabular-data generator bundled with various utility functions
to ease your life when creating fictitious, fraudulent, fake, (virtually *impostor-like*) data!

Some examples are provided in the "Getting Started" section below, for more detailed examples
check out the [documentation page](https://lfenzo.github.io/Impostor.jl/dev/).

## Getting Started

First, add the Impostor.jl to the current environment:
```
] add Impostor
```

And then:
```julia
using Impostor
using DataFrames

credit_card_number(; formatted = true)
# "4767-6731-1326-5309"

surname(4; locale = ["pt_BR"])
# 4-element Vector{String}:
#  "Feranndes"
#  "Pereira"
#  "Camargo"
#  "Pereira"

firstname(["M"], 4)
# 4-element Vector{String}:
#  "Charles"
#  "Zacharias"
#  "Paul"
#  "Charles"

city(["BRA", "USA"], 4; level=:country_code)
# 4-element Vector{String}:
#  "Curitiba"
#  "Los Angeles"
#  "São Paulo"
#  "Rio de Janeiro"

address(["BRA", "USA", "BRA", "USA"]; level = :country_code)
# 4-element Vector{String}:
#  "Avenida Paulo Lombardi 1834, Ba" ⋯ 25 bytes ⋯ "84-514, Porto Alegre-RS, Brasil"
#  "Abgail Smith Alley, Los Angeles" ⋯ 42 bytes ⋯ "ornia, United States of America"
#  "Avenida Tomas Lins 4324, (Apto " ⋯ 23 bytes ⋯ "orocaba - 89457-346, SP, Brasil"
#  "South-side Street 1st Floor, Li" ⋯ 52 bytes ⋯ "as-AR, United States of America"


my_custom_template = ImpostorTemplate([:firstname, :surname, :country_code, :state, :city]);

my_custom_template(4, DataFrame; locale = ["pt_BR", "en_US"])
# 4×5 DataFrame
#  Row │ firstname  surname   country_code  state           city
#      │ String     String    String3       String15        String15
# ─────┼───────────────────────────────────────────────────────────────────
#    1 │ Mary       Collins   BRA           Rio de Janeiro  Rio de Janeiro
#    2 │ Kate       Cornell   USA           Illinois        Chicago
#    3 │ Carl       Fraser    BRA           Paraná          Curitiba
#    4 │ Milly      da Silva  USA           California      Los Angeles


template_string = "I know firstname surname, this person is a(n) occupation";

render_template(template_string)
# "I know Charles Jameson, this person is a(n) Mathematician"

println("My new car plate is $(render_alphanumeric("^^^-####"))")
# My new car plate is TXP-9236
```
