defmodule SummonerBackend.Thread do
  use Ecto.Schema
  import Ecto.Changeset

  schema "threads" do
    field :thread_id, :string
    field :title, :string
    field :permalink, :string
    field :created_utc, Ecto.DateTime
    many_to_many :tags, SummonerBackend.Tag, join_through: "thread_tags"
  end

  # TODO: Insert thread_tags if it doesn't exist, even if the thread exists
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:thread_id, :title, :permalink, :created_utc])
    |> unique_constraint(:thread_id, name: :threads_thread_id_index)
    |> put_assoc(:tags, params.tags)
  end
end
