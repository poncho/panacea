defmodule Panacea.Olympus.Reporter do
  @moduledoc """
  Health Reporter Application
  """

  use GenServer
  
  require Logger

  alias Panacea.Olympus.Manager
  alias Panacea.Olympus.HealthState

  @report_interval 5_000

  ## Client API

  @doc """
  Starts the health reporter.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  ## Server Callbacks

  def init(:ok) do
    Logger.info "Olympus Health system online!"

    state = %HealthState{
      name: Application.get_env(:olympus_client, :service_name, "default")
    }

    schedule_report()
    {:ok, state}
  end

  def handle_info(:report_health, state) do 
    state =
      case Manager.report_health(state) do
        {:ok, _} ->
          update_report_time(state)
        {:error, error} ->
          Logger.error fn -> "Olympus Health report error: #{error}" end
          set_error(state, error)
      end

    schedule_report()
    {:noreply, state}
  end

  # Schedules next health report with the report interval
  @spec schedule_report :: any() 
  defp schedule_report do
    Process.send_after(self(), :report_health, @report_interval)
  end

  # Updates the last report time in state
  @spec update_report_time(HealthState.t()) :: HealthState.t()
  defp update_report_time(state) do
    state
    |> Map.put(:last_report_time, DateTime.utc_now())
    |> Map.put(:error, nil)
    |> Map.put(:status, :ok)
  end

  # Sets state errors
  @spec set_error(HealthState.t(), String.t()) :: HealthState.t()
  defp set_error(state, error) do
    state
    |> Map.put(:error, error)
    |> Map.put(:status, :error)
  end
end
