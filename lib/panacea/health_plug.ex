defmodule Panacea.HealthPlug do
  @moduledoc """
  Health Plug for health check of service.
  """

  require Logger

  import Plug.Conn

  def init(opts), do: opts

  def call(conn = %Plug.Conn{path_info: ["_health"], method: "GET"}, opts) do
    conn
    |> put_resp_content_type("application/json", "UTF-8")
    |> send_resp(200, build_health_response())
    |> halt()
  end

  def call(conn, _opts) do
    conn
  end

  def build_health_response do
    %{
      "success" => true,
      "timestamp" => DateTime.utc_now
    }
    |> Poison.encode!
  end
end

