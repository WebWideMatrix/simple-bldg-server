defmodule BldgServer.ResidentsAuth do
  @moduledoc """
  The ResidentsAuth context.
  """

  import Ecto.Query, warn: false
  alias BldgServer.Repo

  alias BldgServer.ResidentsAuth.Session

  def pending_verification, do: "PENDING-VERIFICATION"
  def verified, do: "VERIFIED"
  def replaced, do: "REPLACED"

  @doc """
  Returns the list of sessions.

  ## Examples

      iex> list_sessions()
      [%Session{}, ...]

  """
  def list_sessions do
    Repo.all(Session)
  end

  @doc """
  Gets a single session.

  Raises `Ecto.NoResultsError` if the Session does not exist.

  ## Examples

      iex> get_session!(123)
      %Session{}

      iex> get_session!(456)
      ** (Ecto.NoResultsError)

  """
  def get_session!(id) do
    Repo.get!(Session, id)
  end


  def get_session_by_session_id!(session_id) do 
    IO.puts("looking up session by session id: #{session_id}")
    Repo.get_by!(Session, session_id: session_id)
  end

  def get_session_by_session_id(session_id) do 
    IO.puts("looking up session by session id: #{session_id}")
    Repo.get_by(Session, session_id: session_id)
  end


  @doc """
  Creates a session.

  ## Examples

      iex> create_session(%{field: value})
      {:ok, %Session{}}

      iex> create_session(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_session(attrs \\ %{}) do
    IO.inspect(attrs)
    %Session{}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a session.

  ## Examples

      iex> update_session(session, %{field: new_value})
      {:ok, %Session{}}

      iex> update_session(session, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_session(%Session{} = session, attrs) do
    session
    |> Session.changeset(attrs)
    |> Repo.update()
  end

  # mark the active session for a resident as replaced
  def mark_old_session_as_replaced(old_session_id) do
    IO.puts("Marking old session as replaced: #{old_session_id}")
    case get_session_by_session_id(old_session_id) do
      nil -> {:error, "Old session not found"} 
      old_session -> update_session(old_session, %{status: replaced}) # TODO update last activity time
    end
  end


  def mark_as_verified(%Session{} = session) do
    IO.puts("Marking session as verified: #{session.session_id}")
    # TODO update last activity time
    update_session(session, %{status: verified})
  end

  @doc """
  Deletes a session.

  ## Examples

      iex> delete_session(session)
      {:ok, %Session{}}

      iex> delete_session(session)
      {:error, %Ecto.Changeset{}}

  """
  def delete_session(%Session{} = session) do
    Repo.delete(session)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking session changes.

  ## Examples

      iex> change_session(session)
      %Ecto.Changeset{data: %Session{}}

  """
  def change_session(%Session{} = session, attrs \\ %{}) do
    Session.changeset(session, attrs)
  end
end
