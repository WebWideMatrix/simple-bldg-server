defmodule BldgServer.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :session_id, :uuid
      add :resident_id, :integer
      add :email, :string
      add :status, :string
      add :ip_address, :string
      add :last_activity_time, :naive_datetime

      timestamps()
    end

    create unique_index(:sessions, [:session_id])
  end
end
