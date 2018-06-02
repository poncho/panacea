defmodule Panacea.Olympus.Manager do
  
  @endpoint "/v1/health"

  @doc """
  Reports health to Olympus
  """
  @spec report_health(map) :: tuple
  def report_health(data) do
    body = Poison.encode!(data)
    headers = [{"Content-Type", "application/json"}]
    request = {get_olympus_url(), [], "application/json", body}
    :httpc.request(:post, request, [], [])
  end

  defp get_olympus_url do
    :panacea
    |> Application.get_env(:olympus)
    |> URI.merge(@endpoint)
    |> URI.to_string
  end
end
