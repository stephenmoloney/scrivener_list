defmodule Scrivener.List.Mixfile do
  use Mix.Project
  @version "2.0.2"
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
      elixir: "~> 1.9",
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
      {:scrivener_ecto, "~> 3.0", optional: true},

      # dev/test
      {:earmark, "~> 1.4.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.37.0", only: :dev, runtime: false},
      {:postgrex, ">= 0.0.0", only: :test},
      {:ecto_sql, "~> 3.12.0", only: :test}
    ]
  end

  defp description() do
    ~S"""
    A scrivener/scrivener_ecto compatible extension that allows pagination of a list.
    """
  end

  defp package() do
    [
      maintainers: ["Stephen Moloney", "Fabian Becker"],
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
