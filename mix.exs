defmodule SlackRequest.MixProject do
  use Mix.Project

  @description "Verifying requests from Slack"
  @source_url "https://github.com/mimiquate/slack_request"
  @version "0.1.0"

  def project do
    [
      app: :slack_request,
      description: @description,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),

      # Docs
      name: "SlackRequest",
      source_url: @source_url,
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.13"},

      # Dev
      {:blend, "~> 0.3.0", only: :dev},
      {:ex_doc, "~> 0.32.2", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end

  defp docs do
    [
      extras: ["README.md"]
    ]
  end
end
