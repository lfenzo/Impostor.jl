## What is Impostor.jl?

Impostor is a synthetic tabular-data generator based on random samplings over pre-defined
values. One of the main features of Impostor is its ability to generate data making sense
of relations between columns.

### Avaliable Providers

```@contents
Pages = [
    "providers/identity.md",
    "providers/finance.md",
    "providers/localization.md",
]
Depth = 1
```

## Getting Started

First of all, let's make sure that the Impostor package is installed in your current environment:

```@julia
using Pkg; Pkg.add("Impostor")
```

### Generator Functions

To get started with Impostor, select your generator function of choice, the simplest example
is to generate single and multiple values specifying the number of expected values in the output.

```@repl
using Impostor # hide
firstname(5)
firstname()  # equivalent to firstname(1)
```

Generator functions may be found in each of the Providers individual pages or via the
[API Reference](./api_reference.md) page.

!!! note
    When a single value is produced by the generator function, as in `firstname(1)` from the
    example above, the returned valued is automatically unpacked into a `String`
    (or other applicable type depending on the generator function) instead of being returned
    as a `Vector` with exactly 1 element.

    **This behavior might change in future releases.**

All generator functions accept a `locale` keyword argument, in case no value is provided in the
`locale` kwarg the **Session Locale** is used (see section *Concepts* below).

```@repl
using Impostor # hide
firstname(2; locale = ["pt_BR"])
firstname(2; locale = ["en_US", "pt_BR"])
```

In order to change the default `locale` used by the session use the [`setlocale!`](@ref) function:

```@repl
using Impostor # hide
setlocale!("pt_BR");
firstname(2)
resetlocale!(); # hide
```

### Impostor Templates

Besides providing several *generator functions* which may be used as standalone data series
generators, Impostor also exports the [`ImpostorTemplate`](@ref) which is a utility struct to encapsulate
formats and generate a fully fledgned table.

```@repl
using Impostor # hide
using DataFrames # hide
template = ImpostorTemplate([:firstname, :surname, :country_code, :state, :city]);

template(3)

template(5, DataFrame; locale = ["pt_BR", "en_US"]) # optionally provide a `sink` type
```

## Concepts

In order to facilitate naming and referencing later on the major concepts implemented are described below:

- **Generator Functions:** are the users' main point of interaction when generating data, every function exported by Impostor which produces data is a *generator function*.

- **Providers:** are the broader domain in which the contents and generator functions are organized. For example some of the available providers in Impostor are *[Finance](./providers/finance.md)*, *[Identity](./providers/identity.md)* and *[Localization](./providers/localization.md)*.

- **Contents:** correspond to the specific intermediate kinds of data available for generator-functions to manipulate. For example, within the *Localization* provider, some of the available contents are `street_format`, `street_prefix` and `street_suffix` which are combined by the generator-functions like [`address`](@ref) and [`street`](@ref) to produce entries returned to the user.

- **Locales** determine the locale domain from which the each content is sampled in its respective generator function. For example, generating data with `firstname(5; locale=["pt_BR"])` will generate the content "*firstname*" from the provider "*Identity*" corresponding to names typical to the brazillian portuguese language. 

- **Session Locale**: corresponds to the default locale used by the generator functions when no `locale` is explicitly provided as a kwarg. The session locale can be set at any time with the [`setlocale!`](@ref) function, taking on also multiple values for the session locale, *e.g.* `setlocale!(["pt_BR", "en_US"])`.

!!! note "Impostor Convention for Julia's Multiple-Dispatch"
    The convention followed by Impostor throughout its API is to rely on Julia's multiple-dispatch
    paradigm and provide users with 3 different methods for (almost) all generator functions. Such
    methods adhere to the following convention:

    | Implementation | Method Signature | Desctiption |
    |:---------------|:-----------------|:------------|
    | *Value-based* | `func(n::Int)` | Simply generate an output with `n` entries produced by `func`. |
    | *Option-based* | `func(v::Vector, n::Int)` | Generates an output with `n` entries produced by `func` but **restricting the generated entries to specified options in `v`**, which specific contents will depend on `func`. Generator functions taking on options in different levels accept the `optionlevel` kwarg, when that is the case, docstrings will explain each specific behavior. |
    | *Mask-based* | `func(v::Vector)` | Generates an output with `length(v)` entries produced by `func`. **The contents of `v` specify element-wise options to restrict the output of `func`.** Equivalent *in terms of output* with calling `[func(opt, 1) for opt in v]` (*i.e.* the option-based generation), but sub-optimal in terms of performance. Generator functions taking on masks in different levels accept the `masklevel` kwarg, when it is the case, docstrings will explain each specific behavior.|

    ```@repl
    using Impostor # hide
    firstname(3)  # value-based generation
    firstname(["F"], 3)  # option-based generation
    firstname(["F", "M", "F"])  # mask-based generation
    ```

## Contributing

Contributions are welcome, both in implementation, documentation and data addition to the static files. 
Don't hesitate to reach out and request features, file issues or make any suggestions.

For the specific cases of contributing with code and/or data addition, we strongly suggest that you skim through the [Developer Guide](./developer_guide.md) in order to get familiar with the structure and overall design of the package.

### Roadmap

Future developments in Impostor will target the addition of different providers such as:

- **Business**
    - Business name
    - Business field
- **Technology**
    - IPV4/6
    - MAC address
    - File extension
    - Vendor
    - Device
- **Contact**
    - E-mail
    - Username
    - Phone number
    - Social media
- **Color**
    - RGB Color
    - Hex-Color
