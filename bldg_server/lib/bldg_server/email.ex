defmodule BldgServer.Email do
  @moduledoc """
  Email notifications definitions
  """

  use Bamboo.Phoenix, view: BldgServer.EmailView

  def login_verification_email(email_address, verification_url) do
    new_email()
    |> to(email_address)
    |> from("noreply@api.w2m.site")
    |> subject("Login verification")
    |> text_body("Hi, please click on the following link to verify your email address: #{verification_url}")
  end

  def login_verification_html_email(email_address, verification_url) do
    login_verification_email(email_address, verification_url)
    |> html_body("<strong>Hi!<strong> <br> <p>Please <a href=#{verification_url}>click here</a> to verify your email address.</p>")
  end

  # TODO use views (see https://phoenixframework.readme.io/docs/sending-email)

end