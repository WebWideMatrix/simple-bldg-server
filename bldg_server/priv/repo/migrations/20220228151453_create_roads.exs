defmodule BldgServer.Repo.Migrations.CreateRoads do
  use Ecto.Migration

  def change do
    create table(:roads) do
      add :flr, :string
      add :from_address, :string
      add :to_address, :string
      add :from_x, :int
      add :from_y, :int
      add :to_x, :int
      add :to_y, :int
      timestamps()
    end

  end
end
