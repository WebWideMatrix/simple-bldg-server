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

    # create bldg with entity-type, name & website
    def execute_command(["/create", entity_type, "bldg", "with", "name", name, "and", "website", website] = msg_parts, msg) do
        # create a bldg with the given entity-type & name, inside the given flr & bldg
        # TODO validate that the actor resident/bldg has the sufficient permissions

        # TODO if creating under a given bldg, send its container_web_url instead of flr

        {x, y} = Buildings.extract_coords(msg["say_location"])
        entity = %{
          "flr" => msg["say_flr"],
          "address" => msg["say_location"],
          "x" => x,
          "y" => y,
          "web_url" => website,
          "name" => name,
          "entity_type" => entity_type,
          "state" =>  "approved"
        }
        bldg = Buildings.build(entity)
        |> Buildings.create_bldg()
    end


    # create bldg with entity-type, name & summary
    def execute_command(["/create", entity_type, "bldg", "with", "name", name, "and", "summary" | summary_tokens] = msg_parts, msg) do
      # create a bldg with the given entity-type, name & summary, inside the given flr & bldg
      # TODO validate that the actor resident/bldg has the sufficient permissions

      # TODO if creating under a given bldg, send its container_web_url instead of flr

      {x, y} = Buildings.extract_coords(msg["say_location"])
      entity = %{
        "flr" => msg["say_flr"],
        "address" => msg["say_location"],
        "x" => x,
        "y" => y,
        "web_url" => "https://fromteal.app/#{msg["say_location"]}/#{entity_type}/#{name}",
        "name" =>  name,
        "entity_type" =>  entity_type,
        "summary" =>  Enum.join(summary_tokens, " "),
        "state" =>  "approved"
      }
      bldg = Buildings.build(entity)
      |> Buildings.create_bldg()
    end

    # create bldg with entity-type, name, website & picture
    def execute_command(["/create", entity_type, "bldg", "with", "name", name, "and", "website", website, "and", "picture", picture_url] = msg_parts, msg) do
        # create a bldg with the given entity-type, name, website & picture url, inside the given flr & bldg
        # TODO validate that the actor resident/bldg has the sufficient permissions

        # TODO if creating under a given bldg, send its container_web_url instead of flr

        {x, y} = Buildings.extract_coords(msg["say_location"])
        entity = %{
          "flr" => msg["say_flr"],
          "address" => msg["say_location"],
          "x" => x,
          "y" => y,
          "web_url" => website,
          "name" => name,
          "entity_type" => entity_type,
          "picture_url" => picture_url,
          "state" =>  "approved"
        }
        bldg = Buildings.build(entity)
        |> Buildings.create_bldg()
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