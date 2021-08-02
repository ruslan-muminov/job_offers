defmodule JobOffers.Printer do
  @moduledoc false

  @spec convert_and_print({map(), map(), map(), map()}) :: :ok
  def convert_and_print({crossings, continents, categories, service}) do
    with {headers, total_row} <- make_headers_and_total_row(categories, service),
         rest_rows <- make_rest_rows(continents, crossings, headers) do
      # print table
      [headers, total_row | rest_rows]
      |> TableRex.quick_render!()
      |> IO.puts()

      # print message with errors count
      errors_count = Map.get(service, "error", 0)
      IO.puts("Total incorrect rows: #{inspect(errors_count)}")
    end
  end


  defp make_headers_and_total_row(categories, %{"total" => total}) do
    categories_zip = Map.to_list(categories)
    [{"", "Total"}, {"Total", total} | categories_zip]
    |> Enum.unzip()
  end

  defp make_rest_rows(continents, crossings, headers) do
    continents
    |> Enum.map(fn {continent_name, continent_count} ->
      headers
      |> Enum.map(
        fn "" -> continent_name
           "Total" -> continent_count
           category_name -> Map.get(crossings, {continent_name, category_name}, 0)
      end)
    end)
  end
end
