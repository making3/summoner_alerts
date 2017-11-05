defmodule SummonerWebWeb.ThreadsController do
  use SummonerWebWeb, :controller
  import Ecto.Query
  alias SummonerBackend.Tag
  alias SummonerBackend.Thread
  alias SummonerBackend.Repo

  def index(conn, _params) do
    threads = Thread
    |> order_by(desc: :created_utc)
    |> limit(20)
    |> Repo.all()
    |> Repo.preload([tags: [:tag_group]])
    render(conn, threads: threads)
  end
end
