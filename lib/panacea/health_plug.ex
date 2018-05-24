defmodule Panacea.HealthPlug do
  @moduledoc """
  Health Plug for health check of service.
  """

  require Logger

  import Plug.Conn

  def init(opts), do: opts

  def call(conn = %Plug.Conn{path_info: [path], method: "GET"}, opts) do
    if path == Application.get_env(:panacea, :endpoint) do
      conn
      |> put_resp_content_type("application/json", "UTF-8")
      |> send_resp(200, build_health_response())
      |> halt()
    else
      conn
    end
  end

  def build_health_response do
    %{
      "success" => true,
      "timestamp" => DateTime.utc_now
    }
    |> Poison.encode!
  end
end

