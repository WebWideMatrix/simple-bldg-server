defmodule BldgServerWeb.BldgView do
  use BldgServerWeb, :view
  alias BldgServerWeb.BldgView

  def render("index.json", %{bldgs: bldgs}) do
    %{data: render_many(bldgs, BldgView, "bldg.json")}
  end

  def render("show.json", %{bldg: bldg}) do
    %{data: render_one(bldg, BldgView, "bldg.json")}
  end

  def render("bldg.json", %{bldg: bldg}) do
    %{id: bldg.id,
      address: bldg.address,
      flr: bldg.flr,
      x: bldg.x,
      y: bldg.y,
      is_composite: bldg.is_composite,
      name: bldg.name,
      web_url: bldg.web_url,
      entity_type: bldg.entity_type,
      state: bldg.state,
      category: bldg.category,
      tags: bldg.tags,
      summary: bldg.summary,
      picture_url: bldg.picture_url,
      data: bldg.data}
  end
end
