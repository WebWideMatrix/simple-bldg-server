defmodule BldgServer.Repo.Migrations.ChangeDataToText do
  use Ecto.Migration

  def change do
    alter table(:bldgs) do
      modify :data, :text
    end
  end
end
