defmodule BldgServer.Repo.Migrations.AddFlrUrlToResident do
  use Ecto.Migration

  def change do

    alter table("residents") do
      add :flr_url, :string
    end

  end
end
