# Conditional for GitHub Dependabot
if File.exists?("blend/premix.exs") do
  Code.compile_file("blend/premix.exs")
end

defmodule SlackRequest.MixProject do
  use Mix.Project

  @description "Verifying requests from Slack"
  @source_url "https://github.com/mimiquate/slack_request"
  @changelog_url @source_url <> "/blob/-/CHANGELOG.md"
  @version "1.0.0"

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
    |> Keyword.merge(maybe_lockfile_option())
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
      {:blend, github: "mimiquate/blend", branch: "rearrenge_folder_structure", only: :dev},
      {:ex_doc, "~> 0.37.1", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @source_url,
        "Changelog" => @changelog_url
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end

  defp maybe_lockfile_option do
    case System.get_env("MIX_LOCKFILE") do
      nil -> []
      "" -> []
      lockfile -> [lockfile: lockfile]
    end
  end
end
