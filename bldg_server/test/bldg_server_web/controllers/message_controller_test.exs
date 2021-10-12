defmodule BldgServerWeb.MessageControllerTest do
  use BldgServerWeb.ConnCase

  alias BldgServer.Chat
  alias BldgServer.Chat.Message

  @create_attrs %{
    entity_id: "some entity_id",
    entity_type: "some entity_type",
    flr: "some flr",
    in_reply_to_message: "some in_reply_to_message",
    message: "some message",
    message_type: "some message_type",
    params: "some params",
    recipient: "some recipient",
    sender: "some sender",
    sender_name: "some sender_name",
    speech_act: "some speech_act"
  }
  @update_attrs %{
    entity_id: "some updated entity_id",
    entity_type: "some updated entity_type",
    flr: "some updated flr",
    in_reply_to_message: "some updated in_reply_to_message",
    message: "some updated message",
    message_type: "some updated message_type",
    params: "some updated params",
    recipient: "some updated recipient",
    sender: "some updated sender",
    sender_name: "some updated sender_name",
    speech_act: "some updated speech_act"
  }
  @invalid_attrs %{entity_id: nil, entity_type: nil, flr: nil, in_reply_to_message: nil, message: nil, message_type: nil, params: nil, recipient: nil, sender: nil, sender_name: nil, speech_act: nil}

  def fixture(:message) do
    {:ok, message} = Chat.create_message(@create_attrs)
    message
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all messages", %{conn: conn} do
      conn = get(conn, Routes.message_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create message" do
    test "renders message when data is valid", %{conn: conn} do
      conn = post(conn, Routes.message_path(conn, :create), message: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.message_path(conn, :show, id))

      assert %{
               "id" => id,
               "entity_id" => "some entity_id",
               "entity_type" => "some entity_type",
               "flr" => "some flr",
               "in_reply_to_message" => "some in_reply_to_message",
               "message" => "some message",
               "message_type" => "some message_type",
               "params" => "some params",
               "recipient" => "some recipient",
               "sender" => "some sender",
               "sender_name" => "some sender_name",
               "speech_act" => "some speech_act"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.message_path(conn, :create), message: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update message" do
    setup [:create_message]

    test "renders message when data is valid", %{conn: conn, message: %Message{id: id} = message} do
      conn = put(conn, Routes.message_path(conn, :update, message), message: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.message_path(conn, :show, id))

      assert %{
               "id" => id,
               "entity_id" => "some updated entity_id",
               "entity_type" => "some updated entity_type",
               "flr" => "some updated flr",
               "in_reply_to_message" => "some updated in_reply_to_message",
               "message" => "some updated message",
               "message_type" => "some updated message_type",
               "params" => "some updated params",
               "recipient" => "some updated recipient",
               "sender" => "some updated sender",
               "sender_name" => "some updated sender_name",
               "speech_act" => "some updated speech_act"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, message: message} do
      conn = put(conn, Routes.message_path(conn, :update, message), message: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete message" do
    setup [:create_message]

    test "deletes chosen message", %{conn: conn, message: message} do
      conn = delete(conn, Routes.message_path(conn, :delete, message))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.message_path(conn, :show, message))
      end
    end
  end

  defp create_message(_) do
    message = fixture(:message)
    {:ok, message: message}
  end
end
