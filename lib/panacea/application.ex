defmodule Panacea.Application do
  @moduledoc false

  use Application

  @doc """
  Starts the health reporter
  """
  def start(_type, _args) do
    IO.inspect("Starting Panacea Application...")
    opts = [strategy: :one_for_one]
    Supervisor.start_link(get_children(), opts)
  end

  defp get_children do
    [
      add_olympus()
    ]
    |> Enum.reject(&is_nil(&1))
  end

  defp add_olympus do
    if Application.get_env(:panacea, :olympus) == true do
      Panacea.Olympus.Reporter.Reporter
    end
  end
end
