defmodule OpenBudget.Guardian.AuthErrorHandler do
  @moduledoc """
  Handler required by Guardian pipeline
  """
  import Plug.Conn

  def auth_error(conn, {type, reason}, _opts) do
    body = Poison.encode!(%{message: to_string(type)})
    send_resp(conn, 401, body)
  end
end
