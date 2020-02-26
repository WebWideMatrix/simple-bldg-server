defmodule BldgServerWeb.BldgControllerTest do
  use BldgServerWeb.ConnCase

  alias BldgServer.Buildings
  alias BldgServer.Buildings.Bldg

  @create_attrs %{
    address: "some address",
    category: "some category",
    data: %{},
    entity_type: "some entity_type",
    flr: "some flr",
    is_composite: true,
    name: "some name",
    picture_url: "some picture_url",
    state: "some state",
    summary: "some summary",
    tags: [],
    web_url: "some web_url",
    x: 42,
    y: 42
  }
  @update_attrs %{
    address: "some updated address",
    category: "some updated category",
    data: %{},
    entity_type: "some updated entity_type",
    flr: "some updated flr",
    is_composite: false,
    name: "some updated name",
    picture_url: "some updated picture_url",
    state: "some updated state",
    summary: "some updated summary",
    tags: [],
    web_url: "some updated web_url",
    x: 43,
    y: 43
  }
  @invalid_attrs %{address: nil, category: nil, data: nil, entity_type: nil, flr: nil, is_composite: nil, name: nil, picture_url: nil, state: nil, summary: nil, tags: nil, web_url: nil, x: nil, y: nil}

  def fixture(:bldg) do
    {:ok, bldg} = Buildings.create_bldg(@create_attrs)
    bldg
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all bldgs", %{conn: conn} do
      conn = get(conn, Routes.bldg_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create bldg" do
    test "renders bldg when data is valid", %{conn: conn} do
      conn = post(conn, Routes.bldg_path(conn, :create), bldg: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.bldg_path(conn, :show, id))

      assert %{
               "id" => id,
               "address" => "some address",
               "category" => "some category",
               "data" => %{},
               "entity_type" => "some entity_type",
               "flr" => "some flr",
               "is_composite" => true,
               "name" => "some name",
               "picture_url" => "some picture_url",
               "state" => "some state",
               "summary" => "some summary",
               "tags" => [],
               "web_url" => "some web_url",
               "x" => 42,
               "y" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.bldg_path(conn, :create), bldg: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update bldg" do
    setup [:create_bldg]

    test "renders bldg when data is valid", %{conn: conn, bldg: %Bldg{id: id} = bldg} do
      conn = put(conn, Routes.bldg_path(conn, :update, bldg), bldg: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.bldg_path(conn, :show, id))

      assert %{
               "id" => id,
               "address" => "some updated address",
               "category" => "some updated category",
               "data" => {},
               "entity_type" => "some updated entity_type",
               "flr" => "some updated flr",
               "is_composite" => false,
               "name" => "some updated name",
               "picture_url" => "some updated picture_url",
               "state" => "some updated state",
               "summary" => "some updated summary",
               "tags" => [],
               "web_url" => "some updated web_url",
               "x" => 43,
               "y" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, bldg: bldg} do
      conn = put(conn, Routes.bldg_path(conn, :update, bldg), bldg: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete bldg" do
    setup [:create_bldg]

    test "deletes chosen bldg", %{conn: conn, bldg: bldg} do
      conn = delete(conn, Routes.bldg_path(conn, :delete, bldg))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.bldg_path(conn, :show, bldg))
      end
    end
  end

  defp create_bldg(_) do
    bldg = fixture(:bldg)
    {:ok, bldg: bldg}
  end
end
