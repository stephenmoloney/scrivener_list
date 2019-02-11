defmodule Scrivener.List.Mixfile do
  use Mix.Project
  @version "2.0.1"
  @name "Scrivener.List"
  @source_url "https://github.com/stephenmoloney/scrivener_list"
  @homepage_url "https://hexdocs.pm/scrivener_list"

  def project do
    [
      app: :scrivener_list,
      name: @name,
      version: @version,
      source_url: @source_url,
      homepage_url: @homepage_url,
      elixir: "~> 1.3",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  def extra_applications do
    [applications: [:logger]]
  end

  defp deps() do
    [
      {:scrivener_ecto, "~> 1.0 or ~> 2.0"},

      # dev/test
      {:earmark, "~> 1.3", only: :dev, runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:postgrex, ">= 0.0.0", only: :test},
      {:ecto_sql, "~> 3.0", only: :test}
    ]
  end

  defp description() do
    ~S"""
    A scrivener/scrivener_ecto compatible extension that allows pagination of a list.
    """
  end

  defp package() do
    [
      maintainers: ["Stephen Moloney"],
      licenses: ["MIT"],
      links: %{"github" => "https://github.com/stephenmoloney/scrivener_list"},
      files: [
        "lib/scrivener/paginater/list.ex",
        "mix.exs",
        "README.md"
      ]
    ]
  end

  defp docs do
    [
      main: "readme",
      extra_section: "Scrivener.List",
      extras: [
        "README.md": [path: "README.md", title: "Scrivener.List"]
      ]
    ]
  end
end
