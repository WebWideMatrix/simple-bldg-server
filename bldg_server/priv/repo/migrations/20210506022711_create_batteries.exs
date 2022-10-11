defmodule BldgServer.Repo.Migrations.CreateBatteries do
  use Ecto.Migration

  def change do
    create table(:batteries) do
      add :bldg_address, :string, null: false
      add :flr, :string, null: false
      add :callback_url, :string, null: false
      add :is_attached, :boolean, default: true, null: false
      add :direct_only, :boolean, default: false, null: false
      add :battery_type, :string
      add :battery_version, :string
      add :battery_vendor, :string

      timestamps()
    end

  end
end
