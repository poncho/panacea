defmodule Panacea.Olympus.Manager do
  
  @endpoint "/v1/health"

  @doc """
  Reports health to Olympus
  """
  @spec report_health(map) :: tuple
  def report_health(data) do
    body =
      data
      |> Poison.encode!
      |> String.to_charlist

    request = {get_olympus_url(), [], 'application/json', body}

    case :httpc.request(:post, request, [], []) do
      {:ok, {{_, 200, _,}, _, response}} ->
        {:ok, response}
      {:error, {error, _,}} ->
        {:error, error}
    end
  end

  # Obtains Olympus URL as charlist for httpc
  @spec get_olympus_url :: charlist()
  defp get_olympus_url do
    url =
      :panacea
      |> Application.get_env(:olympus)
      |> Map.get(:url)
    
    String.to_charlist(url <> @endpoint)
  end
end
