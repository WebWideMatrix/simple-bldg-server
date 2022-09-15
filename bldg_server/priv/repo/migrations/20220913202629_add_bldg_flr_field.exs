defmodule BldgServer.Repo.Migrations.AddBldgFlrField do
  use Ecto.Migration

  def change do
    alter table("bldgs") do
      add :flr_url, :string
    end
  end
end
