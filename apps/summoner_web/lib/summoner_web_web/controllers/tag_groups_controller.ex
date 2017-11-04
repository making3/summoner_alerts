defmodule SummonerWebWeb.TagGroupsController do
  use SummonerWebWeb, :controller
  import Ecto.Query
  alias SummonerBackend.TagGroup
  alias SummonerBackend.Repo

  def index(conn, _params) do
    tag_groups = TagGroup
    |> Repo.all()
    render(conn, tag_groups: tag_groups)
  end

  def show(conn, params) do
    tag_group = TagGroup
    |> Repo.get(params["id"])
    |> Repo.preload(:tags)
    render(conn, tag_group: tag_group)
  end

  def create(conn, params) do
    tag_group = %TagGroup{name: params["name"]}
    {:ok, tag_group} = Repo.insert(tag_group)
    render(conn, tag_group: tag_group)
  end

  def delete(conn, params) do
    {:ok, _} = TagGroup
    |> Repo.get(params["id"])
    |> Repo.delete()
    send_resp(conn, :ok, "")
  end
end
