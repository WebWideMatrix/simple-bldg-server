defmodule BldgServer.Buildings.Bldg do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bldgs" do
    field :address, :string
    field :category, :string
    field :data, :map
    field :entity_type, :string
    field :flr, :string
    field :is_composite, :boolean, default: false
    field :name, :string
    field :picture_url, :string
    field :state, :string
    field :summary, :string
    field :tags, {:array, :string}
    field :web_url, :string
    field :x, :integer
    field :y, :integer

    timestamps()
  end

  @doc false
  def changeset(bldg, attrs) do
    bldg
    |> cast(attrs, [:address, :flr, :x, :y, :is_composite, :name, :web_url, :entity_type, :state, :category, :tags, :summary, :picture_url, :data])
    |> validate_required([:address, :flr, :x, :y, :is_composite, :name, :web_url, :entity_type])
    |> unique_constraint(:address)
    |> unique_constraint(:web_url)
  end
end
