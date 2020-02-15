defmodule BldgServer.Repo.Migrations.CreateBldgs do
  use Ecto.Migration

  def change do
    create table(:bldgs) do
      add :address, :string
      add :flr, :string
      add :x, :integer
      add :y, :integer
      add :is_composite, :boolean, default: false, null: false
      add :name, :string
      add :web_url, :string
      add :entity_type, :string
      add :state, :string
      add :category, :string
      add :tags, {:array, :string}
      add :summary, :string
      add :picture_url, :string
      add :data, :map

      timestamps()
    end

    create unique_index(:bldgs, [:address])
    create unique_index(:bldgs, [:web_url])
  end
end
