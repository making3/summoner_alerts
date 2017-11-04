defmodule SummonerWebWeb.TagsController do
  use SummonerWebWeb, :controller
  import Ecto.Query
  alias SummonerBackend.Tag
  alias SummonerBackend.TagGroup
  alias SummonerBackend.Repo

  def create(conn, params) do
    tag_group = Repo.get(TagGroup, params["group_id"])
    tag_changeset = Ecto.build_assoc(tag_group, :tags, name: params["name"])

    {:ok, tag} = Repo.insert(tag_changeset)
    IO.inspect tag
    render(conn, tag: tag)
  end

  def delete(conn, params) do
    # TODO: Delete tag_threads first (or cascade delete? idk)
    {:ok, _ } = Tag
    |> Repo.get(params["id"])
    |> Repo.delete()

    send_resp(conn, :ok, "")
  end
end
