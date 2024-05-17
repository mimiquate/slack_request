# Inspired by: https://github.com/phoenixframework/phoenix/issues/459#issuecomment-862203762
defmodule SlackRequest.BodyReader do
  @moduledoc """
  A body reader that caches raw request body for later use.

  This module is intended to be used as the `:body_reader` option of `Plug.Parsers`.
  Note that caching is only enabled for specific paths. See `enabled_for?/1`.
  """

  @raw_body_key :slack_request_raw_body_chunks

  def read_body(%Plug.Conn{} = conn, opts \\ []) do
    case Plug.Conn.read_body(conn, opts) do
      {:ok, binary, conn} ->
        {:ok, binary, store_body_chunk(conn, binary)}

      {:more, binary, conn} ->
        {:more, binary, store_body_chunk(conn, binary)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def get_raw_body(%Plug.Conn{} = conn) do
    case conn.private[@raw_body_key] do
      nil -> nil
      chunks -> chunks |> Enum.reverse() |> Enum.join("")
    end
  end

  defp store_body_chunk(%Plug.Conn{} = conn, chunk) when is_binary(chunk) do
    chunks = conn.private[@raw_body_key] || []
    Plug.Conn.put_private(conn, @raw_body_key, [chunk | chunks])
  end
end
