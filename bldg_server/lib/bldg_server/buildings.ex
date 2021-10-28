defmodule BldgServer.Buildings do
  @moduledoc """
  The Buildings context.
  """

  import Ecto.Query, warn: false, only: [from: 2]
  alias BldgServer.Repo

  alias BldgServer.Buildings.Bldg

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
    %Bldg{}
    |> Bldg.changeset(attrs)
    |> Repo.insert()
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
    # get the last part of the address: "g-b(17,24)-l0-b(11,6)" -> "b(11,6)"
    coords_token = addr
    |> String.split("-")
    |> List.last()
    # get the coordinates: "b(11,6)" -> (11,6)
    [[x_s], [y_s]] = Regex.scan(~r{\d+}, coords_token)
    {{x, ""}, {y, ""}} = {Integer.parse(x_s), Integer.parse(y_s)}
    {x, y}
  end

end
