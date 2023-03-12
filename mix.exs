defmodule Anidiff.MixProject do
  use Mix.Project

  def project do
    [
      app: :anidiff,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Anidiff.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:finch, "~> 0.14"},
      {:jason, "~> 1.4"},
      {:floki, "~> 0.34.2"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.2", only: [:dev], runtime: false}
    ]
  end
end
