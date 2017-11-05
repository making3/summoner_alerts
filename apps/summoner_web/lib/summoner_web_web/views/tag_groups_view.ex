defmodule SummonerWebWeb.TagGroupsView do
  use SummonerWebWeb, :view

  def render("index.json", %{tag_groups:  tag_groups}) do
    render_many(tag_groups, __MODULE__, "tag_groups.json")
  end

  def render("tag_groups.json", %{tag_groups: tag_group}) do
    %{
      id: tag_group.id,
      name: tag_group.name,
      color: tag_group.color
    }
  end

  def render("show.json", %{tag_group: tag_group}) do
    %{
      id: tag_group.id,
      name: tag_group.name,
      tags: Enum.map(tag_group.tags, fn tag ->
        %{
          id: tag.id,
          name: tag.name
        }
      end)
    }
  end

  def render(_, %{tag_group: tag_group}) do
    %{
      id: tag_group.id,
      name: tag_group.name,
      color: tag_group.color
    }
  end
end
