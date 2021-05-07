defmodule BldgServer.Batteries.Battery do
  use Ecto.Schema
  import Ecto.Changeset

  schema "batteries" do
    field :battery_type, :string
    field :battery_vendor, :string
    field :battery_version, :string
    field :bldg_address, :string
    field :callback_url, :string
    field :direct_only, :boolean, default: false
    field :flr, :string
    field :is_attached, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(battery, attrs) do
    battery
    |> cast(attrs, [:bldg_address, :flr, :callback_url, :is_attached, :direct_only, :battery_type, :battery_version, :battery_vendor])
    |> validate_required([:bldg_address, :flr, :callback_url])
  end
end
