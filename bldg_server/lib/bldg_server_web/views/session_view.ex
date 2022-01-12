defmodule BldgServerWeb.SessionView do
  use BldgServerWeb, :view
  alias BldgServerWeb.SessionView

  def render("index.json", %{sessions: sessions}) do
    %{data: render_many(sessions, SessionView, "session.json")}
  end

  def render("show.json", %{session: session}) do
    %{data: render_one(session, SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{id: session.id,
      session_id: session.session_id,
      resident_id: session.resident_id,
      email: session.email,
      status: session.status,
      ip_address: session.ip_address,
      last_activity_time: session.last_activity_time}
  end
end
