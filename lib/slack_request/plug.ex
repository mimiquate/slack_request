defmodule SlackRequest.Plug do
  import Plug.Conn

  @not_authorized_body "Not Authorized"

  def init(opts), do: opts

  def call(conn, _opts) do
    if SlackRequest.valid_timestamp?(conn) && SlackRequest.valid_signature?(conn) do
      conn
    else
      conn
      |> send_resp(401, @not_authorized_body)
      |> halt()
    end
  end
end
