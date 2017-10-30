defmodule SummonerWebWeb.ThreadsController do
  use SummonerWebWeb, :controller
  import Ecto.Query

  def index(conn, _params) do
    threads = SummonerBackend.Thread
    |> order_by(desc: :created_utc)
    |> limit(20)
    |> SummonerBackend.Repo.all
    threads = SummonerBackend.Repo.preload threads, :tags
    render conn, threads: threads
  end
end
