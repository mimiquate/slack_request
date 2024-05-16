defmodule SlackRequest.Plug do
  import Plug.Conn

  @allowed_leeway 5 * 60
  @signature_header_key "x-slack-signature"
  @timestamp_header_key "x-slack-request-timestamp"
  @version "v0"

  def init(opts), do: opts

  def call(conn, _opts) do
    if valid_timestamp?(conn) && valid_signature?(conn) do
      conn
    else
      conn
      |> send_resp(401, "Not Authorized")
      |> halt()
    end
  end

  defp valid_timestamp?(conn) do
    abs(String.to_integer(timestamp(conn)) - System.system_time(:second)) <= @allowed_leeway
  end

  defp valid_signature?(conn) do
    body = SlackRequest.BodyReader.get_raw_body(conn)

    hmac_hex =
      :crypto.mac(
        :hmac,
        :sha256,
        # Application.fetch_env!(:slack_request, :signing_secret),
        Application.fetch_env!(:just_polls, :slack_signing_secret),
        "#{@version}:#{timestamp(conn)}:#{body}"
      )
      |> Base.encode16(case: :lower)

    signature(conn) == "#{@version}=#{hmac_hex}"
  end

  defp timestamp(conn) do
    [timestamp] = get_req_header(conn, @timestamp_header_key)

    timestamp
  end

  defp signature(conn) do
    [signature] = get_req_header(conn, @signature_header_key)

    signature
  end
end
