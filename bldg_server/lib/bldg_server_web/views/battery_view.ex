defmodule BldgServerWeb.BatteryView do
  use BldgServerWeb, :view
  alias BldgServerWeb.BatteryView

  def render("index.json", %{batteries: batteries}) do
    %{data: render_many(batteries, BatteryView, "battery.json")}
  end

  def render("show.json", %{battery: battery}) do
    %{data: render_one(battery, BatteryView, "battery.json")}
  end

  def render("battery.json", %{battery: battery}) do
    %{id: battery.id,
      bldg_url: battery.bldg_url,
      flr: battery.flr,
      callback_url: battery.callback_url,
      is_attached: battery.is_attached,
      direct_only: battery.direct_only,
      battery_type: battery.battery_type,
      battery_version: battery.battery_version,
      battery_vendor: battery.battery_vendor}
  end
end
