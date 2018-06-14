defmodule Panacea.Application do
  @moduledoc false

  use Application

  require Logger

  @doc """
  Starts the health reporter
  """
  def start(_type, _args) do
    Logger.info "Starting Panacea..."
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
    case Application.get_env(:panacea, :olympus) do
      %{url: url} when is_binary(url) and url != "" ->
        Panacea.Olympus.Reporter
      _ ->
        nil
    end
  end
end
