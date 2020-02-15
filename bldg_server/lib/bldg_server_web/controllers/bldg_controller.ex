defmodule BldgServerWeb.BldgController do
    use BldgServerWeb, :controller

    def look(conn, %{"address" => address}) do
        {:ok, rds_conn} = Redix.start_link(host: "localhost", port: 6379)
        {:ok, buildings} = Redix.command(rds_conn, ["HGETALL", "bldgs"])
        Enum.map(buildings, &log_tuple/1)
        
        render conn, "index.json", buildings: buildings
    end

    def log_tuple(k) do
        IO.puts(k)
        IO.puts("--")
    end

    def build(conn, _params) do
        conn
        |> send_resp(201, "")
    end

end