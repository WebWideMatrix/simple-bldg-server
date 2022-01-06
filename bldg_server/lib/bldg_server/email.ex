defmodule BldgServer.Email do
  @moduledoc """
  Email notifications definitions
  """

  use Bamboo.Phoenix, view: BldgServer.EmailView

  def login_verification_email(resident_email, verification_url) do
    new_email
    |> to(resident_email)
    |> from("noreply@api.w2m.site")
    |> subject("Login verification")
    |> text_body("Hi, please click on the following link, in order to verify your email address: ${verification_url}")
  end

end