defmodule SummonerWebWeb.PageController do
  use SummonerWebWeb, :controller

  def index(conn, _params) do
    threads = SummonerBackend.Thread |> SummonerBackend.Repo.all
    render conn, "index.html", message: "hello", threads: threads
  end
end
