defmodule BldgServer.Repo.Migrations.SingleBatteryInBldg do
  use Ecto.Migration

  def change do
    create unique_index(:batteries, [:bldg_address, :is_attached], name: :single_attached_battery_in_bldg)
  end
end
