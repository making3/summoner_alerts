defmodule SummonerWebWeb.ThreadsController do
  use SummonerWebWeb, :controller
  import Ecto.Query
  alias SummonerBackend.Tag
  alias SummonerBackend.Thread
  alias SummonerBackend.Repo

  def index(conn, params) do
    tags = String.split(params["tags"], ",")
    threads = get_threads(tags)

    render(conn, threads: threads)
  end

  def get_threads([""]) do
    threads = Thread
    |> order_by(desc: :created_utc)
    |> limit(20)
    |> Repo.all()
    |> Repo.preload([tags: [:tag_group]])
  end
  def get_threads(tagNames) do
    query = from thread in Thread,
      preload: [tags: [:tag_group]],
      join: tag in assoc(thread, :tags),
      where: tag.name in ^tagNames,
      order_by: [desc: thread.created_utc],
      limit: 20

    IO.inspect query
    Repo.all(query)
  end
end
