# Panacea

> The goddess of universal health

Health check for your projects

## Installation

Add the **Panacea.Plug** to the `endpoint.ex` file before the Router plug to enable the `_health` endpoint.

```elixir
plug Panacea.HealthPlug
plug PhoenixApp.Router
```

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `panacea` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:panacea, "~> 0.1.0"}
  ]
end
```

## Todo

- [x] Plug
- [] Push health check
