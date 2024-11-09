# Localization

The following generator functions are available in the *Localization* provider:

```@example
using Impostor # hide
using CSV # hide
using DataFrames # hide
include(joinpath(pkgdir(Impostor), "snippets", "collect-statistics.jl")) # hide
collect_provider_availability_statistics("localization") # hide
```

The localization generator functions follow the standards defined by [ISO 3166](https://en.wikipedia.org/wiki/ISO_3166)
in order to organize the entries and returned values. When appropriate, each docstring will point
out the ISO 3166 variant being returned.

-----------

```@docs
address
address_complement
city
country
country_code
country_official_name
district
postcode
state
state_code
street
street_number
street_prefix
street_suffix
```
