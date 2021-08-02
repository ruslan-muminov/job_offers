defmodule JobOffers do
  @moduledoc false

  alias JobOffers.{Printer, Utils}

  require Logger

  @total_key "total"
  @error_key "error"

  def parse_professions do
    :professions
    |> Utils.parse()
    |> Enum.reduce(%{}, fn [id, name, category], acc ->
      Map.put(acc, id, {name, category})
    end)
  end

  def category_continent_job_offers_count do
    professions = parse_professions()

    result =
      :jobs
      |> Utils.parse()
      |> category_continent_reduce(professions)

    Printer.convert_and_print(result)
    {:ok, result}
  end


  defp category_continent_reduce(rows_stream, professions) do
    rows_stream
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
