defmodule SummonerBackend.Repo.Migrations.ThreadIdUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index(:threads, [:thread_id])
  end
end
