# Identity

The following generator functions are available in the *Identity* provider:

```@example
using Impostor # hide
using CSV # hide
using DataFrames # hide
include(joinpath(pkgdir(Impostor), "snippets", "collect-statistics.jl")) # hide
collect_provider_availability_statistics("identity") # hide
```

-----------

```@docs
prefix
birthdate
bloodtype
complete_name
highschool
nationality
university
occupation
firstname
surname
```
