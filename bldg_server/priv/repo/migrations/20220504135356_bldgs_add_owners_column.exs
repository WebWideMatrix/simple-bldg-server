defmodule BldgServer.Repo.Migrations.BldgsAddOwnersColumn do
  use Ecto.Migration

  def change do
    alter table("bldgs") do
      add :owners, {:array, :string}
    end

    alter table("roads") do
      add :owners, {:array, :string}
    end
  end
end
