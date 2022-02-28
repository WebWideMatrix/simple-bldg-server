defmodule BldgServerWeb.RoadView do
  use BldgServerWeb, :view
  alias BldgServerWeb.RoadView

  def render("index.json", %{roads: roads}) do
    %{data: render_many(roads, RoadView, "road.json")}
  end

  def render("show.json", %{road: road}) do
    %{data: render_one(road, RoadView, "road.json")}
  end

  def render("road.json", %{road: road}) do
    %{id: road.id,
      flr: road.flr,
      from_address: road.from_address,
      to_address: road.to_address}
  end
end
