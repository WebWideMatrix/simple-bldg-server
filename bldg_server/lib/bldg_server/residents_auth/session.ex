defmodule BldgServer.ResidentsAuth.Session do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:session_id, :binary_id, autogenerate: true}

  schema "sessions" do
    field :email, :string
    field :ip_address, :string
    field :last_activity_time, :naive_datetime
    field :resident_id, :integer
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:session_id, :resident_id, :email, :status, :ip_address, :last_activity_time])
    |> validate_required([:session_id, :resident_id, :email, :status, :ip_address, :last_activity_time])
    |> unique_constraint(:session_id)
  end
end
