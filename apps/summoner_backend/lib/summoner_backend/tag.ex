defmodule SummonerBackend.Tag do
  use Ecto.Schema
  alias SummonerBackend.TagGroup

  schema "tags" do
    field :name, :string
    belongs_to :tag_group, TagGroup
  end

  def get_unique_tags(tags) do
    tags
    |> Enum.map(fn tag -> tag.name end)
    |> MapSet.new()
  end

  def get_group_tags_from_unique(found_tags, tags) do
    Enum.filter(tags, fn tag ->
      MapSet.member?(found_tags, tag.name)
    end)
  end
end
