defmodule SummonerBackend.TagWatcher.Server do
  use GenServer

  # TODO: Change this to summonerschool. AskReddit has more data for testing.
  @subreddit "askreddit"

  # Client
  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  # Server
  def init(state) do
    SummonerBackend.Subreddit.Supervisor.add_subreddit(@subreddit)

    fetch_group_tags() |> do_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    # TODO: Only grab new groups or updates?
    fetch_group_tags() |> do_work()
    {:noreply, state}
  end

  defp fetch_group_tags() do
    groups = SummonerBackend.TagGroup |> SummonerBackend.Repo.all
    SummonerBackend.Repo.preload groups, :tags
  end

  defp do_work([]) do
    schedule_work()
  end
  defp do_work([head | tail]) do
    SummonerBackend.Tags.Server.add_group_tags(@subreddit, head.name, head.tags)
    do_work(tail)
  end

  defp schedule_work() do
    # TODO: Create a setting for this timeout
    Process.send_after(self(), :work, 15 * 1000) # Every 15 seconds
    # Process.send_after(self(), :work, 5 * 60 * 1000) # Every 5 minutes
  end
end
