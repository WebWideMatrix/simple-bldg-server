defmodule BldgServerWeb.ResidentControllerTest do
  use BldgServerWeb.ConnCase

  alias BldgServer.Residents
  alias BldgServer.Residents.Resident

  @create_attrs %{
    alias: "some alias",
    direction: 42,
    email: "some email",
    home_bldg: "some home_bldg",
    is_online: false,
    last_login_at: ~N[2010-04-17 14:00:00],
    location: "g-b(17,24)-l0-b(4,5)",
    flr: "g-b(17,24)-l0",
    name: "some name",
    other_attributes: %{},
    previous_messages: [],
    session_id: "7488a646-e31f-11e4-aace-600308960662"
  }
  @update_attrs %{
    alias: "some updated alias",
    direction: 43,
    email: "some updated email",
    home_bldg: "some updated home_bldg",
    is_online: true,
    last_login_at: ~N[2011-05-18 15:01:01],
    location: "g-b(17,24)-l0-b(6,8)",
    flr: "g-b(17,24)-l0",
    name: "some updated name",
    other_attributes: %{},
    previous_messages: [],
    session_id: "7488a646-e31f-11e4-aace-600308960668"
  }
  @invalid_attrs %{alias: nil, direction: nil, email: nil, home_bldg: nil, is_online: nil, last_login_at: nil, location: nil, name: nil, other_attributes: nil, previous_messages: nil, session_id: nil}

  def fixture(:resident) do
    {:ok, resident} = Residents.create_resident(@create_attrs)
    resident
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all residents", %{conn: conn} do
      conn = get(conn, Routes.resident_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create resident" do
    test "renders resident when data is valid", %{conn: conn} do
      conn = post(conn, Routes.resident_path(conn, :create), resident: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.resident_path(conn, :show, id))

      assert %{
               "id" => id,
               "alias" => "some alias",
               "direction" => 42,
               "email" => "some email",
               "home_bldg" => "some home_bldg",
               "is_online" => false,
               "last_login_at" => "2010-04-17T14:00:00",
               "location" => "g-b(17,24)-l0-b(4,5)",
               "flr" => "g-b(17,24)-l0",
               "name" => "some name",
               "other_attributes" => %{},
               "previous_messages" => [],
               "session_id" => "7488a646-e31f-11e4-aace-600308960662"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.resident_path(conn, :create), resident: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update resident" do
    setup [:create_resident]

    test "renders resident when data is valid", %{conn: conn, resident: %Resident{id: id} = resident} do
      conn = put(conn, Routes.resident_path(conn, :update, resident), resident: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.resident_path(conn, :show, id))

      assert %{
               "id" => id,
               "alias" => "some updated alias",
               "direction" => 43,
               "email" => "some updated email",
               "home_bldg" => "some updated home_bldg",
               "is_online" => true,
               "last_login_at" => "2011-05-18T15:01:01",
               "location" => "g-b(17,24)-l0-b(6,8)",
               "flr" => "g-b(17,24)-l0",
               "name" => "some updated name",
               "other_attributes" => %{},
               "previous_messages" => [],
               "session_id" => "7488a646-e31f-11e4-aace-600308960668"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, resident: resident} do
      conn = put(conn, Routes.resident_path(conn, :update, resident), resident: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "login resident" do
    setup [:create_resident]

    test "logs in a resident when data is valid", %{conn: conn, resident: %Resident{id: id} = resident} do
      conn = post(conn, "/v1/residents/login", email: "some email")
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.resident_path(conn, :show, id))
      expected_last_login = DateTime.utc_now()
      assert %{
               "id" => id,
               "alias" => "some alias",
               "direction" => 42,
               "email" => "some email",
               "home_bldg" => "some home_bldg",
               "is_online" => true,
               "last_login_at" => expected_last_login,
               "location" => "g-b(17,24)-l0-b(4,5)",
               "flr" => "g-b(17,24)-l0",
               "name" => "some name",
               "other_attributes" => %{},
               "previous_messages" => [],
               "session_id" => "7488a646-e31f-11e4-aace-600308960662"
             } = json_response(conn, 200)["data"]
    end

  end


  describe "delete resident" do
    setup [:create_resident]

    test "deletes chosen resident", %{conn: conn, resident: resident} do
      conn = delete(conn, Routes.resident_path(conn, :delete, resident))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.resident_path(conn, :show, resident))
      end
    end
  end

  defp create_resident(_) do
    resident = fixture(:resident)
    {:ok, resident: resident}
  end
end
