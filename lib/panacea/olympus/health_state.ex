defmodule Panacea.Olympus.HealthState do
  defstruct [
    name: "default",
    start_time: DateTime.utc_now(),
    last_report_time: nil,
    status: :ok,
    error: nil
  ]
end
