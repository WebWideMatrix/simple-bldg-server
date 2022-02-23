defmodule BldgServer.Notifications do
  @moduledoc """
  Email communications to users.
  """
  alias BldgServer.Residents.Resident
  alias BldgServer.Mailer
  

  def send_login_verification_email(%Resident{email: resident_email}, verification_url) do
    BldgServer.Email.login_verification_email(resident_email, verification_url) 
    |> Mailer.deliver_now()
  end

end