defmodule ElixirSoHost.Mixfile do
  use Mix.Project

  def project do
    [app: :elixir_so_host,
     version: "0.1.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:poolboy, "~> 1.5"}]
  end
end
