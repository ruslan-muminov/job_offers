defmodule JobOffers.EtsHelper do
  @moduledoc false

  alias JobOffers.Utils

  @spec select_offers_around_location(lat :: number(), lon :: number(), radius :: number()) :: list()
  def select_offers_around_location(lat, lon, radius) do
    mspec = [
      {{:"$1", :_, :_, :"$2", :"$3"},
       [
         {:"=<",
          {:+, {:*, {:-, :"$2", lat}, {:-, :"$2", lat}},
           {:*, {:-, :"$3", lon}, {:-, :"$3", lon}}}, {:*, radius, radius}}
       ],
       [:"$_"]}
    ]

    :ets.select(:job, mspec)
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
      office_lat = binary_to_float(office_lat)
      office_lon = binary_to_float(office_lon)
      :ets.insert(:job, {profession_id, contract_type, name, office_lat, office_lon})
    end)
  end

  defp binary_to_float(str) do
    try do
      {num, _} = Float.parse(str)
      num
    rescue
      _e -> nil
    end
  end
end
