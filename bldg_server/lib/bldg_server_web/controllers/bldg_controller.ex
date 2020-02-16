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
    render(conn, "index.json", bldgs: bldgs)
  end

  def figure_out_flr(entity) do
    %{"container_web_url" => container} = entity
    container_bldg = Buildings.get_by_web_url!(container)
    container_address = container_bldg.address
    Map.put(entity, "flr", "#{container_address}-l0")
  end

  def decide_on_location(entity) do
    %{"flr" => flr} = entity
    {x, y} = {:rand.uniform(200), :rand.uniform(200)}
    Map.merge(entity, %{"address" => "#{flr}-b(#{x},#{y})", "x" => x, "y" => y})
  end

  def remove_build_params(entity) do
    Map.delete(entity, "container_web_url")
  end

  @doc """
    Received data for some entity, e.g.:
    "entity": {
      "container_web_url": "https://fromteal.app",
      "web_url": "https://dibau.wordpress.com/",
      "name": "Udi h Bauman",
      "entity_type": "member",
      "state": "approved",
      "summary": "Playing computer programming in the fromTeal band",
      "picture_url": "https://d1qb2nb5cznatu.cloudfront.net/users/9798944-original?1574104158"
    }
    Creates a building matching the entity, e.g.:
    "bldg": {
      "address": "g-b(17,24)-l0-b(55,135)",
      "flr": "g-b(17,24)-l0",
      "x": 55,
      "y": 135,
      "is_composite": false,
      "web_url": "https://dibau.wordpress.com/",
      "name": "Udi h Bauman",
      "entity_type": "member",
      "state": "approved",
      "summary": "Playing computer programming in the fromTeal band",
      "picture_url": "https://d1qb2nb5cznatu.cloudfront.net/users/9798944-original?1574104158"
    }
  """
  def build(conn, %{"entity" => entity}) do
    bldg_params = entity
    |> figure_out_flr()
    |> decide_on_location()
    |> remove_build_params()
    create(conn, %{"bldg" => bldg_params})
  end

end
