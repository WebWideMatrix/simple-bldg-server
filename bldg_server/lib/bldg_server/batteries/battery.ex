defmodule BldgServer.Batteries.Battery do
  use Ecto.Schema
  import Ecto.Changeset

  schema "batteries" do
    field :battery_type, :string
    field :battery_vendor, :string
    field :battery_version, :string
    field :bldg_url, :string
    field :callback_url, :string
    field :direct_only, :boolean, default: false
    field :flr, :string
    field :is_attached, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(battery, attrs) do
    battery
    |> cast(attrs, [:bldg_url, :flr, :callback_url, :is_attached, :direct_only, :battery_type, :battery_version, :battery_vendor])
    |> validate_required([:bldg_url, :flr, :callback_url])
    |> unique_constraint(:single_attached_battery_in_bldg, name: :single_attached_battery_in_bldg)
  end
end
