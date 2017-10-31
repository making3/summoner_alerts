defmodule SummonerBackend.Subreddit.Server do
  require Logger
  use GenServer
  alias SummonerBackend.Thread

  # Client implementation
  def start_link(subreddit) do
    SummonerBackend.Tags.Supervisor.add_subreddit(subreddit)

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
    tags = SummonerBackend.Tags.Server.get(subreddit)
    |> Map.values()
    |> List.flatten()

    unique_tag_names = get_unique_tags(tags)

    result_tags = parse_tags(thread, unique_tag_names)
    |> MapSet.new()
    |> get_group_tags_from_unique(tags)
    {thread, result_tags}
  end

  defp parse_tags(thread, tags) do
    body_result = get_tags_from_map(thread, "selftext", tags)
    get_tags_from_map(thread, "title", tags)
    |> Enum.concat(body_result)
  end

  defp get_tags_from_map(thread, property, tags) do
    text = thread
    |> Map.get(property)
    |> String.downcase

    Enum.filter(tags, fn tag -> String.contains?(text, tag) end)
  end

  defp should_return_match({_, []}), do: false
  defp should_return_match({_, _}), do: true

  defp get_unique_tags(tags) do
    tags
    |> Enum.map(fn tag -> tag.name end)
    |> MapSet.new()
  end

  defp get_group_tags_from_unique(found_tags, tags) do
    Enum.filter(tags, fn tag ->
      MapSet.member?(found_tags, tag.name)
    end)
  end
end
