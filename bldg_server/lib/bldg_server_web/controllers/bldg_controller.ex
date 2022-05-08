defmodule BldgServerWeb.BldgController do
  use BldgServerWeb, :controller

  alias BldgServer.Buildings
  alias BldgServer.Buildings.Bldg

  action_fallback BldgServerWeb.FallbackController

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

  def look(conn, %{"flr" => flr}) do
    bldgs = Buildings.list_bldgs_in_flr(flr)
    render(conn, "look.json", bldgs: bldgs)
  end


  def build(conn, %{"entity" => entity}) do
    bldg = Buildings.build(entity)
    create(conn, %{"bldg" => bldg})
  end


  def relocate(conn, %{"address" => address, "new_address" => new_address}) do
    {new_x, new_y} = Buildings.extract_coords(new_address)
    bldg_params = %{"address" => new_address, "x" => new_x, "y" => new_y}
    update(conn, %{"address" => address, "bldg" => bldg_params})
  end


  @doc """
  Receives a web_url & returns the address of the bldg matching it.
  """
  def resolve_address(conn, %{"web_url" => escaped_web_url}) do
    web_url = URI.decode(escaped_web_url)
    case Buildings.get_by_web_url(web_url) do
      nil -> conn
              |> put_status(:not_found)
              |> text("Coudn't find a matching building")
      bldg -> text conn, bldg.address
    end
  end

end
