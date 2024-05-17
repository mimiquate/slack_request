defmodule SlackRequest.Plug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    if SlackRequest.valid_timestamp?(conn) &&
         SlackRequest.valid_signature?(conn, signing_secret()) do
      conn
    else
      conn
      |> send_resp(401, "Not Authorized")
      |> halt()
    end
  end

  defp signing_secret do
    Application.fetch_env!(:slack_request, :signing_secret)
  end
end
