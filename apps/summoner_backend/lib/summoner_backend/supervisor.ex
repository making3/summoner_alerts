defmodule SummonerBackend.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(_) do
    children = [
      SummonerBackend.Tags.Supervisor,
      SummonerBackend.Subreddit.Supervisor,
      SummonerBackend.Repo,
      worker(SummonerBackend.TagWatcher.Server, [])
      # {SummonerBackend.StickyServer, name: StickyServer},
      # {SummonerBackend.StickyThreadFinderServer, name: StickyThreadFinderServer},
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
