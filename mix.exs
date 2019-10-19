defmodule DatabaseWorker.MixProject do
  use Mix.Project

  def project do
    [
      app: :database_worker,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DatabaseWorker.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:freddy, "~> 0.15.0"}
    ]
  end
end
