defmodule BldgServer.Repo.Migrations.CreateRoads do
  use Ecto.Migration

  def change do
    create table(:roads) do
      add :flr, :string
      add :from_address, :string
      add :to_address, :string

      timestamps()
    end

  end
end
