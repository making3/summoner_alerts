defmodule SummonerWebWeb.TagGroupsController do
  use SummonerWebWeb, :controller
  import Ecto.Query
  alias SummonerBackend.TagGroup
  alias SummonerBackend.Repo

  def index(conn, _params) do
    tag_groups = Repo.all(TagGroup)
    render(conn, tag_groups: tag_groups)
  end

  def update(conn, params) do
    with {:ok, tag_group} <- TagGroup.get(params["id"]),
         {:ok, new_tag_group} <- TagGroup.update(tag_group, params["name"], params["color"])
    do
      render(conn, tag_group: new_tag_group)
    else
      {:error, :notfound} ->
        send_resp(conn, 404, "Not found")
      {:error, errors} ->
        send_resp(conn, 500, errors)
    end
  end

  def show(conn, params) do
    case TagGroup.get(params["id"]) do
      {:ok, tag_group} ->
        tag_group = Repo.preload(tag_group, :tags)
        render(conn, tag_group: tag_group)
      {:error, :notfound} ->
        send_resp(conn, 404, "Not found")
    end
  end

  def create(conn, params) do
    case TagGroup.insert(params["name"], params["color"]) do
      {:ok, tag_group} ->
        render(conn, tag_group: tag_group)
      {:error, errors} ->
        send_resp(conn, 500, errors)
    end
  end

  def delete(conn, params) do
    {:ok, _} = TagGroup
    |> Repo.get(params["id"])
    |> Repo.delete()
    send_resp(conn, :ok, "")
  end
end
