defmodule Panacea.HealthPlug do
  @moduledoc """
  Health Plug for health check of service.
  """

  @default_health_endpoint "_health"

  require Logger

  import Plug.Conn

  def init(opts), do: opts

  def call(conn = %Plug.Conn{path_info: path_info, method: "GET"}, _opts) do
    path = Enum.join(path_info, "/")

    if is_health_path(Application.get_env(:panacea, :endpoint), path) do
      conn
      |> put_resp_content_type("application/json", "UTF-8")
      |> send_resp(200, build_health_response())
      |> halt()
    else
      conn
    end
  end

  # Checks if path is a valid health endpoint
  @spec is_health_path(String.t() | [String.t()] | nil, String.t()) :: boolean
  defp is_health_path(nil, path) do
    is_health_path(@default_health_endpoint, path)
  end
  defp is_health_path(health_paths, path) when is_list(health_paths) do
    Enum.any?(health_paths, fn health_path ->
      equal_paths(health_path, path)
    end)
  end
  defp is_health_path(health_path, path) when is_binary(health_path) do
    equal_paths(health_path, path)
  end

  # Checks if both path are the same
  defp equal_paths(path1, path2) do
    String.trim(path1, "/") == String.trim(path2, "/")
  end

  # Creates the health JSON response
  @spec build_health_response :: String.t()
  defp build_health_response do
    %{
      "success" => true,
      "timestamp" => DateTime.utc_now
    }
    |> Poison.encode!
  end
end

