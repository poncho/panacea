defmodule Panacea.Olympus.Reporter do
  @moduledoc """
  Health Reporter Application
  """

  use GenServer
  
  require Logger

  alias Panacea.Olympus.Manager
  alias Panacea.Olympus.HealthState

  @report_interval 30_000
  @min_report_interval 5_000

  ## Client API

  @doc """
  Starts the health reporter.
  """
  @spec start_link(list) :: any()
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  @doc """
  Obtains the health state report
  """
  @spec view_health :: HealthState.t()
  def view_health do
    GenServer.call(__MODULE__, :view_health)
  end

  ## Server Callbacks

  def init(:ok) do
    name =
     case Application.get_env(:panacea, :olympus) do
       %{service_name: name} when is_binary(name) and name != "" ->
          name
        
        _ ->
          number =
            9999
            |> :rand.uniform
            |> to_string

          "app-" <> number
     end

    Logger.info "Olympus Health system for app #{name} online!"
  
    state = %HealthState{
      name: name
    }

    schedule_report()
    {:ok, state}
  end

  def handle_call(:view_health, _from, state) do
    {:reply, state, state}
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
    interval = get_next_interval()
    Process.send_after(self(), :report_health, interval)
  end

  # Obtains the next interval from config if exists
  @spec get_next_interval :: integer
  defp get_next_interval do
    interval = 
      case Application.get_env(:panacea, :olympus) do
        %{report_every: interval} when is_integer(interval) ->
          interval

        _ ->
          @report_interval
      end

    interval > @min_report_interval && interval || @min_report_interval
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
