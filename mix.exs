defmodule Panacea.MixProject do
  use Mix.Project

  def project do
    [
      app: :panacea,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Panacea.Application, []},
      extra_applications: [:logger, :inets, :ssl]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 2.3", only: [:dev]},
      {:plug, "~> 1.3"},
      {:poison, "~> 3.1"}
    ]
  end
end
