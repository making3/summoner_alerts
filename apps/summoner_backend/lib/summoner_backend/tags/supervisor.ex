defmodule SummonerBackend.Tags.Supervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: :tags_supervisor)
  end

  def add_subreddit(subreddit) do
    Supervisor.start_child(
      :tags_supervisor,
      [subreddit]
    )
  end

  def init(_) do
    children = [
      worker(SummonerBackend.Tags.Server, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
