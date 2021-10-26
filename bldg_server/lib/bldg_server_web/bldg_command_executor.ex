defmodule BldgServerWeb.BldgCommandExecutor do
    use GenServer
    require Logger
    alias BldgServer.PubSub
    alias BldgServer.Buildings
    
  
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

    def parse_command(msg_text) do
        String.split(msg_text, " ")
    end


    def invoke_bldg_server_api(url, payload) do
        Logger.info("About to invoke bldg server URL at: #{url}")
        header_key = "content-type"
        header_val = "application/json"
        {_, payload_json} = Jason.encode(payload)
        Finch.build(:post, url, [{header_key, header_val}], payload_json) 
        |> Finch.request(FinchClient)
        |> IO.inspect()
    end

    # create bldg with entity-type, name & website
    def execute_command(["/create", entity_type, "bldg", "with", "name", name, "and", "website", website] = msg_parts, msg) do
        # create a bldg with the given entity-type & name, inside the given flr & bldg
        # TODO validate that the actor resident/bldg has the sufficient permissions

        # TODO if creating under a given bldg, send its container_web_url instead of flr

        {x, y} = Buildings.extract_coords(msg["say_location"])
        data = %{
            entity: %{
                flr: msg["say_flr"],
                address: msg["say_location"],
                x: x,
                y: y,
                web_url: website,
                name:  name,
                entity_type:  entity_type,
                state:  "approved"
            }
        }
        url = "http://localhost:4000/v1/bldgs/build"
        invoke_bldg_server_api(url, data)
    end

    #def handle_info({sender, message, flr}, state) do
    def handle_info(%{event: "new_message", payload: new_message}, state) do
      #Logger.info("chat message received at #{flr} from #{sender}: #{message}")
      Logger.info("chat message received: #{new_message["message"]}")
      
      msg_text = new_message["say_text"]
      |> parse_command()
      |> execute_command(new_message)

      {:noreply, state}
    end
  end