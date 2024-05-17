defmodule SlackRequest.Plug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    if SlackRequest.valid_timestamp?(conn) && SlackRequest.valid_signature?(conn) do
      conn
    else
      conn
      |> send_resp(401, "Not Authorized")
      |> halt()
    end
  end
end
