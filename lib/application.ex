defmodule JobOffers.Application do
  @moduledoc false

  alias JobOffers.EtsHelper

  use Application

  def start(_type, _args) do
    :ok = EtsHelper.init_tables()

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: JobOffers.Endpoint,
        options: [port: 8443, otp_app: :job_offers]
      )
    ]

    opts = [strategy: :one_for_one, name: JobOffers.Supervisor]
    {:ok, _} = Supervisor.start_link(children, opts)
  end
end
