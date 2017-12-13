defmodule Webcrawler.Mixfile do
  use Mix.Project

  def project do
    [
      app: :web_crawler,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {WebCrawler, []},
      extra_applications: [:logger, :poolboy]
    ]
  end

  defp deps do
    [
	    {:floki, "~> 0.19.0"},
      {:httpoison, "~> 0.13"},
      {:poolboy, "~> 1.5.1"}
    ]
  end

  defp aliases do
  [
    test: "test --no-start"
  ]
end
end
