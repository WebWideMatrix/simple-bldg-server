defmodule BldgServer.Repo.Migrations.AddBldgUrlField do
  use Ecto.Migration

  def change do
    alter table("bldgs") do
      add :bldg_url, :string
    end
  end
end
