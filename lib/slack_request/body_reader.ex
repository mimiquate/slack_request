# Inspired by: https://github.com/phoenixframework/phoenix/issues/459#issuecomment-862203762
defmodule SlackRequest.BodyReader do
  @moduledoc """
  Intended to be used as the [`:body_reader`](`Plug.Parsers#module-options`) option of `Plug.Parsers`.

  Keeps the raw body in a private conn assign so that it can be used later in the call stack
  for verification of the Slack HQ HTTP request timestamp and signtaure.

  Note that `Plug.Conn.read_body/2` reads the body once but doesn't keep it for later further
  inspection.
  """

  @raw_body_key :slack_request_raw_body_chunks

  @spec read_body(Plug.Conn.t(), Keyword.t()) ::
          {:ok, binary(), Plug.Conn.t()} | {:more, binary(), Plug.Conn.t()} | {:error, term()}
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

  @spec get_raw_body(Plug.Conn.t()) :: binary()
  def get_raw_body(%Plug.Conn{} = conn) do
    case conn.private[@raw_body_key] do
      nil -> nil
      chunks -> chunks |> Enum.reverse() |> Enum.join("")
    end
  end

  defp store_body_chunk(%Plug.Conn{} = conn, chunk) when is_binary(chunk) do
    Plug.Conn.put_private(
      conn,
      @raw_body_key,
      [chunk | conn.private[@raw_body_key] || []]
    )
  end
end
