defmodule SummonerWebWeb.TagsView do
  use SummonerWebWeb, :view

  def render("create.json", %{tag: tag}) do
    %{
      id: tag.id,
      name: tag.name
    }
  end
end
