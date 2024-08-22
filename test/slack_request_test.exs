defmodule SlackRequestTest do
  use ExUnit.Case
  use Plug.Test
  doctest SlackRequest

  setup do
    {
      :ok,
      # From Slack Docs
      secret: "8f742231b10e8888abcd99yyyzzz85a5",
      signature: "v0=a2114d57b48eac39b9ad189dd8316235a7b4a8d21a10bd27519666489c69b503",
      timestamp: "1531420618",
      raw_body:
        "token=xyzz0WbapA4vBCDEFasx0q6G&team_id=T1DC2JH3J&team_domain=testteamnow&channel_id=G8PSS9T3V&channel_name=foobar&user_id=U2CERLKJA&user_name=roadrunner&command=%2Fwebhook-collect&text=&response_url=https%3A%2F%2Fhooks.slack.com%2Fcommands%2FT1DC2JH3J%2F397700885554%2F96rGlfmibIGlgcZRskXaIFfN&trigger_id=398738663015.47445629121.803a0bc887a14d10d2c447fce8b6703c"
    }
  end

  test "valid_signature? returns true if valid", context do
    conn =
      conn(:get, "/", "")
      |> put_req_header("x-slack-signature", context[:signature])
      |> put_req_header("x-slack-request-timestamp", context[:timestamp])
      |> put_private(:slack_request_raw_body_chunks, [context[:raw_body]])

    assert SlackRequest.valid_signature?(conn, secret: context[:secret])
  end

  test "valid_signature? returns false if signature NOT valid", context do
    conn =
      conn(:get, "/", "")
      |> put_req_header("x-slack-signature", context[:signature] <> "A")
      |> put_req_header("x-slack-request-timestamp", context[:timestamp])
      |> put_private(:slack_request_raw_body_chunks, [context[:raw_body]])

    refute SlackRequest.valid_signature?(conn, secret: context[:secret])
  end

  test "valid_signature? returns false if timestamp NOT valid", context do
    conn =
      conn(:get, "/", "")
      |> put_req_header("x-slack-signature", context[:signature])
      |> put_req_header("x-slack-request-timestamp", "0")
      |> put_private(:slack_request_raw_body_chunks, [context[:raw_body]])

    refute SlackRequest.valid_signature?(conn, secret: context[:secret])
  end

  test "valid_signature? returns false if timestamp NOT present", context do
    conn =
      conn(:get, "/", "")
      |> put_req_header("x-slack-signature", context[:signature])
      |> put_private(:slack_request_raw_body_chunks, [context[:raw_body]])

    refute SlackRequest.valid_signature?(conn, secret: context[:secret])
  end

  test "valid_signature? returns false if signature NOT present", context do
    conn =
      conn(:get, "/", "")
      |> put_req_header("x-slack-request-timestamp", context[:timestamp])
      |> put_private(:slack_request_raw_body_chunks, [context[:raw_body]])

    refute SlackRequest.valid_signature?(conn, secret: context[:secret])
  end
end
