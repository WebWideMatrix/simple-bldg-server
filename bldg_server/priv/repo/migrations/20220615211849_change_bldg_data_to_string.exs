defmodule BldgServer.Repo.Migrations.ChangeBldgDataToString do
  use Ecto.Migration

  def change do
    alter table(:bldgs) do
      modify :data, :string
    end
  end
end
