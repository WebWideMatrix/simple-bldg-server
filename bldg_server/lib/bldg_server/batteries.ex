defmodule BldgServer.Batteries do
  @moduledoc """
  The Batteries context.
  """

  import Ecto.Query, warn: false
  alias BldgServer.Repo

  alias BldgServer.Batteries.Battery

  @doc """
  Returns the list of batteries.

  ## Examples

      iex> list_batteries()
      [%Battery{}, ...]

  """
  def list_batteries do
    Repo.all(Battery)
  end


  @doc """
  Returns the list of attached batteries in a given floor.

  ## Examples

      iex> get_batteries_in_floor(flr)
      [%Battery{}, ...]

  """
  def get_batteries_in_floor(flr) do
    q = from b in Battery, where: b.flr == ^flr and b.is_attached
    Repo.all(q)
  end





  @doc """
  Gets a single battery.

  Raises `Ecto.NoResultsError` if the Battery does not exist.

  ## Examples

      iex> get_battery!(123)
      %Battery{}

      iex> get_battery!(456)
      ** (Ecto.NoResultsError)

  """
  def get_battery!(id), do: Repo.get!(Battery, id)



  @doc """
  Gets a single battery by it's container bldg's address.

  Raises `Ecto.NoResultsError` if the Battery does not exist.

  ## Examples

      iex> get_battery_by_bldg_address!("g-b(10,20)")
      %Battery{}

      iex> get_battery_by_bldg_address!("g-b(30,40)")
      ** (Ecto.NoResultsError)

  """
  def get_attached_battery_by_bldg_address!(bldg_address) do
    clauses = [is_attached: :true, bldg_address: bldg_address]
    Repo.get_by!(Battery, clauses)
  end



  @doc """
  Creates a battery.

  ## Examples

      iex> create_battery(%{field: value})
      {:ok, %Battery{}}

      iex> create_battery(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_battery(attrs \\ %{}) do
    %Battery{}
    |> Battery.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a battery.

  ## Examples

      iex> update_battery(battery, %{field: new_value})
      {:ok, %Battery{}}

      iex> update_battery(battery, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_battery(%Battery{} = battery, attrs) do
    battery
    |> Battery.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a battery.

  ## Examples

      iex> delete_battery(battery)
      {:ok, %Battery{}}

      iex> delete_battery(battery)
      {:error, %Ecto.Changeset{}}

  """
  def delete_battery(%Battery{} = battery) do
    Repo.delete(battery)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking battery changes.

  ## Examples

      iex> change_battery(battery)
      %Ecto.Changeset{source: %Battery{}}

  """
  def change_battery(%Battery{} = battery) do
    Battery.changeset(battery, %{})
  end
end
