defmodule BldgServerWeb.MessageView do
  use BldgServerWeb, :view
  alias BldgServerWeb.MessageView

  def render("index.json", %{messages: messages}) do
    %{data: render_many(messages, MessageView, "message.json")}
  end

  def render("show.json", %{message: message}) do
    %{data: render_one(message, MessageView, "message.json")}
  end

  def render("message.json", %{message: message}) do
    %{id: message.id,
      sender: message.sender,
      sender_name: message.sender_name,
      message: message.message,
      flr: message.flr,
      message_type: message.message_type,
      in_reply_to_message: message.in_reply_to_message,
      recipient: message.recipient,
      speech_act: message.speech_act,
      entity_type: message.entity_type,
      entity_id: message.entity_id,
      params: message.params}
  end
end
