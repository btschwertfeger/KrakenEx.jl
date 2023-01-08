<h1 style="text-align: center">KrakenEx.jl</h1>

## Notes

```julia
import Pkg; Pkg.precompile()
```

When calling endpoints for examlpe the futures funding endpoint and you submit spaces, braces,... in strings likt " " a KrakenAuthenticationError will be raised.
