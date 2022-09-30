defmodule BldgServer.Buildings do
  @moduledoc """
  The Buildings context.
  """

  import Ecto.Query, warn: false, only: [from: 2]
  alias BldgServer.Repo

  alias BldgServer.Buildings.Bldg


  def address_delimiter, do: "/"

  @doc """
  Returns the list of bldgs.

  ## Examples

      iex> list_bldgs()
      [%Bldg{}, ...]

  """
  def list_bldgs do
    Repo.all(Bldg)
  end

  @doc """
  Returns all bldgs under a given flr.

  Returns empty list if no such Bldg does exists.
  """
  def list_bldgs_in_flr(flr) do
    q = from b in Bldg, where: b.flr == ^flr
    Repo.all(q)
  end



  @doc """
  Gets a single bldg.

  Raises `Ecto.NoResultsError` if the Bldg does not exist.

  ## Examples

      iex> get_bldg!(123)
      %Bldg{}

      iex> get_bldg!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bldg!(address), do: Repo.get_by!(Bldg, address: address)

  def get_by_web_url(url), do: Repo.get_by(Bldg, web_url: url)

  def get_by_bldg_url(bldg_url), do: Repo.get_by(Bldg, bldg_url: bldg_url)

  def get_similar_entities(flr, entity_type) do
    q = from b in Bldg,
        where: b.flr == ^flr and b.entity_type == ^entity_type,
        order_by: b.inserted_at
    Repo.all(q)
  end

  @doc """
  Creates a bldg.

  ## Examples

      iex> create_bldg(%{field: value})
      {:ok, %Bldg{}}

      iex> create_bldg(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bldg(attrs \\ %{}) do
    cs = %Bldg{}
    |> Bldg.changeset(attrs)
    case cs.errors do
      [] -> Repo.insert(cs)
      _ ->
        IO.inspect(cs.errors)
        raise "Failed to prepare bldg for writing to database"
    end
  end

  @doc """
  Updates a bldg.

  ## Examples

      iex> update_bldg(bldg, %{field: new_value})
      {:ok, %Bldg{}}

      iex> update_bldg(bldg, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bldg(%Bldg{} = bldg, attrs) do
    bldg
    |> Bldg.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bldg.

  ## Examples

      iex> delete_bldg(bldg)
      {:ok, %Bldg{}}

      iex> delete_bldg(bldg)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bldg(%Bldg{} = bldg) do
    Repo.delete(bldg)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bldg changes.

  ## Examples

      iex> change_bldg(bldg)
      %Ecto.Changeset{source: %Bldg{}}

  """
  def change_bldg(%Bldg{} = bldg) do
    Bldg.changeset(bldg, %{})
  end


  # UTILS

  def extract_coords(addr) do
    # get the coords from the last part of the address: "g/b(17,24)/l0/b(-11,6)" -> ["-11","6]
    [x_s, y_s] = addr
    |> String.split(address_delimiter)
    |> List.last()
    |> String.slice(2..-2)
    |> String.split(",")
    {{x, ""}, {y, ""}} = {Integer.parse(x_s), Integer.parse(y_s)}
    {x, y}
  end

  def extract_flr_level(flr) do
    l_s = case flr do
      "g" -> "0"
      _ -> flr |> String.split(address_delimiter) |> List.last() |> String.slice(1..-1)
    end
    {level, ""} = Integer.parse(l_s)
    level
  end

  def move_from_speaker({x, y}, offset) do
    {x, y + offset}
  end


  def get_container(addr) do
    addr
    |> String.split(address_delimiter)
    |> Enum.reverse()
    |> tl()
    |> Enum.reverse()
    |> Enum.join(address_delimiter)
  end

  def get_container_flr(addr) do
    # returns the container flr for given address.
    # TODO verify that a bldg is given & not a flr
    # TODO if addr is g, return g? null?
    get_container(addr)
  end

  def get_container_flr_url(bldg_url) do
    # returns the container flr url for given bldg url.
    # TODO verify that a bldg is given & not a flr
    # TODO if bldg url is g, return g? null?
    get_container(bldg_url)
  end

  def get_flr_bldg(flr) do
    case flr do
      "g" -> "g"
      _ -> get_container(flr)
    end
  end


  # FRAMEWORK


  """
  Determines the flr of a new entity to be created
  Calculates the following fields:
  - flr (address)
  - flr_url (bldg_url of the flr)
  -  flr_level (flr number)
  And returns the given entity with these 3 additional fields

  Supports 3 modes:
  1. Receiving just container bldg address -> flr would be l0 on that bldg
  2. Receiving just container bldg url -> flr would be l0 on that bldg
  3. Receiving the flr & flr_url -> no need to figure out, just extract the flr level

  Note that providing just flr or flr_url isn't currently supported.

  TODO simplify
  """
  def figure_out_flr(entity) do
    {flr, flr_url, flr_level} = cond do
      Map.has_key?(entity, "container_web_url") ->
        %{"container_web_url" => container} = entity
        entity_bldg = Buildings.get_by_web_url(container)
        # TODO handle the case the container bldg doesn't exist
        {"#{entity_bldg.address}#{Buildings.address_delimiter}l0", "#{entity_bldg.bldg_url}#{Buildings.address_delimiter}l0", 0}
      Map.has_key?(entity, "container_bldg_url") ->
        %{"container_bldg_url" => container} = entity
        entity_bldg = Buildings.get_by_bldg_url(container)
        {"#{entity_bldg.address}#{Buildings.address_delimiter}l0", "#{entity_bldg.bldg_url}#{Buildings.address_delimiter}l0", 0}
      Map.has_key?(entity, "flr") and Map.has_key?(entity, "flr_url") ->
        level = extract_flr_level(Map.get(entity, "flr"))
        {Map.get(entity, "flr"), Map.get(entity, "flr_url"), level}
      true -> raise "Not enought information to determine where to create the bldg - you need to provide either: container_web_url or container_bldg_url or (flr AND flr_url)"
    end
    Map.put(entity, "flr", flr)
    Map.put(entity, "flr_url", flr_url)
    Map.put(entity, "flr_level", flr_level)
  end

  def figure_out_bldg_url(entity) do
    bldg_url = cond do
      Map.has_key?(entity, "bldg_url") ->
        Map.get(entity, "bldg_url")
      Map.has_key?(entity, "flr_url") and Map.has_key?(entity, "name") ->
        "#{Map.get(entity, "flr_url")}#{address_delimiter}#{Map.get(entity, "name")}"
      true ->
        "g"
    end
    Map.put(entity, "bldg_url", bldg_url)
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

    case Map.get(entity, "address") do
      nil ->
        # try to find place near entities of the same entity-type
        %{"flr" => flr, "entity_type" => entity_type} = entity
        similar_bldgs = Buildings.get_similar_entities(flr, entity_type)
        {x, y} = case similar_bldgs do
          [] -> {:rand.uniform(max_x - 1) + 1, :rand.uniform(max_y - 1) + 1}
          _ -> get_next_location(similar_bldgs, max_x, max_y)
        end
        Map.merge(entity, %{"address" => "#{flr}-b(#{x},#{y})", "x" => x, "y" => y})
      _ -> entity
    end
    # TODO handle the case where the location is already caught
  end


  def calculate_nesting_depth(address) do
    num_slashes = address
    |> String.split(address_delimiter)
    |> Enum.drop(1)
    |> length()
    case num_slashes do
      0 -> 0
      _ -> trunc((num_slashes + 1) / 2)
    end
  end

  def set_nesting_depth(entity) do
    depth = calculate_nesting_depth(Map.get(entity, "address"))
    Map.put(entity, "nesting_depth", depth)
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
      "address": "g/b(17,24)/l0/b(55,135)",
      "flr": "g/b(17,24)/l0",
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
  def build(entity) do
    bldg_params = entity
    |> figure_out_flr()
    |> figure_out_bldg_url()
    |> decide_on_location()
    |> set_nesting_depth()
    |> remove_build_params()
  end

end
