defmodule Scrivener.List.Mixfile do
  use Mix.Project

  def project do
    [
     app: :scrivener_list,
     version: "0.9.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     source_url: "https://github.com/stephenmoloney/scrivener_list",
     homepage_url: "https://hexdocs.pm/scrivener_list",
     description: description,
     package: package,
     deps: deps,
     docs: [
       main: "README.md",
       extra_section: "Readme",
       extras: ["README.md": [path: "README.md", title: "Readme"]]
     ]
    ]
  end


  def application do
    [applications: [:logger]]
  end


  defp deps do
    [
     {:scrivener, github: "drewolson/scrivener", branch: "v2"},
     {:ex_spec, "~> 1.0", only: :test},
     {:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.11", only: :dev}
    ]
  end


  defp description do
    ~S"""
    A [scrivener](https://github.com/drewolson/scrivener) compatible extension that allows pagination of a list.
    """
  end


  defp package do
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


end
