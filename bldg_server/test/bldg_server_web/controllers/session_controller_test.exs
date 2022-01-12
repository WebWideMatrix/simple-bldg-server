defmodule BldgServerWeb.SessionControllerTest do
  use BldgServerWeb.ConnCase

  alias BldgServer.ResidentsAuth
  alias BldgServer.ResidentsAuth.Session

  @create_attrs %{
    email: "some email",
    ip_address: "some ip_address",
    last_activity_time: ~N[2010-04-17 14:00:00],
    resident_id: 42,
    session_id: "7488a646-e31f-11e4-aace-600308960662",
    status: "some status"
  }
  @update_attrs %{
    email: "some updated email",
    ip_address: "some updated ip_address",
    last_activity_time: ~N[2011-05-18 15:01:01],
    resident_id: 43,
    session_id: "7488a646-e31f-11e4-aace-600308960668",
    status: "some updated status"
  }
  @invalid_attrs %{email: nil, ip_address: nil, last_activity_time: nil, resident_id: nil, session_id: nil, status: nil}

  def fixture(:session) do
    {:ok, session} = ResidentsAuth.create_session(@create_attrs)
    session
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all sessions", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create session" do
    test "renders session when data is valid", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), session: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.session_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "some email",
               "ip_address" => "some ip_address",
               "last_activity_time" => "2010-04-17T14:00:00",
               "resident_id" => 42,
               "session_id" => "7488a646-e31f-11e4-aace-600308960662",
               "status" => "some status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), session: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update session" do
    setup [:create_session]

    test "renders session when data is valid", %{conn: conn, session: %Session{id: id} = session} do
      conn = put(conn, Routes.session_path(conn, :update, session), session: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.session_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "some updated email",
               "ip_address" => "some updated ip_address",
               "last_activity_time" => "2011-05-18T15:01:01",
               "resident_id" => 43,
               "session_id" => "7488a646-e31f-11e4-aace-600308960668",
               "status" => "some updated status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, session: session} do
      conn = put(conn, Routes.session_path(conn, :update, session), session: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete session" do
    setup [:create_session]

    test "deletes chosen session", %{conn: conn, session: session} do
      conn = delete(conn, Routes.session_path(conn, :delete, session))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.session_path(conn, :show, session))
      end
    end
  end

  defp create_session(_) do
    session = fixture(:session)
    %{session: session}
  end
end
