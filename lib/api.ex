defmodule JobOffers.Api do
  @moduledoc false

  alias JobOffers.EtsHelper

  @spec job_offers_around_location(lat :: number(), lon :: number(), radius :: number()) ::
          {:ok, list()} | {:error, term()}
  def job_offers_around_location(lat, lon, radius) do
    try do
      result = EtsHelper.select_offers_around_location(lat, lon, radius)
      {:ok, result}
    rescue
      e -> {:error, e}
    end
  end
end
