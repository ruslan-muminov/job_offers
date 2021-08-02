defmodule JobOffers.Application do
  @moduledoc false

  alias JobOffers.EtsHelper

  def start(_type, _args) do
    :ok = EtsHelper.init_tables()

    children = []
    opts = [strategy: :one_for_one, name: JobOffers.Supervisor]
    {:ok, _} = Supervisor.start_link(children, opts)
  end
end
