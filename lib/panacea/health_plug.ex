defmodule Panacea.HealthPlug do
  @moduledoc """
  Health Plug for health check of service.
  """

  require Logger

  import Plug.Conn

  def init(opts), do: opts
  
  def call(conn = %Plug.Conn{path_info: [], method: "GET"}, opts) do
    conn
  end

  def call(conn = %Plug.Conn{path_info: path_info, method: "GET"}, opts) do
    path = Enum.join(path_info, "/")

    if Enum.member?(Application.get_env(:panacea, :endpoint, []), path) do
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

