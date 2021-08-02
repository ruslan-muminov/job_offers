defmodule JobOffers.Utils do
  @moduledoc false

  NimbleCSV.define(CsvParser, separator: ",", escape: "\"")

  @stream_opts read_ahead: 100_000

  def parse(data_type) do
    data_type
    |> csv_path()
    |> File.stream!(@stream_opts)
    |> CsvParser.parse_stream()
  end

  def csv_path(:jobs) do
    :job_offers
    |> :code.priv_dir()
    |> Path.join("technical-test-jobs.csv")
  end
  def csv_path(:professions) do
    :job_offers
    |> :code.priv_dir()
    |> Path.join("technical-test-professions.csv")
  end
end
