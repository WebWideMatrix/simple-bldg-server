defmodule BldgServer.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :entity_id, :string
    field :entity_type, :string
    field :flr, :string
    field :in_reply_to_message, :string
    field :message, :string
    field :message_type, :string
    field :params, :string
    field :recipient, :string
    field :sender, :string
    field :sender_name, :string
    field :speech_act, :string

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:sender, :sender_name, :message, :flr, :message_type, :in_reply_to_message, :recipient, :speech_act, :entity_type, :entity_id, :params])
    |> validate_required([:sender, :sender_name, :message, :flr])
  end
end
