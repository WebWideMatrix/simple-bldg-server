defmodule BldgServer.Relations.Road do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roads" do
    field :flr, :string
    field :from_address, :string
    field :to_address, :string
    field :from_x, :integer
    field :from_y, :integer
    field :to_x, :integer
    field :to_y, :integer

    timestamps()
  end

  @doc false
  def changeset(road, attrs) do
    road
    |> cast(attrs, [:flr, :from_address, :to_address])
    |> validate_required([:flr, :from_address, :to_address])
  end
end
