defmodule BldgServer.Repo.Migrations.AddBldgDerivedFields do
  use Ecto.Migration

  def change do
    alter table("bldgs") do
      add :flr_level, :integer
    end

    alter table("bldgs") do
      add :nesting_depth, :integer
    end
  end

end
