defmodule BldgServer.Repo.Migrations.AddNestingDepthToResident do
  use Ecto.Migration

  def change do
    alter table("residents") do
      add :nesting_depth, :integer
    end
  end
end
