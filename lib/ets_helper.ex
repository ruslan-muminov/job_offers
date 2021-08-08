defmodule JobOffers.EtsHelper do
  @moduledoc false

  alias JobOffers.Utils

  @spec select_offers_around_location(lat :: number(), lon :: number(), radius :: number()) :: list()
  def select_offers_around_location(lat, lon, radius) do
    radius_m = radius * 1000
    :ets.foldl(
      fn
        {_, _, _, office_lat, office_lon}, acc when not is_number(office_lat) or not is_number(office_lon) ->
          acc
        {prof_id, contract_type, name, office_lat, office_lon}, acc ->
          distance = Geocalc.distance_between([lat, lon], [office_lat, office_lon])
          if distance <= radius_m do
            {prof_name, prof_category} = get_profession_info(prof_id)
            proximity = Float.round(distance / 1000, 3)
            [{prof_name, prof_category, contract_type, name, office_lat, office_lon, proximity} | acc]
          else
            acc
          end
      end, [], :job)
  end

  @spec get_profession_info(profession_id :: String.t()) :: {String.t(), String.t()}
  def get_profession_info(profession_id) do
    case :ets.lookup(:profession, profession_id) do
      [{_, name, category}] -> {name, category}
      _ -> {"", ""}
    end
  end

  def init_tables do
    init_profession_table()
    init_job_table()
    :ok
  end
  
  def init_profession_table do
    :ets.new(:profession, [:set, :protected, :named_table])

    :professions
    |> Utils.parse()
    |> Enum.map(fn [id, name, category] ->
      :ets.insert(:profession, {id, name, category})
    end)
  end

  def init_job_table do
    :ets.new(:job, [:bag, :protected, :named_table])

    :jobs
    |> Utils.parse()
    |> Enum.map(fn [profession_id, contract_type, name, office_lat, office_lon] ->
      office_lat = Utils.binary_to_float(office_lat)
      office_lon = Utils.binary_to_float(office_lon)
      :ets.insert(:job, {profession_id, contract_type, name, office_lat, office_lon})
    end)
  end
end
