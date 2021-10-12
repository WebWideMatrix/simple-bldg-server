defmodule BldgServer.Repo.Migrations.CreateResidents do
  use Ecto.Migration

  def change do
    create table(:residents) do
      add :email, :string
      add :alias, :string
      add :name, :string
      add :home_bldg, :string
      add :is_online, :boolean, default: false, null: false
      add :location, :string
      add :direction, :integer
      add :previous_messages, {:array, :string}
      add :other_attributes, :map
      add :session_id, :uuid
      add :last_login_at, :naive_datetime

      timestamps()
    end

    create unique_index(:residents, [:email])
  end
end
