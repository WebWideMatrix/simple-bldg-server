defmodule BldgServer.Repo.Migrations.ChangeBatteryToUseBldgUrl do
  use Ecto.Migration

  def change do
    rename table(:batteries), :bldg_address, to: :bldg_url
  end
end
