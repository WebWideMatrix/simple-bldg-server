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

  def figure_out_flr(entity) do
    %{"container_web_url" => container} = entity
    container_bldg = Buildings.get_by_web_url(container)
    # TODO check for nil
    container_address = container_bldg.address
    Map.put(entity, "flr", "#{container_address}-l0")
  end


"""
next_location(similar_bldgs)
1. Go over similar_bldgs, & store their locations in a cache
2. Sort the cache by location x, y
2. Go over the cache, & find the start location (sx, sy) - minimal x, minimal y (since origin is bottom left, & we’ll be adding bldgs to the right)
3. Loop over the possible locations, from sx to max_x, and from sy to max_y, each time checking whether the current location exists in cache
4. If not, return that location
5. If finished looping over all possible locations, and sx>0, return the point (sx-1, sy)


Given an entity:
1. Loop until reached max retries:
1.1. Get similar_bldgs
1.2. Get next_location
1.3. Try to store the entity in that location
1.4. If done, return
1.5. Else, continue the loop
"""

  def get_locations_map(bldgs) do
    Enum.map(bldgs, fn bldg -> {bldg.x, bldg.y} end)
  end

  def get_minimal_location(locations) do
    locations
    |> Enum.sort()
    |> List.first()
  end

  def get_next_available_location(locations, start_location, max_x, max_y) do
    {x, y} = start_location
    Enum.reduce_while(y..max_y, nil, fn y, _ ->
      options = for i <- x..max_x, do: {i,y}
      whats_available = Enum.map(options, fn loc -> Enum.member?(locations, loc) end)
      pos = Enum.find_index(whats_available, fn b -> !b end)
      case pos do
        nil -> {:cont, nil}
        _ -> {:halt, Enum.at(options, pos)}
      end
    end)
  end

  def get_next_location(similar_bldgs, max_x, max_y) do
    locations = get_locations_map(similar_bldgs)
    start_location = get_minimal_location(locations)
    get_next_available_location(locations, start_location, max_x, max_y)
  end

  def decide_on_location(entity) do
    # floor width is: 16
    max_x = 16
    # floor height is: 12
    max_y = 12
    # TODO read from config

    %{"flr" => flr} = entity
    # TODO if no parent is given, place in 'g' level

    # TODO if location is given, don't try to decide based on similar bldgs

    # try to find place near entities of the same entity-type
    %{"entity_type" => entity_type} = entity
    similar_bldgs = Buildings.get_similar_entities(flr, entity_type)
    [x, y] = case similar_bldgs do
      [] -> [:rand.uniform(max_x - 1) + 1, :rand.uniform(max_y - 1) + 1]
      _ -> get_next_location(similar_bldgs, max_x, max_y)
    end
    Map.merge(entity, %{"address" => "#{flr}-b(#{x},#{y})", "x" => x, "y" => y})
    # TODO handle the case where the location is already caught
  end

  def remove_build_params(entity) do
    Map.delete(entity, "container_web_url")
  end

  @doc """
    Receives data for some entity, e.g.:
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

  def relocate(conn, %{"address" => address, "new_address" => new_address}) do
    # get the last part of the address: "g-b(17,24)-l0-b(11,6)" -> "b(11,6)"
    coords_token = new_address
    |> String.split("-")
    |> List.last()
    # get the coordinates: "b(11,6)" -> (11,6)
    [[new_x_s], [new_y_s]] = Regex.scan(~r{\d+}, coords_token)
    {{new_x, ""}, {new_y, ""}} = {Integer.parse(new_x_s), Integer.parse(new_y_s)}
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
