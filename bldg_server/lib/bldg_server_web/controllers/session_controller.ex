defmodule BldgServerWeb.SessionController do
  use BldgServerWeb, :controller

  alias BldgServer.ResidentsAuth
  alias BldgServer.ResidentsAuth.Session

  action_fallback BldgServerWeb.FallbackController

  def index(conn, _params) do
    sessions = ResidentsAuth.list_sessions()
    render(conn, "index.json", sessions: sessions)
  end

  def create(conn, %{"session" => session_params}) do
    with {:ok, %Session{} = session} <- ResidentsAuth.create_session(session_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.session_path(conn, :show, session))
      |> render("show.json", session: session)
    end
  end

  def show(conn, %{"id" => id}) do
    session = ResidentsAuth.get_session!(id)
    render(conn, "show.json", session: session)
  end

  def update(conn, %{"id" => id, "session" => session_params}) do
    session = ResidentsAuth.get_session!(id)

    with {:ok, %Session{} = session} <- ResidentsAuth.update_session(session, session_params) do
      render(conn, "show.json", session: session)
    end
  end

  def delete(conn, %{"id" => id}) do
    session = ResidentsAuth.get_session!(id)

    with {:ok, %Session{}} <- ResidentsAuth.delete_session(session) do
      send_resp(conn, :no_content, "")
    end
  end
end
