defmodule SummonerBackend.Thread do
  use Ecto.Schema
  import Ecto.Changeset
  alias SummonerBackend.Tag

  schema "threads" do
    field :thread_id, :string
    field :title, :string
    field :permalink, :string
    field :created_utc, Ecto.DateTime
    many_to_many :tags, SummonerBackend.Tag, join_through: "thread_tags"
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:thread_id, :title, :permalink, :created_utc])
    |> unique_constraint(:thread_id, name: :threads_thread_id_index)
    |> put_assoc(:tags, params.tags)
  end

  def get_tags_in_thread(tags, thread) do
    tag_values = tags
    |> Map.values()
    |> List.flatten()

    Tag.get_unique_tags(tag_values)
    |> find_tags_in_thread(thread)
    |> MapSet.new()
    |> Tag.get_group_tags_from_unique(tag_values)
  end

  defp find_tags_in_thread(tags, thread) do
    tags_in_body = get_tags_from_map(thread, "selftext", tags)
    tags_in_title = get_tags_from_map(thread, "title", tags)
    Enum.concat(tags_in_body, tags_in_title)
  end

  defp get_tags_from_map(thread, property, tags) do
    text = thread
    |> Map.get(property)
    |> String.downcase()

    Enum.filter(tags, fn tag ->
      String.contains?(text, String.downcase(tag))
    end)
  end

  def get_created_utc(thread) do
    thread
    |> Map.get("created_utc")
    |> round()
    |> convert_unix_to_ecto()
  end

  defp convert_unix_to_ecto(unix_datetime) do
    unix_datetime
    |> DateTime.from_unix!(:second)
    |> Ecto.DateTime.cast!()
  end
end
