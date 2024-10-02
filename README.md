# 🔐 SlackRequest

Utilities for verifing an HTTP request can be authenticated as a request
coming from Slack HQ.

https://api.slack.com/authentication/verifying-requests-from-slack

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `slack_request` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:slack_request, "~> 1.0.0"}
  ]
end
```

## Usage

### Plug

Set `body_reader:` in `Plug.Parsers` inside your `Endpoint`.

```elixir
# lib/your_app_web/endpoint.ex

defmodule YourAppWeb.Endpoint do
  ...

  plug Plug.Parsers,
    ...
    body_reader: {SlackRequest.BodyReader, :read_and_cache_body, []}
end
```

Plug the `SlackRequest.Plug` in the pipeline that handles your Slack Requests/Webhooks.

Example:

```elixir
# lib/your_app_web/router.ex

defmodule YourAppWeb.Router do

  ...

  pipeline :slack do
    plug :accepts, ["json"]
    plug SlackRequest.Plug
  end

  scope "/slack", YourAppWeb do
    pipe_through :slack

    ...
  end
```

### Manual

Or if just prefer to use the validation function directly:

```elixir
# Somewhere were you're ready to validate the incoming request conn

if SlackRequest.valid_request?(conn, secret: signing_secret, body: raw_request_body) do
  # all good
else
  # handle invalid slack request/webhook
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/slack_request>.

## License

Copyright 2024 Mimiquate

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
