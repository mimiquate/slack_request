# Inspired by: https://github.com/phoenixframework/phoenix/issues/459#issuecomment-862203762
defmodule SlackRequest.BodyReader do
  @moduledoc """
  Intended to be used as the [`:body_reader`](`Plug.Parsers#module-options`) option of `Plug.Parsers`.

  Keeps the raw body in a private conn assign so that it can be used later in the call stack
  for verification of the Slack HQ HTTP request timestamp and signtaure.

  Note that default `Plug.Conn.read_body/2` reads the body once but doesn't keep it for later further
  inspection.

  ## Example

  ```elixir
  # endpoint.ex
  Plug.Parsers,
    ...
    body_reader: {SlackRequest.BodyReader, :read_and_cache_body, []}
  ```

  So later, one can get the cached body with:

  ```elixir
  SlackRequest.BodyReader.cached_body(conn)
  ```
  """

  require Logger

  @raw_body_key :slack_request_raw_body_chunks

  @deprecated "Please use SlackRequest.BodyReader.read_and_cached_body/2 instead"
  @spec read_body(Plug.Conn.t(), Keyword.t()) ::
          {:ok, binary(), Plug.Conn.t()} | {:more, binary(), Plug.Conn.t()} | {:error, term()}
  def read_body(%Plug.Conn{} = conn, opts \\ []) do
    # Need runtime warning beacuse compile time warning won't show up for Plug.Parsers MFA configuration.
    Logger.warning(
      "[DEPRECATED] Please use SlackRequest.BodyReader.read_and_cache_body/2 instead of SlackRequest.BodyReader.read_body/2"
    )

    read_and_cache_body(conn, opts)
  end

  @spec read_and_cache_body(Plug.Conn.t(), Keyword.t()) ::
          {:ok, binary(), Plug.Conn.t()} | {:more, binary(), Plug.Conn.t()} | {:error, term()}
  def read_and_cache_body(%Plug.Conn{} = conn, opts \\ []) do
    case Plug.Conn.read_body(conn, opts) do
      {:ok, binary, conn} ->
        {:ok, binary, cache_body_chunk(conn, binary)}

      {:more, binary, conn} ->
        {:more, binary, cache_body_chunk(conn, binary)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @deprecated "Please use SlackRequest.BodyReader.cached_body/1 instead"
  @spec get_raw_body(Plug.Conn.t()) :: binary()
  def get_raw_body(%Plug.Conn{} = conn) do
    cached_body(conn)
  end

  @spec cached_body(Plug.Conn.t()) :: binary()
  def cached_body(%Plug.Conn{} = conn) do
    case conn.private[@raw_body_key] do
      nil -> nil
      chunks -> chunks |> Enum.reverse() |> Enum.join("")
    end
  end

  defp cache_body_chunk(%Plug.Conn{} = conn, chunk) when is_binary(chunk) do
    Plug.Conn.put_private(
      conn,
      @raw_body_key,
      [chunk | conn.private[@raw_body_key] || []]
    )
  end
end
