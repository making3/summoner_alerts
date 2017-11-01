defmodule SummonerBackend.Subreddit.Server do
  require Logger
  use GenServer
  alias SummonerBackend.Thread
  alias SummonerBackend.Tags

  # Client implementation
  def start_link(subreddit) do
    Tags.Supervisor.add_subreddit(subreddit)

    GenServer.start_link(__MODULE__, subreddit, name: via_tuple(subreddit))
  end

  defp via_tuple(subreddit) do
    {:via, :gproc, {:n, :l, {:subreddit, subreddit}}}
  end

  # Server implementation
  def init(subreddit) do
    IO.puts "starting r/#{subreddit} tag stream"

    pid = start_stream(subreddit)
    Process.monitor(pid)
    {:ok, {subreddit, pid}}
  end

  def handle_info({:DOWN, _ref, :process, _pid, _reason}, {subreddit, _}) do
    pid = start_stream(subreddit)
    Process.monitor(pid)
    {:noreply, {subreddit, pid}}
  end

  defp start_stream(subreddit) do
    spawn_link fn ->
      {:ok, token} = ExReddit.OAuth.get_token()

      ExRedditTagger.Stream.fetch_new_threads_perpertually(token, subreddit)
      |> Stream.map(&(Map.get(&1, "data")))
      |> Stream.map(&(parse_thread(&1, subreddit)))
      |> Stream.filter(&should_return_match(&1))
      |> Stream.map(&save_result(&1))
      |> Stream.run()
    end
  end

  defp save_result({thread, tags}) do
    sas_thread = Thread.changeset(
      %Thread{},
      %{
        title: Map.get(thread, "title"),
        permalink: Map.get(thread, "permalink"),
        created_utc: Thread.get_created_utc(thread),
        thread_id: Map.get(thread, "id"),
        tags: tags
      }
    )

    case SummonerBackend.Repo.insert(sas_thread) do
      {:ok, struct} ->
        struct
      {:error, changeset} ->
        Logger.warn fn -> inspect(changeset.errors) end
    end
  end

  defp parse_thread(thread, subreddit) do
    tags_in_thread = Tags.Server.get(subreddit)
    |> Thread.get_tags_in_thread(thread)

    {thread, tags_in_thread}
  end

  defp should_return_match({_, []}), do: false
  defp should_return_match({_, _}), do: true
end
