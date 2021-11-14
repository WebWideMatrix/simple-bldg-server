defmodule BldgServer.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :bldg, :string
      add :resident, :string
      add :message, :string

      timestamps()
    end

  end
end
