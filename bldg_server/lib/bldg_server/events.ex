defmodule BldgServer.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false, only: [from: 2]
  alias BldgServer.Repo

  alias BldgServer.Events.Event


  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end


  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event_by_bldg!(123)
      %Bldg{}

      iex> get_event_by_bldg!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event_by_bldg!(address), do: Repo.get_by!(Event, bldg: address)


  @doc """
  Creates a bldg.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  # TODO: Do we need code to update event?

  @doc """
  Deletes an Event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

end
