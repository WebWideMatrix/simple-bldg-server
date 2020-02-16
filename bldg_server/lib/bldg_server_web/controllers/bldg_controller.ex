defmodule BldgServerWeb.BldgController do
  use BldgServerWeb, :controller

  alias BldgServer.Buildings
  alias BldgServer.Buildings.Bldg

  action_fallback BldgServerWeb.FallbackController

  def look(conn, %{"flr" => flr}) do
    bldgs = Buildings.list_bldgs_in_flr(flr)
    render(conn, "index.json", bldgs: bldgs)
  end

  def index(conn, _params) do
    bldgs = Buildings.list_bldgs()
    render(conn, "index.json", bldgs: bldgs)
  end

  def create(conn, %{"bldg" => bldg_params}) do
    with {:ok, %Bldg{} = bldg} <- Buildings.create_bldg(bldg_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.bldg_path(conn, :show, bldg))
      |> render("show.json", bldg: bldg)
    end
  end

  def show(conn, %{"address" => address}) do
    bldg = Buildings.get_bldg!(address)
    render(conn, "show.json", bldg: bldg)
  end

  def update(conn, %{"address" => address, "bldg" => bldg_params}) do
    bldg = Buildings.get_bldg!(address)

    with {:ok, %Bldg{} = bldg} <- Buildings.update_bldg(bldg, bldg_params) do
      render(conn, "show.json", bldg: bldg)
    end
  end

  def delete(conn, %{"address" => address}) do
    bldg = Buildings.get_bldg!(address)

    with {:ok, %Bldg{}} <- Buildings.delete_bldg(bldg) do
      send_resp(conn, :no_content, "")
    end
  end
end
