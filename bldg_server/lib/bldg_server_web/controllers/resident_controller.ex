defmodule BldgServerWeb.ResidentController do
  use BldgServerWeb, :controller

  alias BldgServer.Residents
  alias BldgServer.Residents.Resident

  action_fallback BldgServerWeb.FallbackController

  def index(conn, _params) do
    residents = Residents.list_residents()
    render(conn, "index.json", residents: residents)
  end

  def login(conn, %{"email" => email}) do
    resident = Residents.get_resident_by_email!(email)
    # TODO perform authentication based on email verification

    with {:ok, %Resident{}} <- Residents.login(resident) do
      conn
      |> put_status(:ok)
      |> put_resp_header("location", Routes.resident_path(conn, :show, resident))
      |> render("show.json", resident: resident)
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
end
