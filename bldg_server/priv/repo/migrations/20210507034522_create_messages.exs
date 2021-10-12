defmodule BldgServer.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :sender, :string, null: false
      add :sender_name, :string, null: false
      add :message, :string, null: false
      add :flr, :string, null: false
      add :message_type, :string, default: "text-message", null: false
      add :in_reply_to_message, :string
      add :recipient, :string
      add :speech_act, :string
      add :entity_type, :string
      add :entity_id, :string
      add :params, :string

      timestamps()
    end

  end
end
