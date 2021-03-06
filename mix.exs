defmodule JobOffers.MixProject do
  use Mix.Project

  def project do
    [
      app: :job_offers,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy],
      mod: {JobOffers.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:nimble_csv, "~> 1.1"},
      {:table_rex, "~> 3.1.1"},
      {:geocalc, "~> 0.8"},
      {:define_continent, git: "git@github.com:ruslan-muminov/define_continent.git"}
    ]
  end
end
