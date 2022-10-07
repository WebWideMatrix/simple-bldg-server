defmodule BldgServerWeb.BatteryControllerTest do
  use BldgServerWeb.ConnCase

  alias BldgServer.Batteries
  alias BldgServer.Batteries.Battery

  @create_attrs %{
    battery_type: "some battery_type",
    battery_vendor: "some battery_vendor",
    battery_version: "some battery_version",
    bldg_address: "some bldg_address",
    callback_url: "some callback_url",
    direct_only: true,
    flr: "some flr",
    is_attached: true
  }
  @update_attrs %{
    battery_type: "some updated battery_type",
    battery_vendor: "some updated battery_vendor",
    battery_version: "some updated battery_version",
    bldg_address: "some updated bldg_address",
    callback_url: "some updated callback_url",
    direct_only: false,
    flr: "some updated flr",
    is_attached: false
  }
  @invalid_attrs %{battery_type: nil, battery_vendor: nil, battery_version: nil, bldg_address: nil, callback_url: nil, direct_only: nil, flr: nil, is_attached: nil}

  def fixture(:battery) do
    {:ok, battery} = Batteries.create_battery(@create_attrs)
    battery
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all batteries", %{conn: conn} do
      conn = get(conn, Routes.battery_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create battery" do
    test "renders battery when data is valid", %{conn: conn} do
      conn = post(conn, Routes.battery_path(conn, :create), battery: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.battery_path(conn, :show, id))

      assert %{
               "id" => id,
               "battery_type" => "some battery_type",
               "battery_vendor" => "some battery_vendor",
               "battery_version" => "some battery_version",
               "bldg_address" => "some bldg_address",
               "callback_url" => "some callback_url",
               "direct_only" => true,
               "flr" => "some flr",
               "is_attached" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.battery_path(conn, :create), battery: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update battery" do
    setup [:create_battery]

    test "renders battery when data is valid", %{conn: conn, battery: %Battery{id: id} = battery} do
      conn = put(conn, Routes.battery_path(conn, :update, battery), battery: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.battery_path(conn, :show, id))

      assert %{
               "id" => id,
               "battery_type" => "some updated battery_type",
               "battery_vendor" => "some updated battery_vendor",
               "battery_version" => "some updated battery_version",
               "bldg_address" => "some updated bldg_address",
               "callback_url" => "some updated callback_url",
               "direct_only" => false,
               "flr" => "some updated flr",
               "is_attached" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, battery: battery} do
      conn = put(conn, Routes.battery_path(conn, :update, battery), battery: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete battery" do
    setup [:create_battery]

    test "deletes chosen battery", %{conn: conn, battery: battery} do
      conn = delete(conn, Routes.battery_path(conn, :delete, battery))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.battery_path(conn, :show, battery))
      end
    end
  end

  defp create_battery(_) do
    battery = fixture(:battery)
    {:ok, battery: battery}
  end
end
