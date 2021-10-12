defmodule BldgServer.Residents do
  @moduledoc """
  The Residents context.
  """

  import Ecto.Query, warn: false
  alias BldgServer.Repo

  alias BldgServer.Residents.Resident

  @doc """
  Returns the list of residents.

  ## Examples

      iex> list_residents()
      [%Resident{}, ...]

  """
  def list_residents do
    Repo.all(Resident)
  end

  @doc """
  Gets a single resident.

  Raises `Ecto.NoResultsError` if the Resident does not exist.

  ## Examples

      iex> get_resident!(123)
      %Resident{}

      iex> get_resident!(456)
      ** (Ecto.NoResultsError)

  """
  def get_resident!(id), do: Repo.get!(Resident, id)

  @doc """
  Gets a single resident by email.

  Raises `Ecto.NoResultsError` if the Resident does not exist.

  ## Examples

      iex> get_resident_by_email!("joe@doe.com")
      %Resident{}

      iex> get_resident!("notjoe@doe.com")
      ** (Ecto.NoResultsError)

  """
  def get_resident_by_email!(email), do: Repo.get_by!(Resident, email: email)

  @doc """
  Creates a resident.

  ## Examples

      iex> create_resident(%{field: value})
      {:ok, %Resident{}}

      iex> create_resident(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_resident(attrs \\ %{}) do
    %Resident{}
    |> Resident.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a resident.

  ## Examples

      iex> update_resident(resident, %{field: new_value})
      {:ok, %Resident{}}

      iex> update_resident(resident, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_resident(%Resident{} = resident, attrs) do
    resident
    |> Resident.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a resident.

  ## Examples

      iex> delete_resident(resident)
      {:ok, %Resident{}}

      iex> delete_resident(resident)
      {:error, %Ecto.Changeset{}}

  """
  def delete_resident(%Resident{} = resident) do
    Repo.delete(resident)
  end


  @doc """
  Logs in a resident, following authentication.
  - location would be the last known location or home bldg. 
  - should generate a new session_id
  - update last_login_at & is_online

  ## Examples

      iex> login(resident)
      {:ok, %Resident{}}

  """
  def login(%Resident{} = resident) do
    changes = %{is_online: true, last_login_at: DateTime.utc_now(), sesion_id: UUID.uuid4()} 
    update_resident(resident, changes)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking resident changes.

  ## Examples

      iex> change_resident(resident)
      %Ecto.Changeset{source: %Resident{}}

  """
  def change_resident(%Resident{} = resident) do
    Resident.changeset(resident, %{})
  end
end
