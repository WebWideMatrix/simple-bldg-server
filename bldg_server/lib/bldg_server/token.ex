defmodule BldgServer.Token do
  @moduledoc """
  Handles creating and validating tokens.
  """

    alias BldgServer.Residents.Resident

  # TODO use env variable
  @email_verification_salt "email verification salt"

  def generate_login_token(%Resident{id: resident_id}) do
    Phoenix.Token.sign(BldgServer.Endpoint, @email_verification_salt, resident_id)
  end

  def verify_login_token(token) do
    max_age = 86_400 # tokens that are older than a day should be invalid
    Phoenix.Token.verify(BldgServerWeb.Endpoint, @email_verification_salt, token, max_age: max_age)
  end
end