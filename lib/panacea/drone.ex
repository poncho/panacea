defmodule Panacea.Drone do
  @moduledoc """
  Drone manager
  """

  require Logger

  @fields %{
    build_number: {:build, System.get_env("DRONE_BUILD_NUMBER")},
    build_event: {:build, System.get_env("DRONE_BUILD_EVENT")},
    build_link: {:build, System.get_env("DRONE_BUILD_LINK")},
    commit_branch: {:commit, System.get_env("DRONE_COMMIT_BRANCH")},
    commit_link: {:commit, System.get_env("DRONE_COMMIT_LINK")},
    commit_author: {:commit, System.get_env("DRONE_COMMIT_AUTHOR")},
    commit_sha: {:commit, System.get_env("DRONE_COMMIT_SHA")}
  }

  @doc """
  Adds the Drone data to the health data map
  """
  @spec setup(map) :: map
  def setup(data) do
    case Application.get_env(:panacea, :drone) do
      true ->
        drone_config = Map.keys(@fields)
        Map.put(data, "drone", build_drone_data(drone_config))
      [_, _] = drone_config ->
        drone_config
      _ ->
        data
    end
  end

  @doc """
  Obtains the required drone fields and builds the Drone data map
  """
  @spec build_drone_data(list) :: map
  def build_drone_data(drone_config) do
    drone_config
    |> Enum.map(fn field ->
      {section, value} = Map.get(@fields, field)
      %{
        name: field,
        section: section,
        value: value
      }
    end)
    |> Enum.group_by(fn %{section: section} -> section end)
    |> create_drone_data
  end

  # Builds the drone data map
  @spec create_drone_data(list) :: map
  defp create_drone_data(fields) do
    fields
    |> Map.get(nil)
    |> format_section_fields
    |> Map.put("build", format_section_fields(fields[:build]))
    |> Map.put("commit", format_section_fields(fields[:commit]))
    |> Enum.reject(fn {_, value} -> value == %{} end)
    |> Enum.into(%{})
  end

  # Formats the drone data sections
  @spec format_section_fields(list | nil) :: map
  defp format_section_fields(nil), do: %{}
  defp format_section_fields(fields) do
    Enum.reduce(fields, %{}, fn %{name: name, value: value}, data ->
      key =
        name
        |> to_string
        |> String.split("_", parts: 2)
        |> Enum.reverse
        |> List.first

      Map.put(data, key, value)
    end)
  end
end
