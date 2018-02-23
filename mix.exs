defmodule WebCrawler.Mixfile do
  use Mix.Project

  def project do
    [
      app: :web_crawler,
      version: "0.1.0",
      elixir: "~> 1.6",
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
      #{:waterpark, git: "https://github.com/willferguson/waterpark.git", tag: "v0.1"},
      {:waterpark, path: "/Users/will/dev/elixir/waterpark"},
	    {:floki, "~> 0.19.0"},
      {:httpoison, "~> 0.13"},
      {:credo, "~> 0.3", only: [:dev, :test]}
    ]
  end

  defp aliases do
  [
    test: "test --no-start"
  ]
end
end
