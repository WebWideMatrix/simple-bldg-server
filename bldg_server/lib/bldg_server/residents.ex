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
  Returns all residents inside a given flr.

  Returns empty list if no such resident exists.
  """
  def list_residents_in_flr(flr) do
    q = from r in Resident, where: r.flr == ^flr
    Repo.all(q)
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
  def login(%Resident{} = resident, ip_addr) do

    token = BldgServer.Token.generate_login_token(resident, ip_addr)
    verification_url = "TODO generate or hard code the url" # user_url(conn, :verify_email, token: token)
    BldgServer.Notifications.send_login_verification_email(resident, verification_url)

    changes = %{is_online: true, last_login_at: DateTime.utc_now(), sesion_id: UUID.uuid4()} 
    update_resident(resident, changes)
  end

  @doc """
  Performs a move action for a resident, following validation of the action.
  Updates the location, x & y attributes.

  ## Examples

      iex> move(resident, "g/b(14, 25)", 14, 25)
      {:ok, %Resident{}}

  """
  def move(%Resident{} = resident, location, x, y) do
    changes = %{location: location, x: x, y: y}
    update_resident(resident, changes)
  end

  def change_dir(%Resident{} = resident, direction) do
    changes = %{direction: direction}
    update_resident(resident, changes)
  end

  def append_message_to_list(msg_list, msg) do
    case msg_list do
      nil -> [msg]
      _ -> [msg | msg_list]
    end
  end

  
  def is_command(msg_text), do: String.at(msg_text, 0) == "/"


  def say(%Resident{} = resident, msg) do
    {_, text} = JSON.encode(msg)

    new_prev_messages = append_message_to_list(resident.previous_messages, text)
    changes = %{previous_messages: new_prev_messages}
    result = update_resident(resident, changes)

    # the message may be a command for bldg manipulation, so
    # broadcast an event for it, so that the command executor can process it
    if is_command(msg["say_text"]) do
      BldgServerWeb.Endpoint.broadcast!(
        "chat",
        "new_message",
        msg
      )
    end
    
    result
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
