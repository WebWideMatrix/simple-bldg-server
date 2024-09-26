defmodule BldgServer.Repo.Migrations.AddContainerEntityTypeToResident do
  use Ecto.Migration

  def change do
    alter table("residents") do
      add :container_entity_type, :string
    end
  end
end
