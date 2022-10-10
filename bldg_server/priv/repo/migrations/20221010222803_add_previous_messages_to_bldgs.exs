defmodule BldgServer.Repo.Migrations.AddPreviousMessagesToBldgs do
  use Ecto.Migration

  def change do
    alter table("bldgs") do
      add :previous_messages, {:array, :text}
    end
  end
end
