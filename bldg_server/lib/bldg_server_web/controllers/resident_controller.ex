defmodule BldgServerWeb.ResidentController do
  use BldgServerWeb, :controller

  alias BldgServer.Residents
  alias BldgServer.Residents.Resident
  alias BldgServer.Token
  alias BldgServer.ResidentsAuth
  alias BldgServer.ResidentsAuth.Session

  action_fallback BldgServerWeb.FallbackController

  def index(conn, _params) do
    residents = Residents.list_residents()
    render(conn, "index.json", residents: residents)
  end

  def login(conn, %{"email" => email}) do
    resident = Residents.get_resident_by_email!(email)
    with session_id <- Residents.login(conn, resident) do
      partial_resident = %Resident{email: resident.email, session_id: session_id}
      IO.inspect(partial_resident)
      conn
      |> put_status(:ok)
      |> put_resp_header("location", Routes.resident_path(conn, :show, resident))
      |> render("show.json", resident: partial_resident)
    end
  end

  def verify_email(conn, %{"token" => token}) do
    ip_addr = conn.remote_ip |> :inet_parse.ntoa |> to_string()
    pending_status = ResidentsAuth.pending_verification()
    # decrypt token & retrieve the session & resident records
    # also check the session - status should be pending-verificaion & ip-address should be the same as the current caller
    with {:ok, session_id} <- BldgServer.Token.verify_login_token(token),
          %Session{status: ^pending_status, ip_address: ^ip_addr} = session <- ResidentsAuth.get_session_by_session_id!(session_id),
          resident <- Residents.get_resident!(session.resident_id) do
        # TODO extra validation - check session date for expiration
        if resident.session_id != nil do
          ResidentsAuth.mark_old_session_as_replaced(resident.session_id)
        end
        {:ok, %Session{}} = ResidentsAuth.mark_as_verified(session)
        {:ok, %Resident{}} = Residents.update_session_id(resident, session.session_id)
        send_resp(conn, 200, "Welcome to fromTeal!")
    else
      _ -> send_resp(conn, 401, "Could not validate session.")
    end
  end

  def verify_email(conn, _) do
    # If there is no token in our params, tell the user they've provided
    # an invalid token or expired token
    conn
    |> send_resp(400, "The verification link is invalid.")
  end

  def verification_status(conn, %{"email" => email, "session_id" => session_id}) do
    ip_addr = conn.remote_ip |> :inet_parse.ntoa |> to_string()
    verified = ResidentsAuth.verified()
    with %Session{status: ^verified, ip_address: ^ip_addr, email: ^email} = session <- ResidentsAuth.get_session_by_session_id!(session_id),
          resident <- Residents.get_resident_by_email_and_session_id!(email, session_id) do
        # TODO extra validation - check session date for expiration
        conn
        |> put_status(:ok)
        |> render("show.json", resident: resident)
    else
      #_ -> conn |> put_status(204) |> render("show.json", resident: %Resident{})
      _ -> send_resp(conn, 401, "Not verified yet.")
    end
  end

  def create(conn, %{"resident" => resident_params}) do
    with {:ok, %Resident{} = resident} <- Residents.create_resident(resident_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.resident_path(conn, :show, resident))
      |> render("show.json", resident: resident)
    end
  end

  def show(conn, %{"id" => id}) do
    resident = Residents.get_resident!(id)
    render(conn, "show.json", resident: resident)
  end

  def update(conn, %{"id" => id, "resident" => resident_params}) do
    resident = Residents.get_resident!(id)

    with {:ok, %Resident{} = resident} <- Residents.update_resident(resident, resident_params) do
      render(conn, "show.json", resident: resident)
    end
  end

  def delete(conn, %{"id" => id}) do
    resident = Residents.get_resident!(id)

    with {:ok, %Resident{}} <- Residents.delete_resident(resident) do
      send_resp(conn, :no_content, "")
    end
  end

  def look(conn, %{"flr" => flr}) do
    residents = Residents.list_residents_in_flr(flr)
    render(conn, "look.json", residents: residents)
  end

  # TODO bldgs can act as well - consolidate resident & bldg actions


  # MOVE action
  def act(conn, %{"resident_email" => email, "action_type" => "MOVE", "move_location" => location, "move_x" => x, "move_y" => y}) do
    resident = Residents.get_resident_by_email!(email)
    # TODO validate that the new location is free

    with {:ok, %Resident{}} <- Residents.move(resident, location, x, y) do
      conn
      |> put_status(:ok)
      |> put_resp_header("location", Routes.resident_path(conn, :show, resident))
      |> render("show.json", resident: resident)
    end
  end

  # TURN action
  def act(conn, %{"resident_email" => email, "action_type" => "TURN", "turn_direction" => direction}) do
    resident = Residents.get_resident_by_email!(email)

    with {:ok, %Resident{}} <- Residents.change_dir(resident, direction) do
      conn
      |> put_status(:ok)
      |> put_resp_header("location", Routes.resident_path(conn, :show, resident))
      |> render("show.json", resident: resident)
    end
  end

  # SAY action
  def act(conn, %{"resident_email" => email, "action_type" => "SAY", "say_speaker" => speaker, "say_text" => text, "say_time" => msg_time, "say_flr" => flr, "say_location" => location, "say_mimetype" => msg_mimetype, "say_recipient" => recipient} = msg) do
    resident = Residents.get_resident_by_email!(email)

    with {:ok, %Resident{}} <- Residents.say(resident, msg) do
      conn
      |> put_status(:ok)
      |> put_resp_header("location", Routes.resident_path(conn, :show, resident))
      |> render("show.json", resident: resident)
    end
  end

end
