defmodule BldgServer.Token do
  @moduledoc """
  Handles creating and validating tokens.
  """

  # TODO use env variable
  @email_verification_salt "email verification salt"

  def generate_login_token(%Resident{id: resident_id}) do
    Phoenix.Token.sign(BldgServer.Endpoint, @email_verification_salt, resident_id)
  end
end