defmodule BldgServer.Email do
  @moduledoc """
  Email notifications definitions
  """

  use Bamboo.Phoenix, view: BldgServer.EmailView

  @reply_to "dibaunaumh@gmail.com"
  @from "dibaunaumh@gmail.com"


  def login_verification_email(email_address, verification_url) do
    IO.inspect(email_address)
    base_email()
    |> to(email_address)
    |> subject("Login verification")
    |> text_body("Hi, please click on the following link to verify your email address: #{verification_url}")
  end

  def login_verification_html_email(email_address, verification_url) do
    login_verification_email(email_address, verification_url)
    |> html_body("<strong>Hi!<strong> <br> <p>Please <a href=#{verification_url}>click here</a> to verify your email address.</p>")
  end

  # TODO use views (see https://phoenixframework.readme.io/docs/sending-email)


  defp base_email() do
    new_email()
    |> put_header("Reply-To", @reply_to)
    |> from(@from)
  end
end