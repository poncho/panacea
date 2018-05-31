# Panacea

> The goddess of universal health

A simple health check JSON endpoint
```json
{
  "timestamp": "2018-05-10T23:51:56.071987Z",
  "success": true
}
```

## Installation

Add the **Panacea.Plug** to the `endpoint.ex` file before the Router plug to enable the `_health` endpoint.

```elixir
plug Panacea.HealthPlug
plug PhoenixApp.Router
```

You can configure a diferent health endpoint
```elixir
config :panacea,
  endpoint: "_health"
```
Or even multiple endpoints
```elixir
config :panacea,
  endpoint: ["_health", "/health/check"]
```

If no endpoint is configured, the default health endpoint is `_health`

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
- [ ] Push health check
