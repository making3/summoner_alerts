defmodule SummonerWebWeb.ThreadsController do
  use SummonerWebWeb, :controller

  def index(conn, _params) do
    threads = SummonerBackend.Thread |> SummonerBackend.Repo.all
    render conn, threads: threads
  end
end
