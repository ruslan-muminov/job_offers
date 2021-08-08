defmodule JobOffers.Endpoint do
  @moduledoc false

  alias JobOffers.{Api, Utils}

  use Plug.Router

  require Logger

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  get "/ping" do
    send_resp(conn, 200, "pong!")
  end

  get "/offers_around_location" do
    conn
    |> fetch_query_params()
    |> Map.get(:query_params)
    |> verify_and_request(conn)
  end

  match _ do
    send_resp(conn, 404, "ooops... Nothing there :(")
  end


  defp verify_and_request(%{"latitude" => lat_str, "longitude" => lon_str, "radius" => radius_str}, conn) do
    with lat when is_number(lat) <- Utils.binary_to_float(lat_str),
         lon when is_number(lon) <- Utils.binary_to_float(lon_str),
         radius when is_number(radius) <- Utils.binary_to_float(radius_str),
         {:ok, result} <- Api.job_offers_around_location(lat, lon, radius) do
      send_resp(conn, 200, inspect(result))
    else
      nil -> send_resp(conn, 400, "Parameters must be valid numbers")
      {:error, error} -> send_resp(conn, 500, inspect(error))
    end
  end
  defp verify_and_request(_, conn),
    do: send_resp(conn, 400, "There are 3 required parameters: latitude, longitude, radius!")
end
