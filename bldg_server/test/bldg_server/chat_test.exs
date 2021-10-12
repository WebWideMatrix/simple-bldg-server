defmodule BldgServer.ChatTest do
  use BldgServer.DataCase

  alias BldgServer.Chat

  describe "messages" do
    alias BldgServer.Chat.Message

    @valid_attrs %{entity_id: "some entity_id", entity_type: "some entity_type", flr: "some flr", in_reply_to_message: "some in_reply_to_message", message: "some message", message_type: "some message_type", params: "some params", recipient: "some recipient", sender: "some sender", sender_name: "some sender_name", speech_act: "some speech_act"}
    @update_attrs %{entity_id: "some updated entity_id", entity_type: "some updated entity_type", flr: "some updated flr", in_reply_to_message: "some updated in_reply_to_message", message: "some updated message", message_type: "some updated message_type", params: "some updated params", recipient: "some updated recipient", sender: "some updated sender", sender_name: "some updated sender_name", speech_act: "some updated speech_act"}
    @invalid_attrs %{entity_id: nil, entity_type: nil, flr: nil, in_reply_to_message: nil, message: nil, message_type: nil, params: nil, recipient: nil, sender: nil, sender_name: nil, speech_act: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chat.create_message()

      message
    end

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Chat.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Chat.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} = Chat.create_message(@valid_attrs)
      assert message.entity_id == "some entity_id"
      assert message.entity_type == "some entity_type"
      assert message.flr == "some flr"
      assert message.in_reply_to_message == "some in_reply_to_message"
      assert message.message == "some message"
      assert message.message_type == "some message_type"
      assert message.params == "some params"
      assert message.recipient == "some recipient"
      assert message.sender == "some sender"
      assert message.sender_name == "some sender_name"
      assert message.speech_act == "some speech_act"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      assert {:ok, %Message{} = message} = Chat.update_message(message, @update_attrs)
      assert message.entity_id == "some updated entity_id"
      assert message.entity_type == "some updated entity_type"
      assert message.flr == "some updated flr"
      assert message.in_reply_to_message == "some updated in_reply_to_message"
      assert message.message == "some updated message"
      assert message.message_type == "some updated message_type"
      assert message.params == "some updated params"
      assert message.recipient == "some updated recipient"
      assert message.sender == "some updated sender"
      assert message.sender_name == "some updated sender_name"
      assert message.speech_act == "some updated speech_act"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Chat.update_message(message, @invalid_attrs)
      assert message == Chat.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Chat.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Chat.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Chat.change_message(message)
    end
  end
end
