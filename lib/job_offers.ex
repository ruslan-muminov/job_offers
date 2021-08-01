defmodule JobOffers do
  @moduledoc false

  require Logger

  NimbleCSV.define(CsvParser, separator: ",", escape: "\"")

  @total_key "total"
  @error_key "error"

  # JobOffers.test_parse_professions()
  def test_parse_professions() do
    "/root/work/job_offers/technical-test-professions.csv"
    |> File.stream!(read_ahead: 100_000)
    |> CsvParser.parse_stream
    |> Enum.reduce(%{}, fn [id, name, category], acc ->
      Map.put(acc, id, {name, category})
    end)
  end

  # JobOffers.test_parse_jobs()
  def test_parse_jobs() do
    professions = test_parse_professions()

    "/root/work/job_offers/technical-test-jobs.csv"
    |> File.stream!(read_ahead: 100_000)
    |> CsvParser.parse_stream
    |> Enum.reduce({%{}, %{}, %{}, %{}}, fn [profession_id, _, _, office_lat, office_lon] = row,
                                                {crossings, continents, categories, service} ->
      try do
        {:ok, continent_id} = DefineContinent.get_continent_by_coordinates(office_lat, office_lon)
        {:ok, continent_name} = DefineContinent.get_continent_name_by_id(continent_id)
        {_, category} = Map.get(professions, profession_id)

        {
          increment_count(crossings, {continent_name, category}),
          increment_count(continents, continent_name),
          increment_count(categories, category),
          increment_count(service, @total_key)
        }
      rescue
        _e ->
          Logger.warn("incorrect data: #{inspect(row)}")
          {crossings, continents, categories, increment_count(service, @error_key)}
      end
    end)
  end


  defp increment_count(map, key) do
    {_, new_map} =
      Map.get_and_update(map, key,
        fn nil -> {nil, 1}
           count -> {count, count + 1}
      end)
    new_map
  end
end
