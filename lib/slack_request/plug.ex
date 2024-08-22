defmodule SlackRequest.Plug do
  @moduledoc """
  Plug that automatically tries to verify timestamp and signature of the HTTP request
  to check is a valid Slack HQ HTTP request.

  It needs `SlackRequest.BodyReader.read_and_cache_body/2` to be set as the `Plug.Parsers`
  [`:body_reader`](`Plug.Parsers#module-options`).
  """

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
