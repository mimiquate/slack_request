defmodule SlackRequest do
  @moduledoc """
  Documentation for `SlackRequest`.

  Utilities for verifing an HTTP request can be authenticated as a request
  coming from Slack HQ.

  https://api.slack.com/authentication/verifying-requests-from-slack
  """

  @allowed_leeway 5 * 60
  @signature_header_key "x-slack-signature"
  @timestamp_header_key "x-slack-request-timestamp"
  @version "v0"

  def valid_timestamp?(conn) do
    abs(String.to_integer(timestamp(conn)) - System.system_time(:second)) <= @allowed_leeway
  end

  def valid_signature?(conn, opts \\ []) do
    body = Keyword.get_lazy(opts, :body, fn -> SlackRequest.BodyReader.get_raw_body(conn) end)
    secret = Keyword.get_lazy(opts, :secret, &signing_secret/0)

    hmac_hex =
      :crypto.mac(
        :hmac,
        :sha256,
        secret,
        "#{@version}:#{timestamp(conn)}:#{body}"
      )
      |> Base.encode16(case: :lower)

    signature(conn) == "#{@version}=#{hmac_hex}"
  end

  def timestamp(conn) do
    [timestamp] = Plug.Conn.get_req_header(conn, @timestamp_header_key)

    timestamp
  end

  def signature(conn) do
    [signature] = Plug.Conn.get_req_header(conn, @signature_header_key)

    signature
  end

  defp signing_secret do
    Application.fetch_env!(:slack_request, :signing_secret)
  end
end
