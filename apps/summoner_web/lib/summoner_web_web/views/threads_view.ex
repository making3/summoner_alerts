defmodule SummonerWebWeb.ThreadsView do
  use SummonerWebWeb, :view

  def render("index.json", %{threads:  threads}) do
    render_many(threads, __MODULE__, "thread.json")
  end

  def render("thread.json", %{threads: thread}) do
    %{
      id: thread.id,
      permalink: "https://reddit.com" <> thread.permalink,
      title: thread.title
    }
  end
end
