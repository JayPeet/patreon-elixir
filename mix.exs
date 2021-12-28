defmodule Patreon.MixProject do
  use Mix.Project

  def project do
    [
      app: :patreon,
      version: "0.2.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      #name: "Patreon",
      #source_url: "https://github.com/jaypeet/patreon-elixir",
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
      {:ex_doc, "~> 0.26.0", only: :dev, runtime: false},
      {:tesla, "~> 1.4"},
      {:jason, "~> 1.2"}
    ]
  end

  defp description() do
    "An Elixir wrapper around the Patreon API"
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/jaypeet/patreon-elixir"}
    ]
  end
end
