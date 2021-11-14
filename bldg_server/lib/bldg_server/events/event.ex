defmodule BldgServer.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :bldg, :string
    field :message, :string
    field :resident, :string

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:bldg, :resident, :message])
    |> validate_required([:bldg, :resident, :message])
  end
end
