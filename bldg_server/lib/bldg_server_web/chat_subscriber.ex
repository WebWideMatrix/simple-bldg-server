defmodule BldgServerWeb.ChatSubscriber do
  use GenServer
  require Logger
  alias BldgServer.PubSub

  alias BldgServer.Batteries


  def start_link(_) do
    GenServer.start_link(__MODULE__, name: __MODULE__)
  end

  def init(_) do
    Phoenix.PubSub.subscribe(PubSub, "chat")
    IO.puts("subscribed")
    {:ok, %{}}
  end

  def handle_call(:get, _, state) do
    {:reply, state, state}
  end


  def send_message_to_battery(callback_url, msg) do
    Logger.info("About to invoke battery callback URL at: #{callback_url}")
    header_key = "content-type"
    header_val = "application/json"
    {_, msg_json} = Jason.encode(msg)
    Finch.build(:post, callback_url, [{header_key, header_val}], msg_json) 
    |> Finch.request(FinchClient)
    |> IO.inspect()
  end


  #def handle_info({sender, message, flr}, state) do
  def handle_info(%{event: "new_message", payload: new_message}, state) do
    #Logger.info("chat message received at #{flr} from #{sender}: #{message}")
    Logger.info("chat message received: #{new_message["message"]}")

    # query for all batteries inside that message flr
    # & invoke the callback url per each battery, with the message details in the body

    batteries = new_message["flr"]
    |> Batteries.get_batteries_in_floor()
    |> Enum.map(fn b -> send_message_to_battery(b.callback_url, new_message) end)

    {:noreply, state}
  end
end