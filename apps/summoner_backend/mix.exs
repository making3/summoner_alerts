defmodule SummonerBackend.Mixfile do
  use Mix.Project

  def project do
    [
      app: :summoner_backend,
      version: "0.0.1",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: aliases(),
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
    ]
  end

  def application do
    [
      mod: {SummonerBackend, []},
      applications: [:httpotion, :ecto, :postgrex, :exreddit, :gproc],
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpotion, "~> 3.0.2"},
      {:poison, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 2.1"},
      {:exreddit_tagger, git: "https://github.com/making3/exreddit_tagger.git", branch: "master"},
      {:gproc, "0.3.1"}
    ]
  end

  defp aliases do
    [
      test: "test --no-start"
    ]
  end
end
