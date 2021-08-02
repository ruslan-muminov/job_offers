defmodule Mix.Tasks.CategoryContinentJobOffersCount do
  use Mix.Task

  def run(_) do
    JobOffers.category_continent_job_offers_count()
  end
end
