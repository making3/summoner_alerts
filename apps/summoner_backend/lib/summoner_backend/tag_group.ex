defmodule SummonerBackend.TagGroup do
  use Ecto.Schema
  import Ecto.Changeset
  alias SummonerBackend.Repo

  schema "tag_groups" do
    field :name, :string
    field :color, :string
    has_many :tags, SummonerBackend.Tag
  end

  def changeset(tag_group, params \\ %{}) do
    tag_group
    |> cast(params, [:name, :color])
    # |> validate_color(:color) # TODO: Validate that it's a valid color (blue, #000000)
    |> unique_constraint(:name)
  end

  def get(id) do
    case Repo.get(__MODULE__, id) do
      nil ->
        {:error, :notfound}
      tag_group ->
        {:ok, tag_group}
    end
  end

  def update(tag_group, name, color) do
    change_set = changeset(
      tag_group,
      %{
        name: name,
        color: color
      }
    )

    Repo.update(change_set)
  end

  def insert(name, color) do
    insert(%{ name: name, color: color })
  end
  def insert(%{name: _, color: _} = params) do
    tag_group_changeset = changeset(
      %__MODULE__{},
      params
    )
    case Repo.insert(tag_group_changeset) do
      {:ok, tag_group} ->
        {:ok, tag_group}
      {:error, changeset} ->
        {:error, inspect(changeset.errors)}
    end
  end
end
