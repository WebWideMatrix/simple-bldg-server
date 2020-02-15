defmodule BldgServer.Repo.Migrations.IndexedAndNullableBldgFields do
  use Ecto.Migration

  def change do
    create index(:bldgs, [:flr])
    alter table(:bldgs) do
      modify :state, :string, null: true
      modify :category, :string, null: true
      modify :tags, {:array, :string}, null: true
      modify :summary, :string, null: true
      modify :picture_url, :string, null: true
      modify :data, :map, null: true
    end
  end
end
