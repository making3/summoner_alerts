defmodule SummonerBackend.TagWatcher.Server do
  use GenServer

  # Client
  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  # Server
  def init(state) do
    subreddit = get_subreddit()

    SummonerBackend.Subreddit.Supervisor.add_subreddit(subreddit)
    Application.get_env(:summoner_backend, :subreddit)

    fetch_group_tags() |> do_work(subreddit)
    {:ok, state}
  end

  defp get_subreddit() do
    Application.get_env(:summoner_backend, :subreddit)
  end

  def handle_info(:work, state) do
    subreddit = get_subreddit()

    # TODO: Only grab new groups or updates?
    fetch_group_tags() |> do_work(subreddit)
    {:noreply, state}
  end

  defp fetch_group_tags() do
    groups = SummonerBackend.TagGroup |> SummonerBackend.Repo.all
    SummonerBackend.Repo.preload groups, :tags
  end

  defp do_work([], _) do
    schedule_work()
  end
  defp do_work([head | tail], subreddit) do
    SummonerBackend.Tags.Server.add_group_tags(subreddit, head.name, head.tags)
    do_work(tail, subreddit)
  end

  defp schedule_work() do
    interval = Application.get_env(:summoner_backend, :watch_tags_interval)
    Process.send_after(self(), :work, interval)
  end
end
