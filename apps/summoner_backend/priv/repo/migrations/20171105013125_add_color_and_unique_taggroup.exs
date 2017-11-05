defmodule SummonerBackend.Repo.Migrations.AddColorAndUniqueTaggroup do
  use Ecto.Migration

  def change do
    alter table(:tag_groups) do
      modify :name, :string, unique: true
      add :color, :string
    end

    create unique_index(:tag_groups, [:name])
  end
end
