defmodule JobOffers.EtsHelper do
  @moduledoc false

  alias JobOffers.Utils

  # JobOffers.EtsHelper.init_tables
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
      :ets.insert(:job, {profession_id, contract_type, name, office_lat, office_lon})
    end)
  end
end
