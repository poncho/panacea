# Panacea

> [The goddess of universal health](https://en.wikipedia.org/wiki/Panacea)

A simple health check JSON endpoint

```json
{
  "timestamp": "2018-05-10T23:51:56.071987Z",
  "success": true
}
```

## Installation

Add the following to your `mix.exs`:

```elixir
def deps do
  [{:panacea, github: "poncho/panacea", tag: "v1.1.0"}]
end
```

## Health endpoint

If you are using the Phoenix Framework add the **Panacea.Plug** to the `endpoint.ex` file before the Router plug to enable the `_health` endpoint.

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

### Drone

If you are using drone for your deployments you can activate drone data to appear in your health JSON

```json
{
  "timestamp": "2018-05-31T22:24:04.742422Z",
  "success": true,
  "drone": {
    "commit": {
      "sha": "jhsfjah8712812908u12lkjr1kjr12r",
      "link": "https://test.link/commit",
      "branch": "master",
      "author": "poncho"
    },
    "build": {
      "number": "124",
      "link": "https://test.link",
      "event": "push"
    }
  }
}
```

Activate it by adding this to your panacea configuration

```elixir
config :panacea,
  drone: true
```

You can also specify which drone variables you want by adding the list of fields to the configuration instead

```elixir
config :panacea,
  drone: [
    :build_event
    :commit_link
  ]
```

This is the list of valid drone variables:

```elixir
:build_number
:build_event
:build_link
:commit_branch
:commit_link
:commit_author
:commit_sha
```

## Olympus

You can add your Olympus configuration to Panacea so it can report your application's health

```elixir
config :panacea,
  olympus: %{
    url: "http://localhost:5008",
    service_name: "my-app-name"
  }
```

If no `service_name` is stated `app-xxxx` is set as name. (Where `xxxx` is a random 4 digit number)

You can also modify the rate in which Panacea reports to Olympus (In milliseconds). Default is `30_000`. Minimum is `5_000`.

```elixir
config, :panacea,
  olympus: %{
    report_every: 30_000
  }
```
