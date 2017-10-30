defmodule SummonerBackend.TagGroup do
  use Ecto.Schema

  schema "tag_groups" do
    field :name, :string
    has_many :tags, SummonerBackend.Tag
  end
end
