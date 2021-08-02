defmodule JobOffers.Api do
  @moduledoc false

  alias JobOffers.EtsHelper

  @rad_in_km 0.0001568
  # Of corse this value is changeable, when we talk about latitude.
  # But in this situation I don't see any cases, where we would
  # work with huge distances (a few hundred km max). So there is
  # an approximation to avoid complicated calculating.

  # JobOffers.Api.job_offers_around_location(43, 7, 4000)
  @spec job_offers_around_location(lat :: number(), lon :: number(), radius :: number()) ::
          {:ok, list()} | {:error, term()}
  def job_offers_around_location(lat, lon, radius) do
    try do
      result =
        lat
        |> EtsHelper.select_offers_around_location(lon, radius * @rad_in_km)
        |> Enum.map(fn {profession_id, contract_type, name, office_lat, office_lon} ->
          proximity = calc_proximity(office_lat, office_lon, lat, lon)
          {profession_name, profession_category} = EtsHelper.get_profession_info(profession_id)

          {profession_name, profession_category, contract_type, name, office_lat, office_lon, proximity}
        end)
      {:ok, result}
    rescue
      e -> {:error, e}
    end
  end

  defp calc_proximity(lat1, lon1, lat2, lon2) do
    result_rad = :math.sqrt(:math.pow(lat1 - lat2, 2) + :math.pow(lon1 - lon2, 2))
    Float.round(result_rad / @rad_in_km, 4)
  end
end
