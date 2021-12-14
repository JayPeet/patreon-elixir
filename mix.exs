defmodule Patreon.MixProject do
  use Mix.Project

  def project do
    [
      app: :patreon,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:tesla, "~> 1.4"},
      {:mime, "~> 2.0", override: true},
      {:telemetry, "~> 1.0", override: true},
      {:jason, "~> 1.2"}
    ]
  end
end
